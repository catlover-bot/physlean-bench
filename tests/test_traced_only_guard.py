from __future__ import annotations

import pytest

from physlean_bench.schemas import TracedTheoremInfo
from physlean_bench.tracing.theorem_inventory import assert_traced_only


def _mk(backend: str) -> TracedTheoremInfo:
    return TracedTheoremInfo(
        theorem_id="t1",
        declaration_name="PhysLean.Test.t1",
        namespace="PhysLean.Test",
        module_path="PhysLean.Test",
        file_path="PhysLean/Test.lean",
        statement="theorem t1 : True :=",
        proof_text="by trivial",
        trace_backend=backend,
    )


def test_assert_traced_only_accepts_leandojo_records() -> None:
    assert_traced_only([_mk("leandojo_v2")])


def test_assert_traced_only_rejects_non_leandojo_records() -> None:
    with pytest.raises(RuntimeError):
        assert_traced_only([_mk("source_scan_fallback")])
