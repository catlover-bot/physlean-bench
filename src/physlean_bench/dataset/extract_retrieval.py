"""Build premise-retrieval examples from theorem metadata."""

from __future__ import annotations

from physlean_bench.schemas import RetrievalExample, TracedTheoremInfo


def make_retrieval_examples(theorems: list[TracedTheoremInfo]) -> list[RetrievalExample]:
    examples: list[RetrievalExample] = []

    for theorem in theorems:
        metadata = {
            "declaration_name": theorem.declaration_name,
            "namespace": theorem.namespace,
            "module_path": theorem.module_path,
            "file_path": theorem.file_path,
        }
        examples.append(
            RetrievalExample(
                example_id=f"retrieval::{theorem.theorem_id}",
                theorem_id=theorem.theorem_id,
                query=theorem.statement,
                candidate_premises=theorem.accessible_premises,
                relevant_premises=theorem.used_premises,
                theorem_metadata=metadata,
            )
        )

    return examples
