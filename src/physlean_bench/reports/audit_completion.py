"""Audit tooling for completion dataset quality inspection."""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
import random
from pathlib import Path
from typing import Any

from physlean_bench.schemas import CompletionExample, TracedTheoremInfo, read_jsonl
from physlean_bench.utils.io import write_json


SUSPICIOUS_FLAGS = {
    "very_short_proof",
    "likely_trivial",
    "likely_rfl_only",
    "likely_simp_only",
    "duplicate_statement",
}


@dataclass(frozen=True)
class AuditSampleConfig:
    sample_size: int
    seed: int = 1337
    namespace_prefix: str | None = None
    file_prefix: str | None = None
    difficulty: str | None = None
    suspicious_only: bool = False


def _difficulty_bucket(example: CompletionExample) -> str:
    quality_flags = {
        str(flag) for flag in example.theorem_metadata.get("quality_flags", []) if isinstance(flag, str)
    }
    quality_metrics = example.theorem_metadata.get("quality_metrics", {})
    proof_chars = int(quality_metrics.get("proof_chars", len(example.gold_proof.strip())))
    used = len(example.used_premises)

    if quality_flags.intersection({"likely_trivial", "likely_rfl_only", "likely_simp_only"}) or proof_chars <= 32:
        return "easy"
    if used >= 3 or proof_chars >= 180:
        return "hard"
    return "medium"


def _example_key(example: CompletionExample) -> tuple[str, str]:
    decl = str(example.theorem_metadata.get("declaration_name", example.theorem_id))
    file_path = str(example.theorem_metadata.get("file_path", ""))
    return decl, file_path


def build_audit_sample(
    examples: list[CompletionExample],
    config: AuditSampleConfig,
) -> dict[str, Any]:
    filtered: list[CompletionExample] = []
    for item in examples:
        namespace = str(item.theorem_metadata.get("namespace", ""))
        file_path = str(item.theorem_metadata.get("file_path", ""))
        flags = {
            str(flag) for flag in item.theorem_metadata.get("quality_flags", []) if isinstance(flag, str)
        }
        difficulty = _difficulty_bucket(item)

        if config.namespace_prefix and not namespace.startswith(config.namespace_prefix):
            continue
        if config.file_prefix and not file_path.startswith(config.file_prefix):
            continue
        if config.difficulty and difficulty != config.difficulty:
            continue
        if config.suspicious_only and not flags.intersection(SUSPICIOUS_FLAGS):
            continue
        filtered.append(item)

    rng = random.Random(config.seed)
    sampled = list(filtered)
    rng.shuffle(sampled)
    sampled = sampled[: config.sample_size]

    namespace_counter = Counter(str(item.theorem_metadata.get("namespace", "")) for item in filtered)
    difficulty_counter = Counter(_difficulty_bucket(item) for item in filtered)
    suspicious_counter = Counter(
        flag
        for item in filtered
        for flag in item.theorem_metadata.get("quality_flags", [])
        if isinstance(flag, str) and flag in SUSPICIOUS_FLAGS
    )

    sampled_payload = []
    for item in sampled:
        sampled_payload.append(
            {
                "example_id": item.example_id,
                "theorem_id": item.theorem_id,
                "declaration_name": item.theorem_metadata.get("declaration_name"),
                "namespace": item.theorem_metadata.get("namespace"),
                "file_path": item.theorem_metadata.get("file_path"),
                "difficulty": _difficulty_bucket(item),
                "quality_flags": item.theorem_metadata.get("quality_flags", []),
                "prompt_with_sorry": item.prompt_with_sorry,
                "gold_proof": item.gold_proof,
                "num_accessible_premises": len(item.accessible_premises),
                "num_used_premises": len(item.used_premises),
            }
        )

    return {
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "config": {
            "sample_size": config.sample_size,
            "seed": config.seed,
            "namespace_prefix": config.namespace_prefix,
            "file_prefix": config.file_prefix,
            "difficulty": config.difficulty,
            "suspicious_only": config.suspicious_only,
        },
        "counts": {
            "num_input_examples": len(examples),
            "num_filtered_examples": len(filtered),
            "num_sampled_examples": len(sampled_payload),
        },
        "difficulty_distribution_filtered": dict(difficulty_counter),
        "top_namespaces_filtered": namespace_counter.most_common(20),
        "suspicious_flag_counts_filtered": dict(suspicious_counter),
        "sampled_examples": sampled_payload,
    }


