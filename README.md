![CI](https://github.com/ArchanaChetan07/-LLM-HDL-Bench-Verilog-RTL-Validation-Framework/actions/workflows/benchmark.yml/badge.svg)

Honest LLM RTL/SystemVerilog benchmark — 46 prompts across 5 categories, dual-tool validation via Yosys + Icarus Verilog, Docker-reproducible.

**46/46 (100%) after a human-applied edge-case fix** vs **45/46 (97.8%)** with that same fix reverted — **not** an LLM self-correction loop — Yosys **0.33** + Icarus Verilog **12.0** — one-command Docker reproducible.

```bash
docker build -t llm-hdl-bench . && docker run --rm llm-hdl-bench
```

## Overview

LLM-HDL-Bench freezes a **46-module** prompt suite (combinational · FSM · arithmetic · memory · interface), scores every checked-in `generated/*.v` file with **Yosys lint/synthesis** and **Icarus simulation** against paired testbenches, stores typed verdicts in SQLite, and regenerates `reports/VALIDATION_REPORT.md` programmatically. No cherry-picking. No silent discards.

## Why “Honest” Benchmark

Typical LLM codegen demos stop at “it looks like Verilog.” This harness requires **dual-tool** evidence for every module:

1. **Yosys** — lint + generic synthesis (incl. latch-cell scan)  
2. **Icarus Verilog** — compile + simulate vs a 1:1 testbench  

Failures are typed (`syntax`, `sim_mismatch`, `latch`, `timeout`, …). The headline is whatever the tools return on a full re-run — including imperfect rates when a human fix is deliberately reverted.

## Methodology

### Prompt categories (46 total)

| Category | Count |
|---|---:|
| Combinational | 10 |
| FSM | 10 |
| Arithmetic | 10 |
| Memory | 8 |
| Interface | 8 |

### What “post-fix” vs “unassisted / pre-fix” means **in this repo**

| Label | Meaning in code | Session-verified result |
|---|---|---|
| **v4 post-fix (current `generated/`)** | After a **human-applied** edge-case edit to `generated/arithmetic/sign_magnitude_adder4.v` (equal opposite-sign magnitudes must yield `+0`). **Not** an automated LLM retry / self-repair loop with tool feedback. | **46/46 (100%)** |
| **Recoverable pre-fix delta** | Same corpus with that one human edit reverted (`pipeline/measure_pre_fix_delta.py`) | **45/46 (97.8%)** — only `sign_magnitude_adder4` fails (`sim_mismatch`) |

Older write-ups also cite a **historical composite “all-unassisted” 44/46** (v1 pilot 18/19 + v3-new 26/27). Those earlier SHAs (`e98ea20`, `20ae26f`) are **not present in this repository**, so **44/46 was not re-executed in this session** and is not used as a freshly measured headline number here.

### Toolchain pins (session-verified)

| Tool | Version observed in Docker / Ubuntu 24.04 apt |
|---|---|
| Yosys | **0.33** (`git sha1 2584903a060`) |
| Icarus Verilog | **12.0 (stable)** |

## Results

Full dual-tool run inside Docker this session (`docker build -t llm-hdl-bench . && docker run --rm llm-hdl-bench`):

| Category | Pass rate |
|---|---|
| Combinational | **10/10** |
| FSM | **10/10** |
| Arithmetic | **10/10** (post-fix corpus) |
| Memory | **8/8** |
| Interface | **8/8** |
| **Aggregate (post-fix)** | **46/46 (100%)** |
| Aggregate with human fix reverted | **45/46 (97.8%)** |

Per-module detail: [`reports/VALIDATION_REPORT.md`](reports/VALIDATION_REPORT.md) (machine-generated). Toolchain capture: [`artifacts/toolchain_versions.txt`](artifacts/toolchain_versions.txt).

## How to Run

```bash
# Full benchmark (writes reports/ + results_db/)
docker build -t llm-hdl-bench . && docker run --rm llm-hdl-bench

# Optional: measure recoverable pre-fix delta (temporary revert, then restores)
docker run --rm llm-hdl-bench python3 pipeline/measure_pre_fix_delta.py

# Harness unit tests only
docker run --rm llm-hdl-bench python3 pipeline/test_pipeline.py -v
```

Local (requires Yosys + Icarus on `PATH`):

```bash
python3 pipeline/test_pipeline.py -v
python3 pipeline/run_all.py
```

## Tech Stack

- Python 3 (stdlib: `sqlite3`, `subprocess`, `json`, `re`, `unittest`)
- Yosys 0.33 · Icarus Verilog 12.0
- Docker (Ubuntu 24.04) · GitHub Actions
- MIT License

## License

[MIT](LICENSE)
