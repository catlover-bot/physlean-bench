"""Trace Lean repositories and emit theorem-level JSONL artifacts."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from time import perf_counter
from typing import Any
import logging

from physlean_bench.schemas import TracedTheoremInfo, write_jsonl
from physlean_bench.source.build_physlib import resolve_lake_binary
from physlean_bench.tracing.leandojo_adapter import extract_traced_theorems, trace_with_leandojo_v2
from physlean_bench.tracing.preflight import run_trace_preflight, write_preflight_artifacts
from physlean_bench.tracing.source_scan import SourceScanConfig, scan_repo_theorems
from physlean_bench.utils.io import read_json, write_json
from physlean_bench.utils.subprocess import run_command

logger = logging.getLogger(__name__)


@dataclass
class TraceConfig:
    repo_dir: Path
    output_dir: Path
    traced_jsonl_path: Path
    backend: str = "leandojo_v2"
    tracing_tool: str = "leandojo-v2"
    tracing_tool_version: str = "auto"
    build_deps: bool = False
    include_prefixes: list[str] | None = None
    exclude_prefixes: list[str] | None = None
    cache_dir: Path | None = None
    tmp_dir: Path | None = None
    lake_binary: Path | None = None
    source_url: str | None = None
    expected_source_commit: str | None = None
    skip_preflight: bool = False
    min_free_disk_gb: float = 20.0
    fail_on_preflight_error: bool = True
    resume_if_outputs_exist: bool = True


@dataclass
class TraceRunResult:
    traced_jsonl_path: Path
    metadata_path: Path
    stats_path: Path
    summary_md_path: Path
    preflight_json_path: Path | None
    preflight_md_path: Path | None
    theorem_count: int
    resumed: bool


def _read_toolchain(repo_dir: Path) -> str | None:
    toolchain = repo_dir / "lean-toolchain"
    if not toolchain.exists():
        return None
    content = toolchain.read_text(encoding="utf-8").strip()
    return content if content else None


def _head_commit(repo_dir: Path) -> str:
    result = run_command(["git", "rev-parse", "HEAD"], cwd=repo_dir, check=True)
    return result.stdout.strip()


def _origin_url(repo_dir: Path) -> str | None:
    result = run_command(["git", "config", "--get", "remote.origin.url"], cwd=repo_dir)
    if result.ok and result.stdout.strip():
        return result.stdout.strip()
    return None


def _write_stage_marker(stages_dir: Path, stage: str, status: str, payload: dict[str, Any]) -> Path:
    stages_dir.mkdir(parents=True, exist_ok=True)
    marker = {
        "stage": stage,
        "status": status,
        "timestamp_utc": datetime.now(timezone.utc).isoformat(),
        "payload": payload,
    }
    path = stages_dir / f"{stage}.json"
    write_json(path, marker)
    return path


def _write_trace_summary_markdown(path: Path, payload: dict[str, object]) -> None:
    lines = [
        "# Trace Summary",
        "",
        f"- repo_dir: `{payload['repo_dir']}`",
        f"- source_url: `{payload.get('source_url', 'unknown')}`",
        f"- source_commit: `{payload['source_commit']}`",
        f"- trace_backend: `{payload.get('trace_backend', 'unknown')}`",
        f"- tracing_tool: `{payload['tracing_tool']}`",
        f"- tracing_tool_version: `{payload['tracing_tool_version']}`",
        f"- theorem_count: `{payload['theorem_count']}`",
        f"- include_prefixes: `{payload['include_prefixes']}`",
        f"- exclude_prefixes: `{payload['exclude_prefixes']}`",
        f"- traced_jsonl_path: `{payload['traced_jsonl_path']}`",
        f"- resumed: `{payload.get('resumed', False)}`",
    ]
    preflight_json = payload.get("preflight_json_path")
    if preflight_json:
        lines.append(f"- preflight_json_path: `{preflight_json}`")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _apply_provenance(
    records: list[TracedTheoremInfo],
    *,
    source_url: str,
    source_commit: str,
    backend: str,
) -> None:
    for item in records:
        item.source_url = source_url
        item.source_commit = source_commit
        if item.trace_backend is None:
            item.trace_backend = backend


def trace_source_repo(config: TraceConfig) -> TraceRunResult:
    """Run tracing and write theorem records/metadata.

    Default path uses LeanDojo-v2. A `source_scan` backend is available for constrained
    environments where full LeanDojo tracing cannot run due missing dependencies/resources.
    """
    repo_dir = config.repo_dir.resolve()
    output_dir = config.output_dir.resolve()
    traced_jsonl = config.traced_jsonl_path.resolve()

    output_dir.mkdir(parents=True, exist_ok=True)
    traced_jsonl.parent.mkdir(parents=True, exist_ok=True)

    metadata_path = output_dir / "trace_run_metadata.json"
    stats_path = output_dir / "trace_stats.json"
    summary_md_path = output_dir / "trace_summary.md"
    stages_dir = output_dir / "stages"

    preflight_json_path: Path | None = output_dir / "trace_preflight.json"
    preflight_md_path: Path | None = output_dir / "trace_preflight.md"

    _write_stage_marker(stages_dir, "trace_pipeline", "started", {"backend": config.backend})

    if not config.skip_preflight:
        _write_stage_marker(stages_dir, "preflight", "started", {})
        preflight_report = run_trace_preflight(
            repo_dir=repo_dir,
            output_dir=output_dir,
            backend=config.backend,
            min_free_disk_gb=config.min_free_disk_gb,
            lake_binary=config.lake_binary,
        )
        assert preflight_json_path is not None and preflight_md_path is not None
        write_preflight_artifacts(
            preflight_report,
            output_json=preflight_json_path,
            output_markdown=preflight_md_path,
        )
        _write_stage_marker(
            stages_dir,
            "preflight",
            "completed" if preflight_report.can_proceed else "failed",
            {"can_proceed": preflight_report.can_proceed, "report_path": str(preflight_json_path)},
        )
        if not preflight_report.can_proceed and config.fail_on_preflight_error:
            _write_stage_marker(
                stages_dir,
                "trace_pipeline",
                "failed",
                {"reason": "preflight_failed", "report_path": str(preflight_json_path)},
            )
            raise RuntimeError(
                "Trace preflight failed. See preflight report for actionable diagnostics:\n"
                f"- JSON: {preflight_json_path}\n"
                f"- Markdown: {preflight_md_path}"
            )
    else:
        preflight_json_path = None
        preflight_md_path = None

    if config.resume_if_outputs_exist and traced_jsonl.exists() and metadata_path.exists() and stats_path.exists():
        metadata = read_json(metadata_path)
        theorem_count = int(metadata.get("theorem_count", 0))
        _write_stage_marker(stages_dir, "trace_pipeline", "resumed", {"theorem_count": theorem_count})
        return TraceRunResult(
            traced_jsonl_path=traced_jsonl,
            metadata_path=metadata_path,
            stats_path=stats_path,
            summary_md_path=summary_md_path,
            preflight_json_path=preflight_json_path,
            preflight_md_path=preflight_md_path,
            theorem_count=theorem_count,
            resumed=True,
        )

    include_prefixes = config.include_prefixes or ["Physlib/", "PhysLean/"]
    exclude_prefixes = config.exclude_prefixes or ["QuantumInfo/"]
    cache_dir = (config.cache_dir or (output_dir / "cache" / "lean_dojo")).resolve()
    tmp_dir = (config.tmp_dir or (output_dir / "tmp")).resolve()

    backend = config.backend.lower()
    metadata_backend = backend
    records: list[TracedTheoremInfo]
    tracing_tool = config.tracing_tool
    tracing_tool_version = config.tracing_tool_version
    traced_repo_root = ""
    resolved_lake: Path | None = None

    source_commit = _head_commit(repo_dir)
    source_url = config.source_url or _origin_url(repo_dir) or "UNKNOWN"

    if config.expected_source_commit and config.expected_source_commit != source_commit:
        logger.warning(
            "Expected commit %s but repository HEAD is %s",
            config.expected_source_commit,
            source_commit,
        )

    _write_stage_marker(stages_dir, "trace_backend", "started", {"backend": backend})
    start = perf_counter()
    try:
        if backend == "leandojo_v2":
            resolved_lake = resolve_lake_binary(repo_dir, explicit_lake_binary=config.lake_binary)
            traced_repo, detected_version = trace_with_leandojo_v2(
                repo_dir,
                cache_dir=cache_dir,
                tmp_dir=tmp_dir,
                build_deps=config.build_deps,
                lake_binary=resolved_lake,
            )
            _write_stage_marker(stages_dir, "extract_traced_theorems", "started", {})
            records = extract_traced_theorems(
                traced_repo,
                include_prefixes=include_prefixes,
                exclude_prefixes=exclude_prefixes,
            )
            _write_stage_marker(stages_dir, "extract_traced_theorems", "completed", {"count": len(records)})
            tracing_tool_version = (
                detected_version if config.tracing_tool_version == "auto" else config.tracing_tool_version
            )
            traced_repo_root = str(getattr(traced_repo, "root_dir", ""))
        elif backend == "source_scan":
            records = scan_repo_theorems(
                SourceScanConfig(
                    repo_dir=repo_dir,
                    include_prefixes=include_prefixes,
                    exclude_prefixes=exclude_prefixes,
                )
            )
            metadata_backend = "source_scan_fallback"
            tracing_tool = "source_scan_fallback"
            tracing_tool_version = "source_scan_v1"
        else:
            raise ValueError(f"Unsupported trace backend: {config.backend}")
    except Exception as exc:
        _write_stage_marker(
            stages_dir,
            "trace_backend",
            "failed",
            {"backend": backend, "error": str(exc)},
        )
        _write_stage_marker(stages_dir, "trace_pipeline", "failed", {"reason": "trace_backend_failed"})
        raise

    trace_duration_seconds = perf_counter() - start
    _write_stage_marker(
        stages_dir,
        "trace_backend",
        "completed",
        {"backend": backend, "count": len(records), "duration_seconds": trace_duration_seconds},
    )

    _apply_provenance(records, source_url=source_url, source_commit=source_commit, backend=metadata_backend)

    _write_stage_marker(stages_dir, "write_outputs", "started", {})
    write_jsonl(traced_jsonl, records)

    metadata = {
        "repo_dir": str(repo_dir),
        "source_url": source_url,
        "source_commit": source_commit,
        "expected_source_commit": config.expected_source_commit,
        "lean_toolchain": _read_toolchain(repo_dir),
        "trace_backend": metadata_backend,
        "tracing_tool": tracing_tool,
        "tracing_tool_version": tracing_tool_version,
        "build_deps": config.build_deps,
        "include_prefixes": include_prefixes,
        "exclude_prefixes": exclude_prefixes,
        "cache_dir": str(cache_dir),
        "tmp_dir": str(tmp_dir),
        "traced_repo_root": traced_repo_root,
        "lake_binary": str(resolved_lake) if resolved_lake else None,
        "traced_jsonl_path": str(traced_jsonl),
        "theorem_count": len(records),
        "trace_duration_seconds": trace_duration_seconds,
        "generated_at_utc": datetime.now(timezone.utc).isoformat(),
        "preflight_json_path": str(preflight_json_path) if preflight_json_path else None,
    }

    backend_counter: dict[str, int] = {}
    for record in records:
        key = record.trace_backend or "unknown"
        backend_counter[key] = backend_counter.get(key, 0) + 1

    stats = {
        "theorem_count": len(records),
        "unique_namespaces": len({record.namespace for record in records}),
        "unique_files": len({record.file_path for record in records}),
        "num_with_proof_text": sum(1 for record in records if record.proof_text),
        "num_with_used_premises": sum(1 for record in records if record.used_premises),
        "num_with_accessible_premises": sum(1 for record in records if record.accessible_premises),
        "backend_counts": backend_counter,
    }

    write_json(metadata_path, metadata)
    write_json(stats_path, stats)
    _write_trace_summary_markdown(summary_md_path, {**metadata, "resumed": False})
    _write_stage_marker(stages_dir, "write_outputs", "completed", {"count": len(records)})
    _write_stage_marker(stages_dir, "trace_pipeline", "completed", {"theorem_count": len(records)})

    logger.info(
        "Trace completed: %d theorem candidates written to %s",
        len(records),
        traced_jsonl,
    )
    return TraceRunResult(
        traced_jsonl_path=traced_jsonl,
        metadata_path=metadata_path,
        stats_path=stats_path,
        summary_md_path=summary_md_path,
        preflight_json_path=preflight_json_path,
        preflight_md_path=preflight_md_path,
        theorem_count=len(records),
        resumed=False,
    )


def trace_config_to_dict(config: TraceConfig) -> dict[str, object]:
    payload = asdict(config)
    payload["repo_dir"] = str(config.repo_dir)
    payload["output_dir"] = str(config.output_dir)
    payload["traced_jsonl_path"] = str(config.traced_jsonl_path)
    payload["cache_dir"] = str(config.cache_dir) if config.cache_dir else None
    payload["tmp_dir"] = str(config.tmp_dir) if config.tmp_dir else None
    payload["lake_binary"] = str(config.lake_binary) if config.lake_binary else None
    return payload
