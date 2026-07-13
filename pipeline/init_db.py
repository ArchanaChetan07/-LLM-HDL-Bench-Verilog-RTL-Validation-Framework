#!/usr/bin/env python3
"""Initialize the SQLite results database. Idempotent."""
import sqlite3
import sys
import os

DB_PATH = os.path.join(os.path.dirname(__file__), "..", "results_db", "results.db")

SCHEMA = """
CREATE TABLE IF NOT EXISTS modules (
    module_name TEXT PRIMARY KEY,
    category TEXT NOT NULL,
    prompt_path TEXT NOT NULL,
    generated_path TEXT NOT NULL,
    generation_timestamp TEXT
);

CREATE TABLE IF NOT EXISTS lint_results (
    module_name TEXT PRIMARY KEY,
    passed INTEGER NOT NULL,
    raw_log TEXT,
    FOREIGN KEY(module_name) REFERENCES modules(module_name)
);

CREATE TABLE IF NOT EXISTS synth_results (
    module_name TEXT PRIMARY KEY,
    passed INTEGER NOT NULL,
    num_cells INTEGER,
    num_wires INTEGER,
    latch_warning INTEGER NOT NULL DEFAULT 0,
    width_mismatch_warning INTEGER NOT NULL DEFAULT 0,
    other_warnings TEXT,
    raw_log TEXT,
    FOREIGN KEY(module_name) REFERENCES modules(module_name)
);

CREATE TABLE IF NOT EXISTS sim_results (
    module_name TEXT PRIMARY KEY,
    ran INTEGER NOT NULL,
    passed INTEGER,
    mismatch_count INTEGER,
    raw_log TEXT,
    timed_out INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY(module_name) REFERENCES modules(module_name)
);

CREATE TABLE IF NOT EXISTS verdicts (
    module_name TEXT PRIMARY KEY,
    final_verdict TEXT NOT NULL,       -- PASS | FAIL
    failure_category TEXT,             -- NULL if PASS
    failure_detail TEXT,
    FOREIGN KEY(module_name) REFERENCES modules(module_name)
);
"""

def main():
    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.executescript(SCHEMA)
    conn.commit()
    conn.close()
    print(f"DB initialized at {DB_PATH}")

if __name__ == "__main__":
    main()
