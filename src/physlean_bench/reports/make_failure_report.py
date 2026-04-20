"""Create markdown report from failure-case JSONL."""

from __future__ import annotations

from pathlib import Path

from physlean_bench.schemas import FailureCase, read_jsonl


def make_failure_report(failure_jsonl: Path, output_markdown: Path, max_cases: int = 50) -> None:
    failures = read_jsonl(failure_jsonl, FailureCase)  # type: ignore[assignment]
    lines = ["# Failure Analysis", "", f"Total failures: {len(failures)}", ""]

    for item in failures[:max_cases]:
        lines.append(f"## {item.example_id}")
        lines.append(f"- theorem_id: {item.theorem_id}")
        lines.append(f"- stage: {item.failure_stage}")
        lines.append(f"- error_type: {item.error_type}")
        lines.append(f"- message: {item.message}")
        if item.candidate_proof:
            lines.append("- candidate_proof:")
            lines.append("```lean")
            lines.append(item.candidate_proof)
            lines.append("```")
        lines.append("")

    output_markdown.parent.mkdir(parents=True, exist_ok=True)
    output_markdown.write_text("\n".join(lines), encoding="utf-8")
