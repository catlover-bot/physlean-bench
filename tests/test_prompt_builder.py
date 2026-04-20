from __future__ import annotations

from physlean_bench.eval.prompt_builder import PromptConfig, build_completion_prompt
from physlean_bench.schemas import CompletionExample


def test_build_completion_prompt_contains_core_sections() -> None:
    example = CompletionExample(
        example_id="completion::demo",
        theorem_id="demo",
        imports=["Mathlib", "PhysLean"],
        context_header="import Mathlib\nimport PhysLean",
        theorem_statement="theorem demo : True := by sorry",
        prompt_with_sorry="theorem demo : True := by sorry",
        gold_proof="by trivial",
        theorem_metadata={"namespace": "PhysLean.Mock"},
        accessible_premises=["True.intro", "by_contra"],
        used_premises=["True.intro"],
    )

    prompt = build_completion_prompt(
        example,
        PromptConfig(include_accessible_premises=True, max_premises=1),
    )

    assert "import Mathlib" in prompt
    assert "theorem demo : True := by sorry" in prompt
    assert "-- premise: True.intro" in prompt
    assert "Replace `sorry`" in prompt
