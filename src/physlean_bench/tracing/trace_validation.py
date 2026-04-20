"""Validation checks for traced outputs and provenance completeness."""

from __future__ import annotations

from collections import Counter
from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

from physlean_bench.schemas import TracedTheoremInfo, read_jsonl
from physlean_bench.utils.io import read_json, write_json


@dataclass
class TraceValidationIssue:
    severity: str
    code: str
    message: str
    details: dict[str, Any]

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)


@dataclass
class TraceValidationReport:
    traced_jsonl_path: Path
    metadata_path: Path | None
    generated_at_utc: str
    required_backend: str
    expected_source_url: str | None
    expected_source_commit: str | None
    min_records: int
    issues: list[TraceValidationIssue]
    stats: dict[str, Any]

    @property
    def ok(self) -> bool:
        return not any(item.severity == "error" for item in self.issues)

    def to_dict(self) -> dict[str, Any]:
        return {
            "traced_jsonl_path": str(self.traced_jsonl_path),
            "metadata_path": str(self.metadata_path) if self.metadata_path else None,
            "generated_at_utc": self.generated_at_utc,
            "required_backend": self.required_backend,
            "expected_source_url": self.expected_source_url,
            "expected_source_commit": self.expected_source_commit,
            "min_records": self.min_records,
            "ok": self.ok,
            "issues": [item.to_dict() for item in self.issues],
            "stats": self.stats,
        }


def _normalize_git_url(url: str | None) -> str | None:
    if url is None:
        return None
    normalized = url.strip().rstrip("/")
    if normalized.endswith(".git"):
        normalized = normalized[:-4]
    if normalized.startswith("git@github.com:"):
        normalized = normalized.replace("git@github.com:", "https://github.com/")
    return normalized


def _collect_stats(records: list[TracedTheoremInfo]) -> dict[str, Any]:
    namespace_counter = Counter(item.namespace for item in records)
    file_counter = Counter(item.file_path for item in records)
    backend_counter = Counter(item.trace_backend or "unknown" for item in records)
    return {
        "num_records": len(records),
        "num_unique_namespaces": len(namespace_counter),
        "num_unique_files": len(file_counter),
        "top_namespaces": namespace_counter.most_common(20),
        "top_files": file_counter.most_common(20),
        "trace_backend_counts": dict(backend_counter),
        "num_with_proof_text": sum(1 for item in records if item.proof_text),
        "num_with_used_premises": sum(1 for item in records if item.used_premises),
        "num_with_accessible_premises": sum(1 for item in records if item.accessible_premises),
    }


