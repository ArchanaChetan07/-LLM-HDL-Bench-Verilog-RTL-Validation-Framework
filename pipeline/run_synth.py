#!/usr/bin/env python3
"""
Lint + Synthesis stage.
Runs every generated module through Yosys, regardless of whether it will later
pass simulation. Captures synthesizability, warnings (latch inference, width
mismatches), and basic cell/wire counts. No filtering: every module is attempted.
"""
import json
import os
import re
import shutil
import sqlite3
import subprocess
import sys

ROOT = os.path.join(os.path.dirname(__file__), "..")
DB_PATH = os.path.join(ROOT, "results_db", "results.db")
GENERATED_DIR = os.path.join(ROOT, "generated")
MANIFEST_PATH = os.path.join(ROOT, "prompts", "manifest.json")

YOSYS_TIMEOUT_SEC = 30


def check_toolchain():
    missing = [t for t in ("yosys", "iverilog") if shutil.which(t) is None]
    if missing:
        print(f"FATAL: required tool(s) not found on PATH: {', '.join(missing)}", file=sys.stderr)
        print("Install with: sudo apt-get install -y yosys iverilog", file=sys.stderr)
        sys.exit(1)
    if not os.path.exists(DB_PATH):
        print(f"FATAL: results DB not found at {DB_PATH}. Run pipeline/init_db.py first.", file=sys.stderr)
        sys.exit(1)


def load_module_list():
    with open(MANIFEST_PATH) as f:
        manifest = json.load(f)
    modules = []
    for category, names in manifest["categories"].items():
        for name in names:
            modules.append((name, category))
    return modules


def run_yosys(module_name, verilog_path):
    """Run yosys read+synth on a single file. Returns (passed, log, stats)."""
    # Quote the path so hosts with spaces (e.g. "Swantech projects") still work.
    # Yosys on Windows also prefers forward slashes.
    yosys_path = verilog_path.replace("\\", "/").replace('"', '\\"')
    script = f"""
read_verilog -sv "{yosys_path}"
hierarchy -top {module_name}
proc
opt
synth -top {module_name}
"""
    try:
        result = subprocess.run(
            ["yosys", "-Q", "-p", script],
            capture_output=True, text=True, timeout=YOSYS_TIMEOUT_SEC
        )
        log = result.stdout + "\n" + result.stderr
        passed = (result.returncode == 0) and ("ERROR" not in log)
        return passed, log, False
    except subprocess.TimeoutExpired as e:
        log = (e.stdout or "") + "\n" + (e.stderr or "") + "\nTIMEOUT"
        return False, log, True


def parse_stats(log):
    num_cells = None
    num_wires = None
    m = re.search(r"Number of cells:\s+(\d+)", log)
    if m:
        num_cells = int(m.group(1))
    m = re.search(r"Number of wires:\s+(\d+)", log)
    if m:
        num_wires = int(m.group(1))
    latch_warning = 1 if re.search(r"\$_?DLATCH|Latches:\s*[1-9]", log) else 0
    width_mismatch = 1 if re.search(r"[Ww]idth mismatch|resizing", log) else 0
    return num_cells, num_wires, latch_warning, width_mismatch


def main():
    check_toolchain()
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    modules = load_module_list()
    skipped = 0

    for name, category in modules:
        gen_path = os.path.join(GENERATED_DIR, category, f"{name}.v")
        if not os.path.exists(gen_path):
            print(f"[SKIP] {name}: no generated file at {gen_path}")
            skipped += 1
            continue

        cur.execute(
            "INSERT OR REPLACE INTO modules (module_name, category, prompt_path, generated_path, generation_timestamp) VALUES (?, ?, ?, ?, datetime('now'))",
            (name, category, os.path.join("prompts", category, f"{name}.md"), os.path.relpath(gen_path, ROOT))
        )

        # Lint: basic syntax check via iverilog -tnull (parse only, no elaboration issues beyond syntax)
        lint_result = subprocess.run(
            ["iverilog", "-tnull", gen_path],
            capture_output=True, text=True, timeout=15
        )
        lint_passed = (lint_result.returncode == 0)
        lint_log = lint_result.stdout + "\n" + lint_result.stderr
        cur.execute(
            "INSERT OR REPLACE INTO lint_results (module_name, passed, raw_log) VALUES (?, ?, ?)",
            (name, int(lint_passed), lint_log)
        )

        # Synthesis: run regardless of lint result (Yosys gives more detail than iverilog syntax check)
        synth_passed, synth_log, timed_out = run_yosys(name, gen_path)
        num_cells, num_wires, latch_warn, width_warn = parse_stats(synth_log)
        cur.execute(
            """INSERT OR REPLACE INTO synth_results
               (module_name, passed, num_cells, num_wires, latch_warning, width_mismatch_warning, other_warnings, raw_log)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
            (name, int(synth_passed), num_cells, num_wires, latch_warn, width_warn, None, synth_log)
        )

        status = "OK" if synth_passed else ("TIMEOUT" if timed_out else "SYNTH_FAIL")
        print(f"[{status}] {name} ({category}) lint={'PASS' if lint_passed else 'FAIL'} cells={num_cells} latch_warn={latch_warn}")

    conn.commit()
    conn.close()

    if skipped == len(modules):
        print("FATAL: no generated modules found at all -- generation step likely did not run.", file=sys.stderr)
        sys.exit(1)
    if skipped > 0:
        print(f"WARNING: {skipped}/{len(modules)} modules had no generated file (see SKIP lines above).")


if __name__ == "__main__":
    main()
