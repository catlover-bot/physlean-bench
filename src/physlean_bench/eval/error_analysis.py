"""Failure-case extraction utilities for model evaluation outputs."""

from __future__ import annotations

from collections import Counter
from typing import Any

from physlean_bench.schemas import EvaluationResult, FailureCase


def _classify_error(message: str | None) -> str:
    if not message:
        return "unknown"
    lower = message.lower()
    if "timeout" in lower:
        return "timeout"
    if "unknown constant" in lower:
        return "unknown_constant"
    if "type mismatch" in lower:
        return "type_mismatch"
    if "tactic" in lower and "failed" in lower:
        return "tactic_failure"
    return "other"


def collect_failure_cases(results: list[EvaluationResult]) -> list[FailureCase]:
    failures: list[FailureCase] = []
    for result in results:
        if result.verification_success:
            continue
        failures.append(
            FailureCase(
                run_id=result.run_id,
                example_id=result.example_id,
                theorem_id=result.theorem_id,
                failure_stage="verification",
                error_type=_classify_error(result.verification_error),
                message=result.verification_error or "verification_failed",
                candidate_proof=result.selected_proof,
                metadata={"num_generations": len(result.generated_proofs)},
            )
        )
    return failures


def summarize_failure_types(failures: list[FailureCase]) -> dict[str, Any]:
    counter = Counter(item.error_type for item in failures)
    return {
        "num_failures": len(failures),
        "error_type_counts": dict(counter),
    }
