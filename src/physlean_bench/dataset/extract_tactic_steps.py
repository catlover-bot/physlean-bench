"""Build tactic-prediction examples from theorem proof text.

This initial implementation is heuristic and should be replaced with structured trace-level
state transitions once LeanDojo-v2 integration provides robust tactic-step boundaries.
"""

from __future__ import annotations

from physlean_bench.schemas import TacticExample, TracedTheoremInfo


def _extract_tactic_lines(proof_text: str) -> list[str]:
    lines = [line.strip() for line in proof_text.splitlines()]
    return [line for line in lines if line and not line.startswith("--")]


def make_tactic_examples(theorems: list[TracedTheoremInfo]) -> list[TacticExample]:
    examples: list[TacticExample] = []
    for theorem in theorems:
        if not theorem.proof_text:
            continue

        tactics = _extract_tactic_lines(theorem.proof_text)
        for index, tactic in enumerate(tactics):
            metadata = {
                "declaration_name": theorem.declaration_name,
                "namespace": theorem.namespace,
                "module_path": theorem.module_path,
                "file_path": theorem.file_path,
                "heuristic_step_index": index,
            }
            examples.append(
                TacticExample(
                    example_id=f"tactic::{theorem.theorem_id}::{index}",
                    theorem_id=theorem.theorem_id,
                    proof_state=f"TODO_PROOF_STATE::{theorem.theorem_id}::{index}",
                    next_tactic=tactic,
                    next_proof_state=None,
                    theorem_metadata=metadata,
                )
            )
    return examples
