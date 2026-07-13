# LLM-HDL-Bench

An honest, zero-cherry-picking benchmark for LLM-generated RTL correctness.

**Status: full scope reached.** 46 prompts across 5 categories (combinational, FSM,
arithmetic, memory, interface) — matching the originally proposed 40-50 prompt
target. Fully automated Yosys + Icarus Verilog pipeline, harness self-tests,
Docker reproducibility, CI on every change.

| Run | Scope | Result |
|---|---|---|
| v1-pilot | 19 prompts, unassisted single pass | 18/19 (94.7%) |
| v2 | 19 prompts, after 1 bug-fix pass | 19/19 (100%) |
| v3 | 46 prompts (full scope) | 45/46 (97.8%) |
| v4 (current) | 46 prompts, after `sign_magnitude_adder4` fix | **46/46 (100%)** |
| — unassisted-only equivalent | 46 prompts, no fixes anywhere | **44/46** |

See [`reports/VALIDATION_REPORT.md`](reports/VALIDATION_REPORT.md) for the full
per-category breakdown, every failure with real generated code shown, the
complete v1→v2→v3 changelog (including two retracted claims — see below), and
this run's disclosed limitations.

## Why multiple numbers, not one

This project's premise is refusing to collapse results into a single flattering
headline. v4's 46/46 is a post-fix state; the honest all-unassisted equivalent
remains **44/46**, computed and stated explicitly rather than left for a reader
to catch.

**Two claims were made and then retracted after closer investigation** — this
is disclosed prominently because a benchmark that never admits its own
mistakes isn't trustworthy about anyone else's:
- v1 claimed `uart_tx` had an 11-cycle timing bug. It didn't — a reasoning
  error when writing the disclosure, not a defect in the generated RTL.
- v3 initially suspected `circular_buffer_pointer_8x8` had a double-pointer-
  advance bug. It doesn't — two nonblocking assignments to the same register
  in one `always` block resolve to "last one wins," not "add both," which
  Verilog handles safely by construction.

## Repo layout

```
prompts/            46 prompt specs, one .md per module, frozen before generation
                     of each batch (see commit history for freeze points)
reference_impl/      46 known-correct reference implementations, used only to
                     validate the testbenches themselves before any LLM output
                     was evaluated against them
testbenches/         46 self-checking Verilog testbenches, paired 1:1 with prompts
generated/           The 46 RTL modules under test. 19 pilot modules are at
                     their v2 (post-fix) state; 27 new modules are unmodified
                     single-pass output, including the one confirmed bug
                     (sign_magnitude_adder4)
pipeline/            Lint/synth (Yosys) + simulation (Icarus) + categorizer +
                     SQLite storage + report generator + orchestrator +
                     harness self-tests (pipeline/test_pipeline.py)
results_db/          SQLite database, the single source of truth for the report
reports/             VALIDATION_REPORT.md — generated programmatically, never
                     hand-edited
.github/workflows/   CI: harness self-tests, then full benchmark, on every
                     prompt/pipeline/generated-code change
Dockerfile           Reproducible environment (Ubuntu 24.04 + Yosys + Icarus)
```

## Reproduce it yourself

```bash
# Option 1: Docker (recommended — no local toolchain install needed)
docker build -t llm-hdl-bench .
docker run --rm llm-hdl-bench

# Option 2: local toolchain
sudo apt-get install -y yosys iverilog
python3 pipeline/test_pipeline.py -v   # harness self-tests first
python3 pipeline/run_all.py            # full benchmark, single command
cat reports/VALIDATION_REPORT.md
```

Individual stages remain runnable separately if you're debugging one:
`init_db.py`, `run_synth.py`, `run_sim.py`, `categorize.py`, `generate_report.py`.

## What this does and doesn't prove

- Scoped to this specific generation, this 46-prompt set, and this toolchain
  (Yosys 0.33 / Icarus Verilog 12.0).
- Does **not** generalize to other models, larger/production-scale RTL, or
  formal timing signoff (Yosys's synthesis-stage output is not a real STA flow).
- The v3 `sign_magnitude_adder4` bug (wrong sign on equal-magnitude,
  opposite-sign → should be `+0`) was confirmed via sim mismatch and fixed in
  v4. The unassisted baseline remains visible in the history table above.

## Engineering hardening

- `pipeline/run_all.py`: single-command orchestrator; exits non-zero if any
  *stage* crashes (missing toolchain, corrupt DB), but never because the RTL
  under test failed its testbench — CI failure is reserved for the harness
  being broken, not for a benchmark reporting a real result.
- `pipeline/test_pipeline.py`: 9 unit tests on the categorizer and stats
  parser, including a regression test for the exact false-positive bug
  (Yosys's `PROC_DLATCH` pass name being mistaken for a latch warning) found
  during the v1 run.
- Toolchain-availability checks (`shutil.which`) at the start of every stage
  that shells out to `yosys`/`iverilog`, with a clear error instead of a
  confusing subprocess failure.
- `Dockerfile` for a reproducible environment independent of the host's
  package versions.
- `.gitignore`, `LICENSE` (MIT), `requirements.txt` (documents there are no
  third-party Python deps, intentionally).

## Extending this

The pipeline is model-agnostic — swapping in a different model's outputs into
`generated/` and re-running `pipeline/run_all.py` is a drop-in change, not a
rebuild. The prompt set is now at the originally proposed full scope; growing
it further (e.g. adding a 6th category, or more prompts per category) follows
the same pattern used throughout this repo's history: write + freeze the new
prompts, write + validate testbenches against reference implementations
*before* generating any new RTL, then generate and run the pipeline.
