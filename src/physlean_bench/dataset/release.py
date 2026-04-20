"""Release-candidate packaging for traced benchmark artifacts."""

from __future__ import annotations

from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
import shutil
from typing import Any

from physlean_bench.utils.hashing import sha256_file, sha256_json
from physlean_bench.utils.io import read_json, write_json


@dataclass
class ReleasePackageResult:
    release_dir: Path
    manifest_path: Path
    summary_md_path: Path
    copied_files: dict[str, str]


def _copy_optional(src: Path | None, dst: Path) -> bool:
    if src is None or not src.exists():
        return False
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    return True


def package_release_candidate(
    *,
    release_root: Path,
    release_name: str,
    trace_files: dict[str, Path | None],
    inventory_files: dict[str, Path | None],
    completion_files: dict[str, Path | None],
    split_files: dict[str, Path | None],
    report_files: dict[str, Path | None],
    config_paths: list[Path],
) -> ReleasePackageResult:
    release_dir = (release_root / release_name).resolve()
    release_dir.mkdir(parents=True, exist_ok=True)

    copied_files: dict[str, str] = {}

    section_dirs = {
        "trace": release_dir / "trace",
        "inventory": release_dir / "inventory",
        "completion": release_dir / "completion",
        "splits": release_dir / "splits",
        "reports": release_dir / "reports",
        "configs": release_dir / "configs",
    }
    for path in section_dirs.values():
        path.mkdir(parents=True, exist_ok=True)

    for name, path in trace_files.items():
        if path is None:
            continue
        dst = section_dirs["trace"] / path.name
        if _copy_optional(path, dst):
            copied_files[f"trace/{name}"] = str(dst)

    for name, path in inventory_files.items():
        if path is None:
            continue
        dst = section_dirs["inventory"] / path.name
        if _copy_optional(path, dst):
            copied_files[f"inventory/{name}"] = str(dst)

    for name, path in completion_files.items():
        if path is None:
            continue
        dst = section_dirs["completion"] / path.name
        if _copy_optional(path, dst):
            copied_files[f"completion/{name}"] = str(dst)

    for name, path in split_files.items():
        if path is None:
            continue
        dst = section_dirs["splits"] / path.name
        if _copy_optional(path, dst):
            copied_files[f"splits/{name}"] = str(dst)

    for name, path in report_files.items():
        if path is None:
            continue
        dst = section_dirs["reports"] / path.name
        if _copy_optional(path, dst):
            copied_files[f"reports/{name}"] = str(dst)

    for path in config_paths:
        if not path.exists():
            continue
        dst = section_dirs["configs"] / path.name
        shutil.copy2(path, dst)
        copied_files[f"configs/{path.name}"] = str(dst)

    artifact_hashes = {
        key: sha256_file(Path(path)) for key, path in copied_files.items() if Path(path).is_file()
    }

    source_url = "UNKNOWN"
    source_commit = "UNKNOWN"
    trace_backend = "UNKNOWN"
    tracing_tool = "UNKNOWN"
    tracing_tool_version = "UNKNOWN"
    lean_toolchain = None

    trace_metadata_file = trace_files.get("metadata_json")
    if trace_metadata_file and trace_metadata_file.exists():
        trace_meta = read_json(trace_metadata_file)
        source_url = str(trace_meta.get("source_url", source_url))
        source_commit = str(trace_meta.get("source_commit", source_commit))
        trace_backend = str(trace_meta.get("trace_backend", trace_backend))
        tracing_tool = str(trace_meta.get("tracing_tool", tracing_tool))
        tracing_tool_version = str(trace_meta.get("tracing_tool_version", tracing_tool_version))
        lean_toolchain_raw = trace_meta.get("lean_toolchain")
        lean_toolchain = str(lean_toolchain_raw) if lean_toolchain_raw else None

    manifest_payload: dict[str, Any] = {
        "release_name": release_name,
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "authoritative_path": "leandojo_v2",
        "source_repo": {
            "url": source_url,
            "commit": source_commit,
        },
        "trace": {
            "backend": trace_backend,
            "tracing_tool": tracing_tool,
            "tracing_tool_version": tracing_tool_version,
            "lean_toolchain": lean_toolchain,
        },
        "copied_files": copied_files,
        "artifact_hashes": artifact_hashes,
        "config_snapshot_files": [key for key in copied_files if key.startswith("configs/")],
    }
    manifest_payload["release_manifest_hash"] = sha256_json(manifest_payload)

    manifest_path = release_dir / "release_manifest.json"
    write_json(manifest_path, manifest_payload)

    summary_lines = [
        "# Release Candidate Summary",
        "",
        f"- release_name: `{release_name}`",
        f"- generated_at_utc: `{manifest_payload['generated_at_utc']}`",
        f"- source_url: `{source_url}`",
        f"- source_commit: `{source_commit}`",
        f"- trace_backend: `{trace_backend}`",
        f"- tracing_tool: `{tracing_tool}`",
        f"- tracing_tool_version: `{tracing_tool_version}`",
        f"- num_artifacts: `{len(artifact_hashes)}`",
        "",
        "## Artifacts",
        "",
    ]
    for key, path in sorted(copied_files.items()):
        summary_lines.append(f"- `{key}` -> `{path}`")

    summary_md_path = release_dir / "release_summary.md"
    summary_md_path.write_text("\n".join(summary_lines) + "\n", encoding="utf-8")

    return ReleasePackageResult(
        release_dir=release_dir,
        manifest_path=manifest_path,
        summary_md_path=summary_md_path,
        copied_files=copied_files,
    )