def write_audit_sample_artifacts(payload: dict[str, Any], *, output_json: Path, output_markdown: Path) -> None:
    write_json(output_json, payload)

    lines = [
        "# Completion Audit Sample",
        "",
        f"- generated_at_utc: `{payload.get('generated_at_utc')}`",
        f"- num_input_examples: `{payload.get('counts', {}).get('num_input_examples', 0)}`",
        f"- num_filtered_examples: `{payload.get('counts', {}).get('num_filtered_examples', 0)}`",
        f"- num_sampled_examples: `{payload.get('counts', {}).get('num_sampled_examples', 0)}`",
        "",
        "## Suspicious Flags",
        "",
    ]

    suspicious = payload.get("suspicious_flag_counts_filtered", {})
    if isinstance(suspicious, dict) and suspicious:
        for key, value in sorted(suspicious.items(), key=lambda item: (-int(item[1]), str(item[0]))):
            lines.append(f"- `{key}`: `{value}`")
    else:
        lines.append("- none")

    excluded_summary = payload.get("excluded_summary", {})
    if isinstance(excluded_summary, dict) and excluded_summary:
        lines.extend(["", "## Excluded By Reason", ""])
        excluded_by_reason = excluded_summary.get("excluded_by_reason", {})
        if isinstance(excluded_by_reason, dict) and excluded_by_reason:
            for reason, count in sorted(
                excluded_by_reason.items(), key=lambda item: (-int(item[1]), str(item[0]))
            ):
                lines.append(f"- `{reason}`: `{count}`")
        else:
            lines.append("- none")

    lines.extend(["", "## Sampled Examples", ""])
    for item in payload.get("sampled_examples", []):
        lines.append(f"### {item.get('example_id')}")
        lines.append(f"- theorem_id: `{item.get('theorem_id')}`")
        lines.append(f"- declaration_name: `{item.get('declaration_name')}`")
        lines.append(f"- namespace: `{item.get('namespace')}`")
        lines.append(f"- file_path: `{item.get('file_path')}`")
        lines.append(f"- difficulty: `{item.get('difficulty')}`")
        lines.append(f"- quality_flags: `{item.get('quality_flags')}`")
        lines.append("")

    output_markdown.parent.mkdir(parents=True, exist_ok=True)
    output_markdown.write_text("\n".join(lines) + "\n", encoding="utf-8")


def summarize_excluded_by_reason(excluded_items: list[TracedTheoremInfo]) -> dict[str, Any]:
    reason_counter = Counter(item.filter_excluded_reason or "unknown" for item in excluded_items)
    samples: dict[str, list[dict[str, str]]] = {}
    for item in excluded_items:
        reason = item.filter_excluded_reason or "unknown"
        bucket = samples.setdefault(reason, [])
        if len(bucket) >= 5:
            continue
        bucket.append(
            {
                "declaration_name": item.declaration_name,
                "file_path": item.file_path,
                "namespace": item.namespace,
            }
        )
    return {
        "num_excluded": len(excluded_items),
        "excluded_by_reason": dict(reason_counter),
        "excluded_samples_by_reason": samples,
    }


def build_traced_vs_source_scan_comparison(
    traced_examples: list[CompletionExample],
    source_scan_examples: list[CompletionExample],
) -> dict[str, Any]:
    traced_keys = {_example_key(item) for item in traced_examples}
    source_keys = {_example_key(item) for item in source_scan_examples}

    overlap = traced_keys.intersection(source_keys)
    traced_only = traced_keys - source_keys
    source_only = source_keys - traced_keys

    return {
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "traced_count": len(traced_examples),
        "source_scan_count": len(source_scan_examples),
        "overlap_count": len(overlap),
        "traced_only_count": len(traced_only),
        "source_scan_only_count": len(source_only),
        "sample_traced_only": sorted(traced_only)[:25],
        "sample_source_scan_only": sorted(source_only)[:25],
    }


def write_comparison_markdown(payload: dict[str, Any], output_path: Path) -> None:
    lines = [
        "# Traced vs Source Scan Completion Comparison",
        "",
        f"- traced_count: `{payload.get('traced_count', 0)}`",
        f"- source_scan_count: `{payload.get('source_scan_count', 0)}`",
        f"- overlap_count: `{payload.get('overlap_count', 0)}`",
        f"- traced_only_count: `{payload.get('traced_only_count', 0)}`",
        f"- source_scan_only_count: `{payload.get('source_scan_only_count', 0)}`",
        "",
        "## Sample Traced-Only",
        "",
    ]
    for item in payload.get("sample_traced_only", []):
        lines.append(f"- `{item}`")
    lines.extend(["", "## Sample Source-Scan-Only", ""])
    for item in payload.get("sample_source_scan_only", []):
        lines.append(f"- `{item}`")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def load_completion_examples(path: Path) -> list[CompletionExample]:
    return read_jsonl(path, CompletionExample)  # type: ignore[return-value]


def load_inventory_excluded(path: Path) -> list[TracedTheoremInfo]:
    return read_jsonl(path, TracedTheoremInfo)  # type: ignore[return-value]
