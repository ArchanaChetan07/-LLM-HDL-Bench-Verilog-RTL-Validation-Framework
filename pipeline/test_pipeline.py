#!/usr/bin/env python3
"""
Unit tests for the PIPELINE ITSELF (categorizer logic, stats parsing) --
not for the RTL under test. These guard against exactly the kind of
false-positive bug (PROC_DLATCH matching as a "latch warning") found and
fixed during the v1-pilot run.

Run with: python3 pipeline/test_pipeline.py
Exits non-zero on any failure (suitable for CI).
"""
import sys
import os
import unittest

sys.path.insert(0, os.path.dirname(__file__))

from run_synth import parse_stats
from categorize import categorize


class TestParseStats(unittest.TestCase):
    def test_no_false_positive_on_proc_dlatch_pass_name(self):
        # Regression test for the exact v1 harness bug: Yosys prints this pass
        # name on every run regardless of whether any latch was inferred.
        log = "3.8. Executing PROC_DLATCH pass (convert process syncs to latches)."
        _, _, latch_warn, _ = parse_stats(log)
        self.assertEqual(latch_warn, 0, "PROC_DLATCH pass name must not be treated as a latch warning")

    def test_detects_real_latch_cell(self):
        log = "Number of cells: 5\n  $_DLATCH_P_    2\n"
        _, _, latch_warn, _ = parse_stats(log)
        self.assertEqual(latch_warn, 1, "an actual $_DLATCH_ cell must be flagged")

    def test_parses_cell_and_wire_counts(self):
        log = "Number of wires: 12\nNumber of cells: 34\n"
        num_cells, num_wires, _, _ = parse_stats(log)
        self.assertEqual(num_cells, 34)
        self.assertEqual(num_wires, 12)


class TestCategorizer(unittest.TestCase):
    def test_lint_failure_takes_priority(self):
        lint_row = (0, "syntax error at line 5")
        verdict, category, _ = categorize(lint_row, None, None)
        self.assertEqual(verdict, "FAIL")
        self.assertEqual(category, "syntax_error")

    def test_clean_pass(self):
        lint_row = (1, "")
        synth_row = (1, 10, 5, 0, 0, "")
        sim_row = (1, 1, 0, "TEST_PASS", 0)
        verdict, category, _ = categorize(lint_row, synth_row, sim_row)
        self.assertEqual(verdict, "PASS")
        self.assertIsNone(category)

    def test_sim_mismatch_categorized_correctly(self):
        lint_row = (1, "")
        synth_row = (1, 10, 5, 0, 0, "")
        sim_row = (1, 0, 3, "MISMATCH ...\nTEST_FAIL errors=3", 0)
        verdict, category, _ = categorize(lint_row, synth_row, sim_row)
        self.assertEqual(verdict, "FAIL")
        self.assertEqual(category, "sim_mismatch")

    def test_sim_timeout_categorized_correctly(self):
        lint_row = (1, "")
        synth_row = (1, 10, 5, 0, 0, "")
        sim_row = (1, None, None, "SIMULATION TIMEOUT", 1)
        verdict, category, _ = categorize(lint_row, synth_row, sim_row)
        self.assertEqual(verdict, "FAIL")
        self.assertEqual(category, "sim_timeout")

    def test_compile_error_categorized_correctly(self):
        lint_row = (1, "")
        synth_row = (1, 10, 5, 0, 0, "")
        sim_row = (0, False, None, "COMPILE_ERROR:\nport mismatch", 0)
        verdict, category, _ = categorize(lint_row, synth_row, sim_row)
        self.assertEqual(verdict, "FAIL")
        self.assertEqual(category, "compile_error_sim")

    def test_synth_failure_non_synthesizable(self):
        lint_row = (1, "")
        synth_row = (0, None, None, 0, 0, "ERROR: unsupported construct 'foo'")
        verdict, category, _ = categorize(lint_row, synth_row, None)
        self.assertEqual(verdict, "FAIL")
        self.assertIn(category, ("non_synthesizable", "toolchain_incompatible"))


if __name__ == "__main__":
    unittest.main()
