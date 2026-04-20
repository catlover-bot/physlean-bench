from __future__ import annotations

from physlean_bench.schemas import TracedTheoremInfo
from physlean_bench.tracing.filter_theorems import FilterPolicy, should_keep_theorem


def _mk(statement: str, proof: str | None, name: str = "Physlib.Test.foo") -> TracedTheoremInfo:
    return TracedTheoremInfo(
        theorem_id=name,
        declaration_name=name,
        namespace="Physlib.Test",
        module_path="Physlib.Test",
        file_path="Physlib/Test.lean",
        statement=statement,
        proof_text=proof,
    )


def test_filter_excludes_non_theorem_like() -> None:
    theorem = _mk(statement="def foo : Nat := 1", proof="by decide")
    keep, reason = should_keep_theorem(theorem, FilterPolicy())
    assert not keep
    assert reason == "non_theorem_like_declaration"


def test_filter_keeps_valid_theorem() -> None:
    theorem = _mk(statement="theorem foo : True :=", proof="by\n  trivial")
    keep, reason = should_keep_theorem(theorem, FilterPolicy())
    assert keep
    assert reason is None


def test_filter_excludes_sorry() -> None:
    theorem = _mk(statement="theorem foo : True :=", proof="by\n  sorry")
    keep, reason = should_keep_theorem(theorem, FilterPolicy())
    assert not keep
    assert reason in {"contains_sorry_or_admit", "placeholder_proof_pattern"}


def test_filter_excludes_duplicate_statement_when_flagged() -> None:
    theorem = _mk(statement="theorem foo : True :=", proof="by\n  trivial")
    theorem.quality_flags = ["duplicate_statement"]
    keep, reason = should_keep_theorem(theorem, FilterPolicy())
    assert not keep
    assert reason == "duplicate_statement"
