from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path

from physlean_bench.dataset.manifests import build_manifest
from physlean_bench.schemas import SourceRepoInfo


def test_manifest_contains_artifact_and_config_hashes(tmp_path: Path) -> None:
    artifact = tmp_path / "artifact.jsonl"
    artifact.write_text('{"k": 1}\n', encoding="utf-8")

    config_file = tmp_path / "config.yaml"
    config_file.write_text("seed: 1337\n", encoding="utf-8")

    source = SourceRepoInfo(
        name="leanprover-community/physlib",
        url="https://github.com/leanprover-community/physlib.git",
        commit="abc123",
        clone_path=Path("data/source/physlib"),
        tracing_tool="leandojo-v2",
        tracing_tool_version="4.20.0",
        lean_toolchain="leanprover/lean4:v4.20.0",
        build_command=["lake", "build", "Physlib"],
        generation_timestamp_utc=datetime.now(timezone.utc).isoformat(),
    )

    manifest = build_manifest(
        benchmark_name="test",
        task_family="theorem_completion",
        source_repo=source,
        generation_config={"seed": 1337},
        artifact_paths=[artifact],
        config_paths=[config_file],
    )

    payload = manifest.to_dict()
    assert str(artifact) in payload["artifact_hashes"]
    assert str(config_file) in payload["config_fingerprints"]
    assert payload["benchmark_manifest_hash"]
