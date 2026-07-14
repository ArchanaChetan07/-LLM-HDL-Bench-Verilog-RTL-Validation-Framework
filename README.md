# LLM-HDL-Bench

### Hardware-grade evaluation of LLM-generated RTL — lint · synthesize · simulate · report

**46 SystemVerilog modules · 5 digital categories · Yosys 0.33 + Icarus 12.0 · Docker · CI**  
**Verified: v4 post-fix `46/46 (100%)` · Honest unassisted baseline `44/46 (95.7%)`**

[![Benchmark CI](https://github.com/ArchanaChetan07/-LLM-HDL-Bench-Verilog-RTL-Validation-Framework/actions/workflows/benchmark.yml/badge.svg)](https://github.com/ArchanaChetan07/-LLM-HDL-Bench-Verilog-RTL-Validation-Framework/actions/workflows/benchmark.yml)
[![v4 Pass](https://img.shields.io/badge/v4%20post--fix-46%2F46%20(100%25)-148F40)](reports/VALIDATION_REPORT.md)
[![Unassisted](https://img.shields.io/badge/unassisted%20baseline-44%2F46%20(95.7%25)-0B6E4F)](reports/VALIDATION_REPORT.md)
[![Prompts](https://img.shields.io/badge/prompts-46%20×%205%20categories-5B2C6F)](prompts/manifest.json)
[![Harness](https://img.shields.io/badge/pipeline%20self--tests-9%20passing-1B4F72)](pipeline/test_pipeline.py)
[![Toolchain](https://img.shields.io/badge/EDA-Yosys%200.33%20%2B%20Icarus%2012.0-2874A6)](pipeline/config.json)
[![Docker](https://img.shields.io/badge/Docker-Ubuntu%2024.04-2496ED?logo=docker&logoColor=white)](Dockerfile)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python](https://img.shields.io/badge/Python-3.12%20stdlib-3776AB?logo=python&logoColor=white)](requirements.txt)

---

## Why this exists

LLM demos of “I generated a UART” are not an evaluation method. Silicon and AI-hardware teams need **reproducible, tool-backed correctness** — the same bar applied to compiler/testinfra candidates at FAANG-scale platforms.

**LLM-HDL-Bench** is an end-to-end RTL validation framework that:

1. Freezes **46** prompts across **combinational · FSM · arithmetic · memory · interface**  
2. Runs every `generated/*.v` module through **Icarus lint → Yosys synthesis (+ latch scan) → Icarus simulation vs a 1:1 testbench**  
3. Stores typed verdicts in **SQLite** and regenerates `reports/VALIDATION_REPORT.md` programmatically (never hand-edited)  
4. Publishes **both** post-fix pass rates **and** unassisted baselines so **100% is never misread as a first-pass claim**

> Metrics in this README are copied verbatim from `reports/VALIDATION_REPORT.md`, `prompts/manifest.json`, and `pipeline/config.json`. They are **not** altered.

---

## Results at a glance

| Metric | Value | Evidence |
|---|---|---|
| Prompt suite | **46** modules / **5** categories | `prompts/manifest.json` |
| Category mix | comb **10** · FSM **10** · arith **10** · mem **8** · iface **8** | same |
| Paired self-checking testbenches | **46** | `testbenches/` |
| Reference impls (harness validation) | **46** | `reference_impl/` |
| **v4 post-fix aggregate** | **46/46 (100.0%)** | `reports/VALIDATION_REPORT.md` |
| **All-unassisted equivalent** | **44/46 (95.7%)** | report history |
| v1 pilot (unassisted) | **18/19 (94.7%)** | report / commit `e98ea20` |
| v2 after one fix pass | **19/19 (100%)** | commit `20ae26f` |
| v3 full scope | **45/46 (97.8%)** | report |
| v3 new-modules first pass | **26/27 (97.8%)** | report |
| Per-category (v4) | all **100%** (10/10, 10/10, 10/10, 8/8, 8/8) | report |
| Failures in v4 | **0** | report |
| Pipeline Python modules | **7** (`init_db`…`generate_report`) | `pipeline/` |
| Harness unit tests | **9** passing | `pipeline/test_pipeline.py` |
| Toolchain | Yosys **0.33** · Icarus Verilog **12.0** | `pipeline/config.json` |
| Python deps | **stdlib only** (sqlite3, subprocess, …) | `requirements.txt` |
| License | **MIT** | `LICENSE` |

### Pass-rate trajectory (unchanged numbers)

```mermaid
xychart-beta
    title "Pass rate by milestone (%) — from VALIDATION_REPORT.md"
    x-axis ["v1 unassisted 18/19", "unassisted 44/46", "v3 new 26/27", "v3 full 45/46", "v4 post-fix 46/46"]
    y-axis "Pass %" 90 --> 100
    bar [94.7, 95.7, 97.8, 97.8, 100.0]
```

### Category coverage (prompt counts)

```mermaid
%%{init: {'theme':'base'}}%%
pie showData title "46 prompts by category"
    "combinational (10)" : 10
    "fsm (10)" : 10
    "arithmetic (10)" : 10
    "memory (8)" : 8
    "interface (8)" : 8
```

### v4 category pass rates (all 100%)

```mermaid
xychart-beta
    title "v4 per-category pass rate (%)"
    x-axis ["combinational 10/10", "fsm 10/10", "arithmetic 10/10", "memory 8/8", "interface 8/8"]
    y-axis "Pass %" 0 --> 100
    bar [100, 100, 100, 100, 100]
```

---

## System architecture

```mermaid
flowchart TB
  subgraph Spec["Frozen specification"]
    M[prompts/manifest.json<br/>46 prompt specs]
    R[reference_impl/<br/>46 known-good DUTs]
    T[testbenches/<br/>46 self-checking TBs]
  end

  subgraph DUT["Under test"]
    G[generated/*.v<br/>LLM RTL — single-pass methodology]
  end

  subgraph Pipeline["pipeline/ — Python stdlib orchestrator"]
    RA[run_all.py]
    LS[run_sim.py — Icarus lint + sim]
    YS[run_synth.py — Yosys + latch scan]
    CAT[categorize.py<br/>syntax · sim_mismatch · latch · timeout]
    DB[(results_db/results.db)]
    REP[generate_report.py → VALIDATION_REPORT.md]
    UT[test_pipeline.py — 9 harness tests]
  end

  M --> G
  R -.->|validate TBs| T
  G --> RA
  T --> RA
  RA --> LS
  RA --> YS
  LS --> CAT
  YS --> CAT
  CAT --> DB --> REP
  UT -.->|guards false-positives| CAT
```

### Per-module gate sequence

```mermaid
sequenceDiagram
  autonumber
  participant O as run_all.py
  participant I as Icarus 12.0
  participant Y as Yosys 0.33
  participant C as categorize.py
  participant S as SQLite

  O->>I: lint generated module
  O->>Y: synth -top + latch warning scan
  O->>I: simulate with paired testbench
  I-->>C: pass / fail signals
  Y-->>C: cell count + latch flags
  C->>S: typed verdict
  Note over C,S: Failure taxonomy: syntax, sim_mismatch, latch, timeout
```

### Observe → revise honesty model

```mermaid
stateDiagram-v2
  [*] --> Unassisted: single-pass generation
  Unassisted --> ReportBaseline: score & disclose (e.g. 44/46)
  ReportBaseline --> BugfixPass: optional targeted fix
  BugFixPass --> PostFixScore: re-run full harness (e.g. 46/46)
  PostFixScore --> [*]: both numbers remain published
```

---

## Category catalog

| Category | N | Representative modules |
|---|---:|---|
| **combinational** | 10 | `mux4to1`, `priority_encoder8`, `bcd_to_7seg`, `decoder3to8`, `majority_vote3` |
| **fsm** | 10 | `traffic_light`, `vending_machine`, `sequence_detector_1011`, `moore_edge_detector`, `elevator_2floor` |
| **arithmetic** | 10 | `ripple_carry_adder4`, `lfsr8`, `multiplier4x4_shiftadd`, `sign_magnitude_adder4`, `bcd_adder` |
| **memory** | 8 | `dual_port_ram`, `sync_fifo`-class stacks/`lifo_stack_8x8`, `circular_buffer_pointer_8x8`, `sync_regfile_4x8` |
| **interface** | 8 | `uart_tx`, `sync_fifo_8x8`, `cdc_synchronizer_2ff`, `simple_spi_master`, `button_debouncer` |

Synthesized cell counts (Yosys generic) are recorded per module in the validation report — e.g. `dual_port_ram` **609** cells, `sync_fifo_8x8` **188**, `mux4to1` **3** — useful for complexity stratification in follow-on model comparisons.

---

## Methodology (what “honest” means here)

From `pipeline/config.json` and the report changelog:

- **Single-pass generation policy** for the unassisted baseline: one RTL write per prompt, no retry loop, no consulting the paired testbench during generation.  
- **Post-fix rates are labeled as such** — v4 fixes the v3 `sign_magnitude_adder4` edge case (equal magnitudes / opposite signs → `+0`) and re-runs all **46** modules.  
- **Retractions are disclosed** when investigation clears a suspected bug (e.g. `circular_buffer_pointer_8x8` nonblocking assign semantics).  
- **Harness ≠ DUT**: CI fails if the *pipeline* breaks; RTL under-test failures are recorded as benchmark data, not as CI red.

```mermaid
flowchart LR
  A[Prompt freeze] --> B[Generate RTL]
  B --> C[Lint]
  C --> D[Synth + latch]
  D --> E[Simulate vs TB]
  E --> F{Verdict}
  F -->|PASS| G[SQLite + report]
  F -->|typed FAIL| G
```

---

## Skills this repository demonstrates

| Domain | Concrete signals |
|---|---|
| **Digital design / EDA** | SystemVerilog/Verilog RTL, FSMs, CDC 2FF, UART/SPI/FIFO, Yosys synth, Icarus sim |
| **LLM evaluation** | Frozen prompt suite, typed failure taxonomy, unassisted vs post-fix reporting |
| **Software / platforms** | Python orchestration, SQLite, Dockerized Ubuntu 24.04 toolchain, GitHub Actions artifact upload |
| **Engineering discipline** | Programmatic reports, harness unit tests (incl. Yosys `PROC_DLATCH` false-positive guard), MIT license |

Keyword surface for discovery: **SystemVerilog · Verilog · RTL · Yosys · Icarus · HDL · ASIC/FPGA-adjacent validation · LLM benchmark · Python · Docker · CI/CD · SQLite · synthesis · simulation · CDC · UART · FIFO · FSM**

---

## Quick start

### Docker (recommended — no local EDA install)

```bash
git clone https://github.com/ArchanaChetan07/-LLM-HDL-Bench-Verilog-RTL-Validation-Framework.git
cd -- -LLM-HDL-Bench-Verilog-RTL-Validation-Framework

docker build -t llm-hdl-bench .
docker run --rm llm-hdl-bench
# CMD runs: python3 pipeline/run_all.py
```

### Local toolchain

```bash
# Ubuntu/Debian
sudo apt-get update && sudo apt-get install -y yosys iverilog python3

python3 pipeline/test_pipeline.py -v   # harness self-tests first
python3 pipeline/run_all.py            # full 46-module bench
# report: reports/VALIDATION_REPORT.md
```

### CI

On changes under `prompts/`, `testbenches/`, `generated/`, or `pipeline/`, [`.github/workflows/benchmark.yml`](.github/workflows/benchmark.yml) installs Yosys + Icarus, runs harness tests + full pipeline, and uploads `results_db/results.db` + the validation report as artifacts.

---

## Repository layout

```text
-LLM-HDL-Bench-Verilog-RTL-Validation-Framework/
├── prompts/              # 46 frozen .md specs + manifest.json
├── generated/            # RTL under test
├── reference_impl/       # known-good DUTs (validate TBs, not scored as LLM)
├── testbenches/          # 46 self-checking benches
├── pipeline/             # lint/synth/sim/categorize/SQLite/report + 9 unit tests
├── results_db/           # results.db (source of truth)
├── reports/              # VALIDATION_REPORT.md (generated)
├── Dockerfile            # Ubuntu 24.04 + yosys + iverilog
└── .github/workflows/    # benchmark.yml
```

---

## Design principles

1. **Honesty over vanity** — publish unassisted **44/46** beside post-fix **46/46**.  
2. **Typed failures** — syntax / sim mismatch / latch / timeout for error analysis.  
3. **Reproducibility** — Docker + pinned toolchain versions in config.  
4. **Zero cherry-picking** — every module listed in the generated report.  
5. **Stdlib pipeline** — no hidden Python dependency graph.

---

## Known limitations (from the report)

Results are scoped to this generation, this 46-prompt set, and Yosys **0.33** / Icarus **12.0**. They do **not** generalize to other models, large SoC RTL, or production STA/signoff flows. Yosys `synth` here targets **generic** cells (synthesizability + warnings), not a foundry library.

---

## Future improvements

- Multi-model leaderboard CSV (temperature / seed controls)  
- Optional SymbiYosys formal gate  
- Prompt difficulty tags for stratified pass rates  

---

## License

MIT © 2026 Archana Chetan — see [`LICENSE`](LICENSE).

---

<p align="center">
  <b>LLM-HDL-Bench</b> — measurable RTL correctness for LLM evaluation.<br/>
  <a href="https://github.com/ArchanaChetan07/-LLM-HDL-Bench-Verilog-RTL-Validation-Framework">github.com/ArchanaChetan07/-LLM-HDL-Bench-Verilog-RTL-Validation-Framework</a>
</p>
