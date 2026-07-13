#!/usr/bin/env python3
"""
Failure Categorizer.
Reads lint/synth/sim results for every module and assigns exactly one final
verdict (PASS or FAIL) and, for failures, exactly one specific failure_category
drawn from a fixed taxonomy, based on which stage failed and the specific
tool error/warning text. This is rule-based and deterministic -- no LLM
judgment is used to decide pass/fail, only tool output.

Taxonomy (checked in this priority order):
  1. syntax_error            - lint or synth stage reports a parse/syntax error
  2. non_synthesizable       - lint passes (parses as valid Verilog) but Yosys
                                synthesis fails (e.g. unsupported construct)
  3. toolchain_incompatible  - synthesis failed for a reason that looks like a
                                Yosys/Icarus limitation rather than an LLM RTL
                                error (heuristic, explicitly flagged as such)
  4. latch_inferred          - synthesis succeeded but Yosys warned about
                                inferred latches (usually an incomplete
                                combinational case/if -- a real RTL bug)
  5. compile_error_sim       - module synthesizes fine standalone but fails to
                                compile against the paired testbench (e.g.
                                interface/port mismatch vs the spec)
  6. sim_mismatch            - compiles and simulates but produces incorrect
                                output vs the reference testbench
  7. sim_timeout             - simulation did not terminate in the allotted time
  8. unknown                 - did not fit any of the above; needs manual review
"""
import json
import os
import sqlite3

ROOT = os.path.join(os.path.dirname(__file__), "..")
DB_PATH = os.path.join(ROOT, "results_db", "results.db")

TOOLCHAIN_LIMITATION_MARKERS = [
    "unsupported",
    "not supported",
    "can't infer",
]


def categorize(lint_row, synth_row, sim_row):
    """Returns (verdict, category, detail)."""
    lint_passed = lint_row[0] if lint_row else None
    lint_log = lint_row[1] if lint_row else ""

    synth_passed = synth_row[0] if synth_row else None
    latch_warn = synth_row[3] if synth_row else 0
    synth_log = synth_row[5] if synth_row else ""

    sim_ran = sim_row[0] if sim_row else 0
    sim_passed = sim_row[1] if sim_row else None
    sim_log = sim_row[3] if sim_row else ""
    sim_timed_out = sim_row[4] if sim_row else 0

    # 1. syntax error at lint stage
    if lint_row is not None and lint_passed == 0:
        return "FAIL", "syntax_error", lint_log[:2000]

    # 2/3. synthesis failure despite valid lint
    if synth_row is not None and synth_passed == 0:
        lower_log = (synth_log or "").lower()
        if any(marker in lower_log for marker in TOOLCHAIN_LIMITATION_MARKERS):
            return "FAIL", "toolchain_incompatible", synth_log[:2000]
        return "FAIL", "non_synthesizable", synth_log[:2000]

    # 5. sim compile error (didn't even run)
    if sim_row is not None and sim_ran == 0:
        return "FAIL", "compile_error_sim", sim_log[:2000]

    if sim_row is not None and sim_log and "COMPILE_ERROR" in sim_log:
        return "FAIL", "compile_error_sim", sim_log[:2000]

    # 7. sim timeout
    if sim_row is not None and sim_timed_out:
        return "FAIL", "sim_timeout", sim_log[:2000]

    # 4. latch inferred (only flagged as the primary failure if sim also didn't clearly pass,
    #    OR flagged as a quality warning on a pass -- but per spec, an inferred latch on
    #    combinational logic is itself a correctness bug worth surfacing as FAIL if it
    #    also caused a sim mismatch; if sim passed anyway, we note it but keep verdict PASS
    #    since the objective check is the testbench)
    if sim_row is not None and sim_passed == 1:
        if latch_warn:
            # passed simulation but yosys flagged latch inference -- real signal,
            # but sim is the ground truth for correctness per this benchmark's methodology
            return "PASS", None, "NOTE: synthesis stage warned about inferred latch(es) despite passing simulation -- see synth log"
        return "PASS", None, None

    # 6. sim mismatch (ran, but failed)
    if sim_row is not None and sim_passed == 0:
        if latch_warn:
            return "FAIL", "latch_inferred", synth_log[:2000] + "\n---SIM---\n" + sim_log[:1000]
        return "FAIL", "sim_mismatch", sim_log[:2000]

    # Fallback
    return "FAIL", "unknown", "Insufficient pipeline data to categorize"


def main():
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    cur.execute("SELECT module_name FROM modules")
    module_names = [r[0] for r in cur.fetchall()]

    for name in module_names:
        cur.execute("SELECT passed, raw_log FROM lint_results WHERE module_name=?", (name,))
        lint_row = cur.fetchone()

        cur.execute("SELECT passed, num_cells, num_wires, latch_warning, width_mismatch_warning, raw_log FROM synth_results WHERE module_name=?", (name,))
        synth_row = cur.fetchone()

        cur.execute("SELECT ran, passed, mismatch_count, raw_log, timed_out FROM sim_results WHERE module_name=?", (name,))
        sim_row = cur.fetchone()

        verdict, category, detail = categorize(lint_row, synth_row, sim_row)

        cur.execute(
            "INSERT OR REPLACE INTO verdicts (module_name, final_verdict, failure_category, failure_detail) VALUES (?, ?, ?, ?)",
            (name, verdict, category, detail)
        )
        print(f"[{verdict}] {name}" + (f" -- {category}" if category else ""))

    conn.commit()
    conn.close()


if __name__ == "__main__":
    main()
