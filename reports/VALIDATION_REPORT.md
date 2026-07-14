# LLM-HDL-Bench Validation Report

**This report is generated programmatically from `results_db/results.db`. It has not been manually edited. Every generated module -- pass or fail -- is listed below.**

**Scope:** full-scope prompt set (46 prompts across 5 categories), matching the originally proposed 40-50 prompt target. Same zero-filtering, single-pass-generation methodology throughout.

**What this does NOT prove:** results are scoped to this specific generation, this specific 46-prompt set, and this specific toolchain (Yosys 0.33 / Icarus Verilog 12.0). They do not generalize to other models, larger designs, or production RTL flows.

## Headline Numbers (de-emphasized by design)

Aggregate pass rate: **46/46 (100.0%)**

A single number like this is exactly the kind of oversimplification this benchmark exists to avoid. See the per-category breakdown below for the actual signal.

## Per-Category Breakdown

| Category | Pass Rate | Modules |
|---|---|---|
| arithmetic | 10/10 (100%) | bcd_adder✅, bin_to_bcd_2digit✅, gray_counter4✅, incrementer4bit✅, lfsr8✅, multiplier4x4_shiftadd✅, ripple_carry_adder4✅, saturating_counter4✅, sign_magnitude_adder4✅, subtractor4bit_2comp✅ |
| combinational | 10/10 (100%) | bcd_to_7seg✅, comparator4bit✅, decoder3to8✅, full_adder1bit✅, majority_vote3✅, mux4to1✅, parity_gen8✅, priority_arbiter4✅, priority_encoder8✅, xor_parity_checker✅ |
| fsm | 10/10 (100%) | elevator_2floor✅, mealy_edge_detector✅, mod4_up_down_counter_fsm✅, moore_edge_detector✅, one_shot_pulse_gen✅, sequence_detector_1011✅, simple_alarm_fsm✅, traffic_light✅, vending_machine✅, walking_1_pattern✅ |
| interface | 8/8 (100%) | button_debouncer✅, cdc_synchronizer_2ff✅, one_pulse_edge_detector_io✅, shift_register_piso✅, simple_spi_master✅, spi_shift_reg✅, sync_fifo_8x8✅, uart_tx✅ |
| memory | 8/8 (100%) | byte_enable_ram_16x8✅, circular_buffer_pointer_8x8✅, dual_port_ram✅, dual_read_port_regfile_8x8✅, lifo_stack_8x8✅, shadow_register_pair✅, single_port_rom_16x8✅, sync_regfile_4x8✅ |

## Failure Category Breakdown

No failures in this run.

## Every Module, In Detail

### arithmetic

**`bcd_adder`** -- ✅ PASS
- Synthesized cells: 34, latch warning: no

**`bin_to_bcd_2digit`** -- ✅ PASS
- Synthesized cells: 429, latch warning: no

**`gray_counter4`** -- ✅ PASS
- Synthesized cells: 12, latch warning: no

**`incrementer4bit`** -- ✅ PASS
- Synthesized cells: 8, latch warning: no

**`lfsr8`** -- ✅ PASS
- Synthesized cells: 11, latch warning: no

**`multiplier4x4_shiftadd`** -- ✅ PASS
- Synthesized cells: 69, latch warning: no

**`ripple_carry_adder4`** -- ✅ PASS
- Synthesized cells: 23, latch warning: no

**`saturating_counter4`** -- ✅ PASS
- Synthesized cells: 13, latch warning: no

**`sign_magnitude_adder4`** -- ✅ PASS
- Synthesized cells: 41, latch warning: no

**`subtractor4bit_2comp`** -- ✅ PASS
- Synthesized cells: 28, latch warning: no

### combinational

**`bcd_to_7seg`** -- ✅ PASS
- Synthesized cells: 26, latch warning: no

**`comparator4bit`** -- ✅ PASS
- Synthesized cells: 18, latch warning: no

**`decoder3to8`** -- ✅ PASS
- Synthesized cells: 21, latch warning: no

**`full_adder1bit`** -- ✅ PASS
- Synthesized cells: 7, latch warning: no

**`majority_vote3`** -- ✅ PASS
- Synthesized cells: 5, latch warning: no

**`mux4to1`** -- ✅ PASS
- Synthesized cells: 3, latch warning: no

**`parity_gen8`** -- ✅ PASS
- Synthesized cells: 7, latch warning: no

**`priority_arbiter4`** -- ✅ PASS
- Synthesized cells: 7, latch warning: no

**`priority_encoder8`** -- ✅ PASS
- Synthesized cells: 39, latch warning: no

**`xor_parity_checker`** -- ✅ PASS
- Synthesized cells: 8, latch warning: no

### fsm

**`elevator_2floor`** -- ✅ PASS
- Synthesized cells: 31, latch warning: no

**`mealy_edge_detector`** -- ✅ PASS
- Synthesized cells: 2, latch warning: no

**`mod4_up_down_counter_fsm`** -- ✅ PASS
- Synthesized cells: 5, latch warning: no

**`moore_edge_detector`** -- ✅ PASS
- Synthesized cells: 14, latch warning: no

**`one_shot_pulse_gen`** -- ✅ PASS
- Synthesized cells: 8, latch warning: no

**`sequence_detector_1011`** -- ✅ PASS
- Synthesized cells: 30, latch warning: no

**`simple_alarm_fsm`** -- ✅ PASS
- Synthesized cells: 15, latch warning: no

**`traffic_light`** -- ✅ PASS
- Synthesized cells: 49, latch warning: no

