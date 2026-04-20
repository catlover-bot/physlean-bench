"""Generate markdown summary tables for experiment metrics."""

from __future__ import annotations

from pathlib import Path
from typing import Any

from physlean_bench.utils.io import read_json


def metrics_to_markdown(metrics_payload: dict[str, Any]) -> str:
    metrics = metrics_payload.get("metrics", {})
    pass_at_k = metrics.get("pass_at_k", {})

    lines = ["# Evaluation Summary", "", "| Metric | Value |", "|---|---:|"]
    lines.append(f"| num_examples | {metrics.get('num_examples', 0)} |")
    lines.append(f"| num_verified | {metrics.get('num_verified', 0)} |")
    for key, value in pass_at_k.items():
        lines.append(f"| {key} | {value:.4f} |")
    return "\n".join(lines) + "\n"


def make_metrics_table(metrics_json: Path, output_markdown: Path) -> None:
    payload = read_json(metrics_json)
    markdown = metrics_to_markdown(payload)
    output_markdown.parent.mkdir(parents=True, exist_ok=True)
    output_markdown.write_text(markdown, encoding="utf-8")
