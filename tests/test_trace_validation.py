from __future__ import annotations

from pathlib import Path

from physlean_bench.schemas import TracedTheoremInfo, write_jsonl
from physlean_bench.tracing.trace_validation import validate_trace_artifacts
from physlean_bench.utils.io import write_json


def _mk() -> TracedTheoremInfo:
    return TracedTheoremInfo(
        theorem_id="t1",
        declaration_name="PhysLean.Test.t1",
        namespace="PhysLean.Test",
        module_path="PhysLean.Test",
        file_path="PhysLean/Test.lean",
        statement="theorem t1 : True :=",
        proof_text="by trivial",
        trace_backend="leandojo_v2",
    )


def test_trace_validation_ok_for_matching_backend_and_metadata(tmp_path: Path) -> None:
    traced_jsonl = tmp_path / "traced.jsonl"
    write_jsonl(traced_jsonl, [_mk()])

    metadata_json = tmp_path / "trace_meta.json"
    write_json(
        metadata_json,
        {
            "source_url": "https://github.com/leanprover-community/physlib.git",
            "source_commit": "abc123",
            "trace_backend": "leandojo_v2",
            "tracing_tool": "leandojo-v2",
            "tracing_tool_version": "test",
            "generated_at_utc": "2026-01-01T00:00:00+00:00",
        },
    )

    report = validate_trace_artifacts(
        traced_jsonl_path=traced_jsonl,
        metadata_path=metadata_json,
        required_backend="leandojo_v2",
        expected_source_url="https://github.com/leanprover-community/physlib.git",
        expected_source_commit="abc123",
        include_prefixes=["PhysLean/", "Physlib/"],
        exclude_prefixes=["QuantumInfo/"],
        min_records=1,
    )
    assert report.ok
    assert report.stats["num_records"] == 1


def test_trace_validation_fails_on_backend_mismatch(tmp_path: Path) -> None:
    traced_jsonl = tmp_path / "traced.jsonl"
    theorem = _mk()
    theorem.trace_backend = "source_scan_fallback"
    write_jsonl(traced_jsonl, [theorem])

    metadata_json = tmp_path / "trace_meta.json"
    write_json(
        metadata_json,
        {
            "source_url": "https://github.com/leanprover-community/physlib.git",
            "source_commit": "abc123",
            "trace_backend": "source_scan",
            "tracing_tool": "source_scan",
            "tracing_tool_version": "test",
            "generated_at_utc": "2026-01-01T00:00:00+00:00",
        },
    )

    report = validate_trace_artifacts(
        traced_jsonl_path=traced_jsonl,
        metadata_path=metadata_json,
        required_backend="leandojo_v2",
        expected_source_url=None,
        expected_source_commit=None,
        include_prefixes=["PhysLean/"],
        exclude_prefixes=[],
        min_records=1,
    )
    assert not report.ok
    codes = {issue.code for issue in report.issues}
    assert "backend_mismatch_records" in codes
