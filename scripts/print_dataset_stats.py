#!/usr/bin/env python3
"""Print quick dataset stats for inventory or completion JSONL."""

from __future__ import annotations

import argparse
from pathlib import Path

from physlean_bench.dataset.stats import summarize_completion_examples, summarize_theorem_inventory
from physlean_bench.schemas import CompletionExample, TracedTheoremInfo, read_jsonl


def main() -> None:
    parser = argparse.ArgumentParser(description="Print dataset stats from JSONL")
    parser.add_argument("--input-jsonl", type=Path, required=True)
    parser.add_argument("--type", choices=["inventory", "completion"], required=True)
    args = parser.parse_args()

    if args.type == "inventory":
        records = read_jsonl(args.input_jsonl, TracedTheoremInfo)
        summary = summarize_theorem_inventory(records)  # type: ignore[arg-type]
    else:
        records = read_jsonl(args.input_jsonl, CompletionExample)
        summary = summarize_completion_examples(records)  # type: ignore[arg-type]

    for key, value in summary.items():
        print(f"{key}: {value}")


if __name__ == "__main__":
    main()
