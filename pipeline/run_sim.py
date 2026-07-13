#!/usr/bin/env python3
"""
Simulation stage.
Every module that produced a generated file is run against its paired reference
testbench via Icarus Verilog, regardless of synth outcome (a module can fail
synthesis-stage warnings but still be simulated -- both results are captured
independently, and the categorizer decides overall verdict from all evidence).
"""
import json
import os
import re
import shutil
import sqlite3
import subprocess
import sys
import tempfile

ROOT = os.path.join(os.path.dirname(__file__), "..")
DB_PATH = os.path.join(ROOT, "results_db", "results.db")
GENERATED_DIR = os.path.join(ROOT, "generated")
TESTBENCH_DIR = os.path.join(ROOT, "testbenches")
MANIFEST_PATH = os.path.join(ROOT, "prompts", "manifest.json")

SIM_TIMEOUT_SEC = 20


def check_toolchain():
    missing = [t for t in ("iverilog", "vvp") if shutil.which(t) is None]
    if missing:
        print(f"FATAL: required tool(s) not found on PATH: {', '.join(missing)}", file=sys.stderr)
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


def run_sim(module_name, category):
    gen_path = os.path.join(GENERATED_DIR, category, f"{module_name}.v")
    tb_path = os.path.join(TESTBENCH_DIR, category, f"tb_{module_name}.v")

    if not os.path.exists(gen_path):
        return False, None, "no generated file", False
    if not os.path.exists(tb_path):
        return False, None, "no testbench found", False

    with tempfile.TemporaryDirectory() as tmpdir:
        vvp_out = os.path.join(tmpdir, f"{module_name}.vvp")
        compile_result = subprocess.run(
            ["iverilog", "-o", vvp_out, gen_path, tb_path],
            capture_output=True, text=True, timeout=15
        )
        if compile_result.returncode != 0:
            return False, None, "COMPILE_ERROR:\n" + compile_result.stdout + compile_result.stderr, False

        try:
            run_result = subprocess.run(
                ["vvp", vvp_out],
                capture_output=True, text=True, timeout=SIM_TIMEOUT_SEC
            )
            log = run_result.stdout + "\n" + run_result.stderr
        except subprocess.TimeoutExpired:
            return False, None, "SIMULATION TIMEOUT", True

    mismatch_count = len(re.findall(r"^MISMATCH", log, re.MULTILINE))
    passed = "TEST_PASS" in log and "TEST_FAIL" not in log
    return passed, mismatch_count, log, False


def main():
    check_toolchain()
    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()
    modules = load_module_list()

    for name, category in modules:
        gen_path = os.path.join(GENERATED_DIR, category, f"{name}.v")
        if not os.path.exists(gen_path):
            print(f"[SKIP] {name}: no generated file")
            continue

        try:
            passed, mismatch_count, log, timed_out = run_sim(name, category)
            ran = 1
        except Exception as e:
            ran = 0
            passed = False
            mismatch_count = None
            log = f"EXCEPTION: {e}"
            timed_out = False

        cur.execute(
            """INSERT OR REPLACE INTO sim_results
               (module_name, ran, passed, mismatch_count, raw_log, timed_out)
               VALUES (?, ?, ?, ?, ?, ?)""",
            (name, ran, int(passed) if ran else None, mismatch_count, log, int(timed_out))
        )
        status = "PASS" if passed else ("TIMEOUT" if timed_out else "FAIL")
        print(f"[{status}] {name} ({category}) mismatches={mismatch_count}")

    conn.commit()
    conn.close()


if __name__ == "__main__":
    main()
