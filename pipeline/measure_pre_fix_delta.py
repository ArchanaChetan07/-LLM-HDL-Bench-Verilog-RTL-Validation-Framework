#!/usr/bin/env python3
"""Measure recoverable pre-v4 delta by temporarily reverting the human edge-case fix.

v4 post-fix: sign_magnitude_adder4 uses (mag_a == mag_b) ? 0 : sign_a for equal opposite signs.
Unfixed (first-pass / pre-human-fix): always assigns sign_result = sign_a in that branch.

This does NOT reconstruct the older missing v1-pilot failure (commits e98ea20/20ae26f are
not in this repository). Measured result is therefore the recoverable one-file delta
(expected 45/46), not the historical composite 44/46.
"""
from __future__ import annotations

import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SMA = ROOT / "generated" / "arithmetic" / "sign_magnitude_adder4.v"
BACKUP = ROOT / "generated" / "arithmetic" / "sign_magnitude_adder4.v.pre_fix_bak"

FIXED = """                // Equal magnitudes cancel to +0 (sign_result=0), per spec
                sign_result = (mag_a == mag_b) ? 1'b0 : sign_a;"""

UNFIXED = """                sign_result = sign_a;"""


def main() -> int:
    text = SMA.read_text(encoding="utf-8")
    if FIXED not in text:
        print("ERROR: expected human-applied fix block not found in", SMA, file=sys.stderr)
        return 2
    shutil.copy2(SMA, BACKUP)
    try:
        SMA.write_text(text.replace(FIXED, UNFIXED, 1), encoding="utf-8")
        print("Reverted human edge-case fix in sign_magnitude_adder4.v")
        rc = subprocess.run([sys.executable, str(ROOT / "pipeline" / "run_all.py")]).returncode
        report = (ROOT / "reports" / "VALIDATION_REPORT.md").read_text(encoding="utf-8")
        for line in report.splitlines():
            if line.startswith("Aggregate pass rate:"):
                print("PRE_FIX_DELTA:", line.strip())
                break
        return rc
    finally:
        shutil.move(BACKUP, SMA)
        print("Restored fixed sign_magnitude_adder4.v")
        # Re-run post-fix so repo ends in the verified 46/46 state
        subprocess.run([sys.executable, str(ROOT / "pipeline" / "run_all.py")], check=False)


if __name__ == "__main__":
    raise SystemExit(main())
