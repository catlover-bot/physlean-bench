"""Benchmark manifest generation for reproducibility."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from physlean_bench.schemas import SourceRepoInfo
from physlean_bench.utils.hashing import sha256_file, sha256_json
from physlean_bench.utils.io import write_json


@dataclass
class BenchmarkManifest:
    benchmark_name: str
    task_family: str
    generated_at_utc: str
    source_repo: SourceRepoInfo
    tracing_tool: str
    tracing_tool_version: str
    lean_toolchain: str | None
    generation_config: dict[str, Any]
    config_fingerprints: dict[str, str]
    artifact_hashes: dict[str, str]
    benchmark_manifest_hash: str

    def to_dict(self) -> dict[str, Any]:
        payload = asdict(self)
        payload["source_repo"] = self.source_repo.to_dict()
        return payload


def build_manifest(
    benchmark_name: str,
    task_family: str,
    source_repo: SourceRepoInfo,
    generation_config: dict[str, Any],
    artifact_paths: list[Path],
    config_paths: list[Path] | None = None,
) -> BenchmarkManifest:
    artifact_hashes = {str(path): sha256_file(path) for path in artifact_paths if path.exists()}
    config_fingerprints = {
        str(path): sha256_file(path) for path in (config_paths or []) if path.exists()
    }

    template = {
        "benchmark_name": benchmark_name,
        "task_family": task_family,
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "source_repo": source_repo.to_dict(),
        "tracing_tool": source_repo.tracing_tool,
        "tracing_tool_version": source_repo.tracing_tool_version,
        "lean_toolchain": source_repo.lean_toolchain,
        "generation_config": generation_config,
        "config_fingerprints": config_fingerprints,
        "artifact_hashes": artifact_hashes,
    }
    manifest_hash = sha256_json(template)

    return BenchmarkManifest(
        benchmark_name=benchmark_name,
        task_family=task_family,
        generated_at_utc=template["generated_at_utc"],
        source_repo=source_repo,
        tracing_tool=source_repo.tracing_tool,
        tracing_tool_version=source_repo.tracing_tool_version,
        lean_toolchain=source_repo.lean_toolchain,
        generation_config=generation_config,
        config_fingerprints=config_fingerprints,
        artifact_hashes=artifact_hashes,
        benchmark_manifest_hash=manifest_hash,
    )


def write_manifest(manifest: BenchmarkManifest, output_path: Path) -> None:
    write_json(output_path, manifest.to_dict())
