from __future__ import annotations

from pathlib import Path

from physlean_bench.reports.audit_completion import (
    AuditSampleConfig,
    build_audit_sample,
    build_traced_vs_source_scan_comparison,
    write_audit_sample_artifacts,
)
from physlean_bench.schemas import CompletionExample
from physlean_bench.utils.io import read_json


def _example(idx: int, namespace: str, file_path: str, flags: list[str]) -> CompletionExample:
    return CompletionExample(
        example_id=f"completion::{idx}",
        theorem_id=f"t{idx}",
        imports=["Mathlib"],
        context_header="import Mathlib",
        theorem_statement=f"theorem t{idx} : True :=",
        prompt_with_sorry=f"theorem t{idx} : True := by sorry",
        gold_proof="by trivial",
        theorem_metadata={
            "declaration_name": f"{namespace}.t{idx}",
            "namespace": namespace,
            "file_path": file_path,
            "quality_flags": flags,
            "quality_metrics": {"proof_chars": 10 + idx},
        },
        accessible_premises=["True.intro"],
        used_premises=["True.intro"],
    )


def test_audit_sample_and_artifact_export(tmp_path: Path) -> None:
    examples = [
        _example(1, "PhysLean.A", "PhysLean/A.lean", ["likely_trivial"]),
        _example(2, "PhysLean.B", "PhysLean/B.lean", []),
    ]
    payload = build_audit_sample(
        examples,
        AuditSampleConfig(sample_size=1, seed=0, suspicious_only=True),
    )
    assert payload["counts"]["num_filtered_examples"] == 1
    assert payload["counts"]["num_sampled_examples"] == 1

    out_json = tmp_path / "audit.json"
    out_md = tmp_path / "audit.md"
    write_audit_sample_artifacts(payload, output_json=out_json, output_markdown=out_md)
    assert out_md.exists()
    stored = read_json(out_json)
    assert stored["counts"]["num_sampled_examples"] == 1


def test_traced_vs_source_scan_comparison() -> None:
    traced = [_example(1, "PhysLean.A", "PhysLean/A.lean", [])]
    source_scan = [_example(2, "PhysLean.B", "PhysLean/B.lean", [])]
    payload = build_traced_vs_source_scan_comparison(traced, source_scan)
    assert payload["traced_count"] == 1
    assert payload["source_scan_count"] == 1
    assert payload["overlap_count"] == 0