def validate_trace_artifacts(
    *,
    traced_jsonl_path: Path,
    metadata_path: Path | None,
    required_backend: str,
    expected_source_url: str | None,
    expected_source_commit: str | None,
    include_prefixes: list[str],
    exclude_prefixes: list[str],
    min_records: int = 1,
) -> TraceValidationReport:
    issues: list[TraceValidationIssue] = []

    if not traced_jsonl_path.exists():
        issues.append(
            TraceValidationIssue(
                severity="error",
                code="missing_traced_jsonl",
                message="Traced theorem JSONL file is missing.",
                details={"path": str(traced_jsonl_path)},
            )
        )
        return TraceValidationReport(
            traced_jsonl_path=traced_jsonl_path,
            metadata_path=metadata_path,
            generated_at_utc=datetime.now(timezone.utc).isoformat(),
            required_backend=required_backend,
            expected_source_url=expected_source_url,
            expected_source_commit=expected_source_commit,
            min_records=min_records,
            issues=issues,
            stats={"num_records": 0},
        )

    records = read_jsonl(traced_jsonl_path, TracedTheoremInfo)  # type: ignore[assignment]
    stats = _collect_stats(records)

    if len(records) < min_records:
        issues.append(
            TraceValidationIssue(
                severity="error",
                code="too_few_records",
                message=f"Traced record count {len(records)} is below required minimum {min_records}.",
                details={"num_records": len(records), "min_records": min_records},
            )
        )

    if len(records) == 0:
        issues.append(
            TraceValidationIssue(
                severity="error",
                code="empty_trace",
                message="Traced output is empty.",
                details={},
            )
        )

    if metadata_path is not None:
        if not metadata_path.exists():
            issues.append(
                TraceValidationIssue(
                    severity="error",
                    code="missing_metadata",
                    message="Trace metadata file is missing.",
                    details={"path": str(metadata_path)},
                )
            )
            metadata: dict[str, Any] = {}
        else:
            metadata = read_json(metadata_path)
    else:
        metadata = {}
        issues.append(
            TraceValidationIssue(
                severity="warning",
                code="metadata_path_not_provided",
                message="Trace metadata path was not provided.",
                details={},
            )
        )

    if metadata:
        missing_keys = [
            key
            for key in [
                "source_url",
                "source_commit",
                "trace_backend",
                "tracing_tool",
                "tracing_tool_version",
                "generated_at_utc",
            ]
            if key not in metadata
        ]
        if missing_keys:
            issues.append(
                TraceValidationIssue(
                    severity="error",
                    code="incomplete_metadata",
                    message="Trace metadata missing required keys.",
                    details={"missing_keys": missing_keys},
                )
            )

        meta_backend = str(metadata.get("trace_backend", ""))
        if meta_backend != required_backend:
            issues.append(
                TraceValidationIssue(
                    severity="error",
                    code="backend_mismatch_metadata",
                    message="Trace metadata backend does not match required backend.",
                    details={"metadata_backend": meta_backend, "required_backend": required_backend},
                )
            )

        if expected_source_url is not None:
            expected_norm = _normalize_git_url(expected_source_url)
            actual_norm = _normalize_git_url(str(metadata.get("source_url", "")))
            if expected_norm != actual_norm:
                issues.append(
                    TraceValidationIssue(
                        severity="error",
                        code="source_url_mismatch",
                        message="Source URL in metadata does not match expected URL.",
                        details={"expected": expected_norm, "actual": actual_norm},
                    )
                )

        if expected_source_commit is not None:
            actual_commit = str(metadata.get("source_commit", ""))
            if expected_source_commit != actual_commit:
                issues.append(
                    TraceValidationIssue(
                        severity="error",
                        code="source_commit_mismatch",
                        message="Source commit in metadata does not match expected commit.",
                        details={"expected": expected_source_commit, "actual": actual_commit},
                    )
                )

    record_backend_counts = Counter(item.trace_backend or "unknown" for item in records)
    non_required = sum(
        count for backend, count in record_backend_counts.items() if backend != required_backend
    )
    if non_required:
        issues.append(
            TraceValidationIssue(
                severity="error",
                code="backend_mismatch_records",
                message="Some traced records use a backend different from required backend.",
                details={"backend_counts": dict(record_backend_counts), "required_backend": required_backend},
            )
        )

    invalid_include = [
        item.file_path
        for item in records
        if include_prefixes and not any(item.file_path.startswith(prefix) for prefix in include_prefixes)
    ]
    if invalid_include:
        issues.append(
            TraceValidationIssue(
                severity="warning",
                code="outside_include_prefix",
                message="Some traced files are outside expected include prefixes.",
                details={"num_outside": len(invalid_include), "sample": invalid_include[:10]},
            )
        )

    invalid_exclude = [
        item.file_path for item in records if any(item.file_path.startswith(prefix) for prefix in exclude_prefixes)
    ]
    if invalid_exclude:
        issues.append(
            TraceValidationIssue(
                severity="error",
                code="matched_exclude_prefix",
                message="Traced output contains files from excluded prefixes.",
                details={"num_violations": len(invalid_exclude), "sample": invalid_exclude[:10]},
            )
        )

    return TraceValidationReport(
        traced_jsonl_path=traced_jsonl_path,
        metadata_path=metadata_path,
        generated_at_utc=datetime.now(timezone.utc).isoformat(),
        required_backend=required_backend,
        expected_source_url=expected_source_url,
        expected_source_commit=expected_source_commit,
        min_records=min_records,
        issues=issues,
        stats=stats,
    )


def write_trace_validation_artifacts(
    report: TraceValidationReport,
    *,
    output_json: Path,
    output_markdown: Path,
) -> None:
    write_json(output_json, report.to_dict())

    lines = [
        "# Trace Validation",
        "",
        f"- traced_jsonl_path: `{report.traced_jsonl_path}`",
        f"- metadata_path: `{report.metadata_path}`",
        f"- required_backend: `{report.required_backend}`",
        f"- expected_source_url: `{report.expected_source_url}`",
        f"- expected_source_commit: `{report.expected_source_commit}`",
        f"- min_records: `{report.min_records}`",
        f"- ok: `{report.ok}`",
        "",
        "## Stats",
        "",
        f"- num_records: `{report.stats.get('num_records', 0)}`",
        f"- num_unique_files: `{report.stats.get('num_unique_files', 0)}`",
        f"- num_unique_namespaces: `{report.stats.get('num_unique_namespaces', 0)}`",
        "",
        "## Issues",
        "",
    ]

    if report.issues:
        for issue in report.issues:
            lines.append(f"- [{issue.severity.upper()}] `{issue.code}`: {issue.message}")
    else:
        lines.append("- No issues detected.")

    output_markdown.parent.mkdir(parents=True, exist_ok=True)
    output_markdown.write_text("\n".join(lines) + "\n", encoding="utf-8")
