#!/usr/bin/env python3
"""Generate a synthetic manifest example for schema inspection."""

from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path

from physlean_bench.dataset.manifests import build_manifest, write_manifest
from physlean_bench.schemas import SourceRepoInfo


def main() -> None:
    root = Path(__file__).resolve().parents[1]
    mock_artifact = root / "examples" / "mock_data" / "completion.synthetic.jsonl"

    source_info = SourceRepoInfo(
        name="leanprover-community/physlib",
        url="https://github.com/leanprover-community/physlib.git",
        commit="0000000000000000000000000000000000000000",
        clone_path=Path("data/source/physlib"),
        tracing_tool="leandojo-v2",
        tracing_tool_version="placeholder",
        lean_toolchain="leanprover/lean4:placeholder",
        build_command=["lake", "build", "Physlib"],
        generation_timestamp_utc=datetime.now(timezone.utc).isoformat(),
    )

    manifest = build_manifest(
        benchmark_name="physlean_completion_v0_mock",
        task_family="theorem_completion",
        source_repo=source_info,
        generation_config={
            "split_strategy": "namespace",
            "filter_policy": {
                "exclude_without_proof": True,
                "exclude_sorry": True,
                "exclude_auto_generated": True,
            },
        },
        artifact_paths=[mock_artifact],
    )

    output = root / "examples" / "mock_data" / "manifest.synthetic.json"
    write_manifest(manifest, output)
    print(f"Wrote synthetic manifest to {output}")


if __name__ == "__main__":
    main()
