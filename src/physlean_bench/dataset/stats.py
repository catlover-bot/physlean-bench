"""Dataset statistics utilities."""

from __future__ import annotations

from collections import Counter
from typing import Any

from physlean_bench.schemas import CompletionExample, TracedTheoremInfo


def summarize_theorem_inventory(theorems: list[TracedTheoremInfo]) -> dict[str, Any]:
    namespace_counter = Counter(item.namespace for item in theorems)
    file_counter = Counter(item.file_path for item in theorems)
    excluded_counter = Counter(
        item.filter_excluded_reason for item in theorems if item.filter_excluded_reason
    )
    quality_flag_counter = Counter(flag for item in theorems for flag in item.quality_flags)
    backend_counter = Counter(item.trace_backend or "unknown" for item in theorems)

    return {
        "num_theorems": len(theorems),
        "num_namespaces": len(namespace_counter),
        "num_files": len(file_counter),
        "num_with_proof_text": sum(1 for item in theorems if item.proof_text),
        "top_namespaces": namespace_counter.most_common(10),
        "top_files": file_counter.most_common(10),
        "num_depends_on_local_physlib": sum(item.depends_on_local_physlib for item in theorems),
        "excluded_by_reason": dict(excluded_counter),
        "quality_flag_counts": dict(quality_flag_counter),
        "trace_backend_counts": dict(backend_counter),
    }


def summarize_completion_examples(examples: list[CompletionExample]) -> dict[str, Any]:
    namespace_counter = Counter(
        str(example.theorem_metadata.get("namespace", "")) for example in examples
    )
    avg_accessible = 0.0
    avg_used = 0.0
    if examples:
        avg_accessible = sum(len(example.accessible_premises) for example in examples) / len(examples)
        avg_used = sum(len(example.used_premises) for example in examples) / len(examples)

    quality_flag_counter = Counter(
        flag
        for item in examples
        for flag in item.theorem_metadata.get("quality_flags", [])
        if isinstance(flag, str)
    )

    return {
        "num_examples": len(examples),
        "avg_accessible_premises": avg_accessible,
        "avg_used_premises": avg_used,
        "num_with_used_premises": sum(1 for item in examples if item.used_premises),
        "top_namespaces": namespace_counter.most_common(10),
        "quality_flag_counts": dict(quality_flag_counter),
    }