**`vending_machine`** -- ✅ PASS
- Synthesized cells: 43, latch warning: no

**`walking_1_pattern`** -- ✅ PASS
- Synthesized cells: 4, latch warning: no

### interface

**`button_debouncer`** -- ✅ PASS
- Synthesized cells: 17, latch warning: no

**`cdc_synchronizer_2ff`** -- ✅ PASS
- Synthesized cells: 2, latch warning: no

**`one_pulse_edge_detector_io`** -- ✅ PASS
- Synthesized cells: 3, latch warning: no

**`shift_register_piso`** -- ✅ PASS
- Synthesized cells: 17, latch warning: no

**`simple_spi_master`** -- ✅ PASS
- Synthesized cells: 47, latch warning: no

**`spi_shift_reg`** -- ✅ PASS
- Synthesized cells: 17, latch warning: no

**`sync_fifo_8x8`** -- ✅ PASS
- Synthesized cells: 188, latch warning: no

**`uart_tx`** -- ✅ PASS
- Synthesized cells: 52, latch warning: no

### memory

**`byte_enable_ram_16x8`** -- ✅ PASS
- Synthesized cells: 297, latch warning: no

**`circular_buffer_pointer_8x8`** -- ✅ PASS
- Synthesized cells: 195, latch warning: no

**`dual_port_ram`** -- ✅ PASS
- Synthesized cells: 609, latch warning: no

**`dual_read_port_regfile_8x8`** -- ✅ PASS
- Synthesized cells: 253, latch warning: no

**`lifo_stack_8x8`** -- ✅ PASS
- Synthesized cells: 197, latch warning: no

**`shadow_register_pair`** -- ✅ PASS
- Synthesized cells: 28, latch warning: no

**`single_port_rom_16x8`** -- ✅ PASS
- Synthesized cells: 4, latch warning: no

**`sync_regfile_4x8`** -- ✅ PASS
- Synthesized cells: 88, latch warning: no


## Changelog: v3 -> v4 (this run) -- Human Bug-Fix Pass

v3 left one confirmed sim-mismatch live: `sign_magnitude_adder4` returned `sign_a` instead of `+0` when equal magnitudes canceled under opposite signs. v4 applies that single **human-applied** edge-case fix (matching the reference implementation and prompt) and re-runs the full 46-module harness. This is **not** an automated LLM self-correction / tool-feedback loop.

**Result of this run:** see headline numbers above (expect **46/46** after the fix). Recoverable pre-fix delta (revert that one edit via `pipeline/measure_pre_fix_delta.py`): **45/46**. A historical composite 'all-unassisted' **44/46** was documented from earlier versioned runs whose commits are not in this repository and is not re-claimed as a freshly measured number unless those sources are restored.

**Still disclosed from prior runs:** `circular_buffer_pointer_8x8` was suspected of a double pointer advance, then retracted -- repeated nonblocking assigns to the same register in one `always` block are last-assignment-wins, not additive.

## Full Scope History

| Run | Scope | Result | Commit |
|---|---|---|---|
| v1-pilot | 19 prompts, unassisted single pass | 18/19 (94.7%) | `e98ea20` |
| v2 | 19 prompts, after 1 bug-fix pass | 19/19 (100%) | `20ae26f` |
| v3 | 46 prompts (full scope), unassisted on the 27 new modules | 45/46 (97.8%) | prior |
| v4 (this run) | 46 prompts, after sign_magnitude_adder4 edge-case fix | see headline | current |

v4 is an iteration pass on the one remaining v3 bug via a **human-applied** edge-case edit (not an LLM self-repair loop). History rows for v1–v3 SHAs that are absent from this repository are retained as documentation only.

## Known Limitations (carried forward + updated)

- **Full scope reached.** 46 prompts across 5 categories, matching the originally proposed 40-50 target -- this is no longer described as a pilot.
- **Post-fix vs pre-fix (session-verifiable).** Current `generated/` is the human post-fix corpus (**46/46**). Reverting the `sign_magnitude_adder4` edit yields **45/46**. A historical composite **44/46** appeared in older notes (v1 18/19 + v3-new 26/27) but those earlier commits are not in this repo, so 44/46 is not re-asserted as freshly measured.
- **One tooling bug found and fixed during the v1 run:** a false-positive latch-detection regex matched Yosys's internal pass name rather than real warnings. Fixed before v1's results were generated; unaffected by later runs.
- **Yosys generic synth only** -- no specific FPGA/ASIC cell library target, so cell/wire counts are relative indicators, not real area numbers.
- **`simple_spi_master`'s reference implementation defines its own reasonable-but-somewhat-arbitrary interpretation of an underspecified SPI timing detail** (exact sclk/mosi phase relationship) -- the prompt did not fully pin down cycle-exact SPI mode-0 timing, so both the reference and the generated module's correctness are measured against that specific interpretation, not against an external SPI timing standard.

## Reproducibility

```
a89331a docs: professional FAANG-ready README with diagrams and verified results
926b386 Elevate README to FAANG interview bar with pass-rate chart and skills.
4e7a825 docs: rewrite README with verified RTL benchmark metrics
b783d11 docs: expand README for ATS visibility with quantified results and stack keywords
051df3e Refresh README with architecture diagrams, result charts, and portfolio-grade project narrative.
```

Harness self-tests: `python3 pipeline/test_pipeline.py -v`

Full pipeline (single command): `python3 pipeline/run_all.py`

Or via Docker: `docker build -t llm-hdl-bench . && docker run --rm llm-hdl-bench`
