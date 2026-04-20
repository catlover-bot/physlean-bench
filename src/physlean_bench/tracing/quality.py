"""Quality heuristics for traced theorem inventory and completion candidates."""

from __future__ import annotations

from collections import Counter
from dataclasses import dataclass
import re
from typing import Any

from physlean_bench.schemas import TracedTheoremInfo


_WS_RE = re.compile(r"\s+")
_RFL_ONLY_RE = re.compile(r"^\s*by\s+rfl\s*$", re.MULTILINE)
_SIMP_ONLY_RE = re.compile(r"^\s*by\s+simp(?:\s*\[[^\]]*\])?\s*$", re.MULTILINE)


@dataclass(frozen=True)
class QualityHeuristicConfig:
    short_proof_char_threshold: int = 24
    duplicate_statement_min_chars: int = 12


def _normalize_text(text: str) -> str:
    return _WS_RE.sub(" ", text.strip())


def _proof_line_count(text: str | None) -> int:
    if not text:
        return 0
    return sum(1 for line in text.splitlines() if line.strip())


def annotate_quality_heuristics(
    theorems: list[TracedTheoremInfo],
    *,
    config: QualityHeuristicConfig | None = None,
) -> list[TracedTheoremInfo]:
    cfg = config or QualityHeuristicConfig()

    statement_buckets: dict[str, list[TracedTheoremInfo]] = {}
    for item in theorems:
        normalized_statement = _normalize_text(item.statement)
        if len(normalized_statement) >= cfg.duplicate_statement_min_chars:
            statement_buckets.setdefault(normalized_statement, []).append(item)

    duplicate_statement_ids: set[str] = set()
    for grouped in statement_buckets.values():
        if len(grouped) > 1:
            duplicate_statement_ids.update(item.theorem_id for item in grouped)

    for item in theorems:
        proof = item.proof_text or ""
        compact_proof = _normalize_text(proof)
        compact_statement = _normalize_text(item.statement)
        flags: set[str] = set(item.quality_flags)

        proof_chars = len(compact_proof)
        proof_lines = _proof_line_count(proof)

        if not item.proof_text:
            flags.add("no_proof_text")
        if proof_chars and proof_chars <= cfg.short_proof_char_threshold:
            flags.add("very_short_proof")
        if compact_proof and _RFL_ONLY_RE.match(compact_proof):
            flags.add("likely_rfl_only")
        if compact_proof and _SIMP_ONLY_RE.match(compact_proof):
            flags.add("likely_simp_only")
        if compact_proof in {"by trivial", "by exact True.intro"}:
            flags.add("likely_trivial")
        if item.theorem_id in duplicate_statement_ids:
            flags.add("duplicate_statement")
        if not item.accessible_premises:
            flags.add("no_accessible_premises")
        if not item.used_premises:
            flags.add("no_used_premises")

        item.quality_flags = sorted(flags)
        item.quality_metrics = {
            **item.quality_metrics,
            "statement_chars": len(compact_statement),
            "proof_chars": proof_chars,
            "proof_lines": proof_lines,
            "num_accessible_premises": len(item.accessible_premises),
            "num_used_premises": len(item.used_premises),
        }
    return theorems


def summarize_quality_flags(theorems: list[TracedTheoremInfo]) -> dict[str, Any]:
    flag_counter = Counter(flag for item in theorems for flag in item.quality_flags)
    namespace_counter = Counter(item.namespace for item in theorems)
    file_counter = Counter(item.file_path for item in theorems)

    return {
        "quality_flag_counts": dict(flag_counter),
        "num_duplicates": int(flag_counter.get("duplicate_statement", 0)),
        "num_likely_trivial": int(
            flag_counter.get("likely_trivial", 0)
            + flag_counter.get("likely_rfl_only", 0)
            + flag_counter.get("likely_simp_only", 0)
        ),
        "top_namespaces": namespace_counter.most_common(10),
        "top_files": file_counter.most_common(10),
    }
