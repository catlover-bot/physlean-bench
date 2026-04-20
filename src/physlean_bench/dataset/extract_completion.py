"""Build theorem-completion benchmark examples from theorem inventory."""

from __future__ import annotations

import random

from physlean_bench.schemas import CompletionExample, TracedTheoremInfo


def _build_import_block(imports: list[str]) -> str:
    lines = [f"import {item}" for item in imports]
    return "\n".join(lines)


def build_prompt_with_sorry(theorem_statement: str) -> str:
    """Create a theorem declaration ending in `by sorry`.

    This function uses conservative string heuristics because traced statements can vary
    by extraction backend. Replace with parser-backed logic once LeanDojo-v2 integration
    details are finalized.
    """
    normalized = theorem_statement.strip()
    if "by sorry" in normalized:
        return normalized
    if ":=" in normalized:
        prefix = normalized.split(":=", maxsplit=1)[0].rstrip()
        return f"{prefix} := by sorry"
    if normalized.endswith("by"):
        return f"{normalized} sorry"
    return f"{normalized} := by sorry"


def completion_from_theorem(theorem: TracedTheoremInfo) -> CompletionExample:
    context_header = _build_import_block(theorem.imports)
    prompt_with_sorry = build_prompt_with_sorry(theorem.statement)
    gold_proof = theorem.proof_text or ""

    metadata = {
        "declaration_name": theorem.declaration_name,
        "namespace": theorem.namespace,
        "module_path": theorem.module_path,
        "file_path": theorem.file_path,
        "declaration_kind": theorem.declaration_kind,
        "depends_on_local_physlib": theorem.depends_on_local_physlib,
        "line_start": theorem.line_start,
        "line_end": theorem.line_end,
        "trace_backend": theorem.trace_backend,
        "proof_extraction_method": theorem.proof_extraction_method,
        "quality_flags": theorem.quality_flags,
        "quality_metrics": theorem.quality_metrics,
        "source_url": theorem.source_url,
        "source_commit": theorem.source_commit,
        "tags": theorem.tags,
    }

    return CompletionExample(
        example_id=f"completion::{theorem.theorem_id}",
        theorem_id=theorem.theorem_id,
        imports=theorem.imports,
        context_header=context_header,
        theorem_statement=theorem.statement,
        prompt_with_sorry=prompt_with_sorry,
        gold_proof=gold_proof,
        theorem_metadata=metadata,
        accessible_premises=theorem.accessible_premises,
        used_premises=theorem.used_premises,
    )


def make_completion_examples(theorems: list[TracedTheoremInfo]) -> list[CompletionExample]:
    examples: list[CompletionExample] = []
    for theorem in theorems:
        if not theorem.proof_text:
            continue
        examples.append(completion_from_theorem(theorem))
    return examples


def make_completion_examples_subset(
    theorems: list[TracedTheoremInfo],
    *,
    max_examples: int | None,
    seed: int = 1337,
) -> list[CompletionExample]:
    """Create completion examples with deterministic subset selection."""
    examples = make_completion_examples(theorems)
    if max_examples is None or max_examples >= len(examples):
        return examples
    rng = random.Random(seed)
    selected = list(examples)
    rng.shuffle(selected)
    return selected[:max_examples]
