from __future__ import annotations

from pathlib import Path

from physlean_bench.tracing.source_scan import SourceScanConfig, scan_repo_theorems


def test_source_scan_extracts_theorem_and_imports(tmp_path: Path) -> None:
    repo = tmp_path / "repo"
    repo.mkdir()
    target = repo / "Physlib"
    target.mkdir()
    lean_file = target / "Demo.lean"
    lean_file.write_text(
        """/-! test file -/\n\nimport Mathlib\n\nnamespace Physlib.Demo\n\nlemma foo : True := by\n  trivial\n\nend Physlib.Demo\n""",
        encoding="utf-8",
    )

    records = scan_repo_theorems(
        SourceScanConfig(
            repo_dir=repo,
            include_prefixes=["Physlib/"],
            exclude_prefixes=[],
        )
    )

    assert len(records) == 1
    rec = records[0]
    assert rec.declaration_name.endswith("foo")
    assert rec.imports == ["Mathlib"]
    assert rec.proof_text is not None
