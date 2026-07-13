#!/usr/bin/env python3
"""
Runs the full pipeline end-to-end: init DB -> synth -> sim -> categorize -> report.
Exits non-zero if any STAGE crashes (missing toolchain, no generated files, etc).
Does NOT exit non-zero because individual RTL modules failed their testbench --
a benchmark that only "passes CI" when the pass rate is 100% would create exactly
the incentive to quietly weaken testbenches that this project exists to avoid.
CI failure is reserved for the harness itself being broken, not for the RTL
under test having a low pass rate.
"""
import subprocess
import sys
import os

ROOT = os.path.dirname(__file__)

STAGES = [
    ("init_db.py", "Initializing results database"),
    ("run_synth.py", "Lint + synthesis stage"),
    ("run_sim.py", "Simulation stage"),
    ("categorize.py", "Failure categorization"),
    ("generate_report.py", "Report generation"),
]


def main():
    for script, description in STAGES:
        print(f"\n=== {description} ({script}) ===")
        result = subprocess.run([sys.executable, os.path.join(ROOT, script)])
        if result.returncode != 0:
            print(f"\nFATAL: stage '{script}' exited with code {result.returncode}. "
                  f"This indicates a harness problem (missing toolchain, corrupt DB, "
                  f"crashed script), not a benchmark result. Stopping.", file=sys.stderr)
            sys.exit(result.returncode)

    print("\n=== Pipeline complete ===")
    report_path = os.path.join(ROOT, "..", "reports", "VALIDATION_REPORT.md")
    print(f"Report: {os.path.abspath(report_path)}")


if __name__ == "__main__":
    main()
