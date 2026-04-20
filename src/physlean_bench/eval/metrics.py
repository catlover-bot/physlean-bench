"""Evaluation metrics for theorem proving runs."""

from __future__ import annotations

from typing import Any

from physlean_bench.schemas import EvaluationResult


def summarize_pass_at_k(results: list[EvaluationResult], ks: list[int]) -> dict[str, float]:
    summary: dict[str, float] = {}
    if not results:
        return {f"pass@{k}": 0.0 for k in ks}

    for k in ks:
        key = f"pass@{k}"
        success_count = 0
        for result in results:
            if result.pass_at_k.get(str(k), False):
                success_count += 1
        summary[key] = success_count / len(results)
    return summary


def summarize_run(results: list[EvaluationResult], ks: list[int]) -> dict[str, Any]:
    return {
        "num_examples": len(results),
        "pass_at_k": summarize_pass_at_k(results, ks),
        "num_verified": sum(1 for result in results if result.verification_success),
    }
