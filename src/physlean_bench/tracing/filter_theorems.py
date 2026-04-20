"""Filtering rules for benchmark candidate theorem selection."""

from __future__ import annotations

from dataclasses import dataclass
import re

from physlean_bench.schemas import TracedTheoremInfo


_PLACEHOLDER_PATTERN = re.compile(r"\b(sorry|admit|TODO|placeholder)\b", re.IGNORECASE)


@dataclass
class FilterPolicy:
    exclude_without_proof: bool = True
    exclude_without_statement: bool = True
    exclude_sorry: bool = True
    exclude_auto_generated: bool = True
    exclude_internal_names: bool = True
    exclude_non_theorem_like: bool = True
    exclude_duplicate_statements: bool = True
    exclude_likely_trivial: bool = False
    exclude_very_short_proofs: bool = False


def infer_internal_declaration(theorem: TracedTheoremInfo) -> bool:
    name = theorem.declaration_name
    return name.startswith("_") or ".match_" in name or ".proof_" in name


def should_keep_theorem(theorem: TracedTheoremInfo, policy: FilterPolicy) -> tuple[bool, str | None]:
    if policy.exclude_without_statement and not theorem.statement.strip():
        return False, "missing_statement"

    if policy.exclude_without_proof and not theorem.proof_text:
        return False, "missing_proof"

    if policy.exclude_non_theorem_like:
        statement = theorem.statement.strip()
        if not (statement.startswith("theorem ") or statement.startswith("lemma ")):
            return False, "non_theorem_like_declaration"

    if policy.exclude_sorry:
        if theorem.has_sorry or theorem.has_admit:
            return False, "contains_sorry_or_admit"
        if theorem.proof_text and _PLACEHOLDER_PATTERN.search(theorem.proof_text):
            return False, "placeholder_proof_pattern"

    if policy.exclude_auto_generated and theorem.is_auto_generated:
        return False, "auto_generated"

    if policy.exclude_internal_names and infer_internal_declaration(theorem):
        return False, "internal_declaration"

    if policy.exclude_duplicate_statements and "duplicate_statement" in theorem.quality_flags:
        return False, "duplicate_statement"

    if policy.exclude_very_short_proofs and "very_short_proof" in theorem.quality_flags:
        return False, "very_short_proof"

    if policy.exclude_likely_trivial and (
        "likely_trivial" in theorem.quality_flags
        or "likely_rfl_only" in theorem.quality_flags
        or "likely_simp_only" in theorem.quality_flags
    ):
        return False, "likely_trivial_proof"

    return True, None


def filter_theorems(
    theorems: list[TracedTheoremInfo],
    policy: FilterPolicy,
) -> tuple[list[TracedTheoremInfo], dict[str, int]]:
    kept: list[TracedTheoremInfo] = []
    dropped_counts: dict[str, int] = {}

    for theorem in theorems:
        keep, reason = should_keep_theorem(theorem, policy)
        if keep:
            kept.append(theorem)
            continue
        assert reason is not None
        dropped_counts[reason] = dropped_counts.get(reason, 0) + 1

    return kept, dropped_counts
