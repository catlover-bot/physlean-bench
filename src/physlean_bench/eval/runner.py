"""Evaluation runner for theorem completion experiments."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import logging
import time
from datetime import datetime, timezone

from physlean_bench.eval.metrics import summarize_run
from physlean_bench.eval.model_adapter import GenerationRequest, ModelAdapter
from physlean_bench.eval.prompt_builder import PromptConfig, build_completion_prompt
from physlean_bench.eval.verifier import VerificationConfig, verify_candidate
from physlean_bench.schemas import CompletionExample, EvaluationResult, write_jsonl
from physlean_bench.utils.io import write_json

logger = logging.getLogger(__name__)


@dataclass
class RunnerConfig:
    run_id: str
    ks: list[int]
    output_dir: Path
    verify_proofs: bool
    prompt_config: PromptConfig
    verification_config: VerificationConfig | None = None
    max_examples: int | None = None


def run_completion_evaluation(
    examples: list[CompletionExample],
    adapter: ModelAdapter,
    runner_config: RunnerConfig,
    temperature: float,
    max_tokens: int,
) -> list[EvaluationResult]:
    runner_config.output_dir.mkdir(parents=True, exist_ok=True)
    selected_examples = examples[: runner_config.max_examples] if runner_config.max_examples else examples

    k_max = max(runner_config.ks)
    results: list[EvaluationResult] = []

    for idx, example in enumerate(selected_examples):
        prompt = build_completion_prompt(example, runner_config.prompt_config)
        request = GenerationRequest(
            prompt=prompt,
            num_samples=k_max,
            temperature=temperature,
            max_tokens=max_tokens,
        )

        start = time.perf_counter()
        response = adapter.generate(request)
        elapsed_ms = (time.perf_counter() - start) * 1000.0

        generated = response.generations
        selected_proof = generated[0] if generated else None
        verification_success = False
        verification_error: str | None = None

        if runner_config.verify_proofs and runner_config.verification_config is not None and selected_proof:
            outcome = verify_candidate(
                example,
                selected_proof,
                runner_config.verification_config,
                candidate_name=f"{example.example_id.replace('::', '_')}_{idx}",
            )
            verification_success = outcome.success
            if not outcome.success:
                verification_error = outcome.stderr or outcome.stdout

        pass_map: dict[str, bool] = {}
        for k in runner_config.ks:
            proofs_up_to_k = generated[:k]
            # Placeholder: true iff verifier accepted first proof and k >= 1.
            # TODO: verify each candidate independently for true pass@k semantics.
            pass_map[str(k)] = verification_success and bool(proofs_up_to_k)

        result = EvaluationResult(
            run_id=runner_config.run_id,
            example_id=example.example_id,
            theorem_id=example.theorem_id,
            generated_proofs=generated,
            pass_at_k=pass_map,
            verification_success=verification_success,
            selected_proof=selected_proof,
            verification_error=verification_error,
            latency_ms=elapsed_ms,
            raw_model_response=response.raw_response,
        )
        results.append(result)

    write_jsonl(runner_config.output_dir / "evaluation_results.jsonl", results)
    metrics = summarize_run(results, runner_config.ks)
    write_json(
        runner_config.output_dir / "metrics.json",
        {
            "run_id": runner_config.run_id,
            "generated_at_utc": datetime.now(timezone.utc).isoformat(),
            "metrics": metrics,
        },
    )
    logger.info("Wrote %d evaluation results to %s", len(results), runner_config.output_dir)
    return results
