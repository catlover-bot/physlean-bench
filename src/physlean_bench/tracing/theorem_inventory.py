"""Theorem inventory creation and persistence."""

from __future__ import annotations

from dataclasses import asdict
from pathlib import Path
from typing import Any

from physlean_bench.schemas import TracedTheoremInfo, write_jsonl
from physlean_bench.tracing.filter_theorems import FilterPolicy, filter_theorems, should_keep_theorem
from physlean_bench.tracing.quality import annotate_quality_heuristics, summarize_quality_flags


def annotate_local_premise_dependence(theorem: TracedTheoremInfo) -> TracedTheoremInfo:
    local_prefixes = ("PhysLean", "Physlib")
    theorem.used_local_premises = [
        premise
        for premise in theorem.used_premises
        if any(premise.startswith(prefix) for prefix in local_prefixes)
    ]
    theorem.depends_on_local_physlib = bool(theorem.used_local_premises)
    return theorem


def assert_traced_only(theorems: list[TracedTheoremInfo], required_backend: str = "leandojo_v2") -> None:
    mismatched = [item for item in theorems if item.trace_backend != required_backend]
    if not mismatched:
        return

    preview = ", ".join(item.trace_backend or "unknown" for item in mismatched[:5])
    raise RuntimeError(
        "Traced-only mode requires all records to come from `leandojo_v2`.\n"
        f"Found {len(mismatched)} records with different backend labels (sample: {preview})."
    )


def create_inventory(
    traced_theorems: list[TracedTheoremInfo],
    apply_filter: bool = True,
    policy: FilterPolicy | None = None,
) -> tuple[list[TracedTheoremInfo], dict[str, Any]]:
    annotated = [annotate_local_premise_dependence(theorem) for theorem in traced_theorems]
    annotate_quality_heuristics(annotated)

    if not apply_filter:
        return annotated, {"filtered": False, "num_input": len(traced_theorems), "num_output": len(annotated)}

    filter_policy = policy or FilterPolicy()
    kept, dropped_counts = filter_theorems(annotated, filter_policy)
    summary = {
        "filtered": True,
        "policy": asdict(filter_policy),
        "num_input": len(traced_theorems),
        "num_output": len(kept),
        "dropped_counts": dropped_counts,
    }
    return kept, summary


def create_inventory_with_decisions(
    traced_theorems: list[TracedTheoremInfo],
    policy: FilterPolicy | None = None,
) -> tuple[list[TracedTheoremInfo], list[TracedTheoremInfo], dict[str, Any]]:
    """Create filtered inventory while retaining excluded rows and reasons."""
    filter_policy = policy or FilterPolicy()
    annotated = [annotate_local_premise_dependence(theorem) for theorem in traced_theorems]
    annotate_quality_heuristics(annotated)

    kept: list[TracedTheoremInfo] = []
    excluded: list[TracedTheoremInfo] = []
    excluded_counts: dict[str, int] = {}

    for theorem in annotated:
        include, reason = should_keep_theorem(theorem, filter_policy)
        theorem.filter_excluded_reason = None if include else reason
        if include:
            kept.append(theorem)
            continue
        excluded.append(theorem)
        assert reason is not None
        excluded_counts[reason] = excluded_counts.get(reason, 0) + 1

    summary = {
        "filtered": True,
        "policy": asdict(filter_policy),
        "total_traced_declarations_seen": len(traced_theorems),
        "candidate_theorem_count": len(kept),
        "excluded_count": len(excluded),
        "excluded_by_reason": excluded_counts,
        "num_depends_on_local_physlib": sum(item.depends_on_local_physlib for item in kept),
        "trace_backend_counts": _backend_counts(traced_theorems),
        "quality_summary_kept": summarize_quality_flags(kept),
        "quality_summary_excluded": summarize_quality_flags(excluded),
    }
    return kept, excluded, summary


def _backend_counts(theorems: list[TracedTheoremInfo]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for theorem in theorems:
        backend = theorem.trace_backend or "unknown"
        counts[backend] = counts.get(backend, 0) + 1
    return counts


def save_inventory(inventory: list[TracedTheoremInfo], output_path: Path) -> None:
    write_jsonl(output_path, inventory)


def write_inventory_summary_markdown(path: Path, summary: dict[str, Any]) -> None:
    lines = [
        "# Inventory Summary",
        "",
        f"- total_traced_declarations_seen: `{summary.get('total_traced_declarations_seen', summary.get('num_input', 0))}`",
        f"- candidate_theorem_count: `{summary.get('candidate_theorem_count', summary.get('num_output', 0))}`",
        f"- excluded_count: `{summary.get('excluded_count', 0)}`",
    ]

    excluded = summary.get("excluded_by_reason", summary.get("dropped_counts", {}))
    if isinstance(excluded, dict) and excluded:
        lines.append("- excluded_by_reason:")
        for reason, count in sorted(excluded.items(), key=lambda item: (-int(item[1]), str(item[0]))):
            lines.append(f"  - `{reason}`: `{count}`")

    backend_counts = summary.get("trace_backend_counts", {})
    if isinstance(backend_counts, dict) and backend_counts:
        lines.append("- trace_backend_counts:")
        for backend, count in sorted(backend_counts.items(), key=lambda item: (-int(item[1]), str(item[0]))):
            lines.append(f"  - `{backend}`: `{count}`")

    quality_summary = summary.get("quality_summary_kept", {})
    if isinstance(quality_summary, dict):
        flag_counts = quality_summary.get("quality_flag_counts", {})
        if isinstance(flag_counts, dict) and flag_counts:
            lines.append("- quality_flag_counts (kept):")
            for flag, count in sorted(flag_counts.items(), key=lambda item: (-int(item[1]), str(item[0]))):
                lines.append(f"  - `{flag}`: `{count}`")

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")
