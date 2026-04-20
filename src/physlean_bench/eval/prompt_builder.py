"""Prompt construction for theorem completion and future tasks."""

from __future__ import annotations

from dataclasses import dataclass

from physlean_bench.schemas import CompletionExample


@dataclass
class PromptConfig:
    include_accessible_premises: bool = True
    max_premises: int = 64


def build_completion_prompt(example: CompletionExample, config: PromptConfig | None = None) -> str:
    cfg = config or PromptConfig()

    sections: list[str] = []
    if example.context_header:
        sections.append(example.context_header)

    if cfg.include_accessible_premises:
        premises = example.accessible_premises[: cfg.max_premises]
        premise_lines = [f"-- premise: {premise}" for premise in premises]
        if premise_lines:
            sections.append("\n".join(premise_lines))

    sections.append(example.prompt_with_sorry)
    sections.append("-- Replace `sorry` with a valid Lean proof term/script.")
    return "\n\n".join(sections)
