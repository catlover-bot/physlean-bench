"""Preflight checks for tracing and build workflows."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
import importlib.util
import platform
import shutil

from physlean_bench.source.build_physlib import resolve_lake_binary, resolve_lean_binary_from_lake
from physlean_bench.utils.io import write_json
from physlean_bench.utils.subprocess import run_command


@dataclass
class PreflightCheck:
    name: str
    ok: bool
    severity: str
    message: str
    details: dict[str, object]

    def to_dict(self) -> dict[str, object]:
        return asdict(self)


@dataclass
class PreflightReport:
    repo_dir: Path
    output_dir: Path
    backend: str
    min_free_disk_gb: float
    generated_at_utc: str
    checks: list[PreflightCheck]

    @property
    def can_proceed(self) -> bool:
        return all(check.ok or check.severity != "error" for check in self.checks)

    def to_dict(self) -> dict[str, object]:
        return {
            "repo_dir": str(self.repo_dir),
            "output_dir": str(self.output_dir),
            "backend": self.backend,
            "min_free_disk_gb": self.min_free_disk_gb,
            "generated_at_utc": self.generated_at_utc,
            "can_proceed": self.can_proceed,
            "checks": [item.to_dict() for item in self.checks],
        }


def _is_git_repo(path: Path) -> bool:
    result = run_command(["git", "rev-parse", "--is-inside-work-tree"], cwd=path)
    return result.ok and result.stdout.strip() == "true"


def _gb(bytes_value: int) -> float:
    return bytes_value / (1024.0**3)


def run_trace_preflight(
    *,
    repo_dir: Path,
    output_dir: Path,
    backend: str,
    min_free_disk_gb: float,
    lake_binary: Path | None = None,
) -> PreflightReport:
    repo_dir = repo_dir.resolve()
    output_dir = output_dir.resolve()
    output_dir.mkdir(parents=True, exist_ok=True)

    checks: list[PreflightCheck] = []

    repo_exists = repo_dir.exists()
    checks.append(
        PreflightCheck(
            name="repo_exists",
            ok=repo_exists,
            severity="error",
            message="Repository directory exists." if repo_exists else "Repository directory does not exist.",
            details={"repo_dir": str(repo_dir)},
        )
    )

    git_repo = repo_exists and _is_git_repo(repo_dir)
    checks.append(
        PreflightCheck(
            name="repo_is_git",
            ok=git_repo,
            severity="error",
            message="Repository is a git checkout." if git_repo else "Repository is not a git checkout.",
            details={"repo_dir": str(repo_dir)},
        )
    )

    python_ok = tuple(int(item) for item in platform.python_version_tuple()[:2]) >= (3, 10)
    checks.append(
        PreflightCheck(
            name="python_version",
            ok=python_ok,
            severity="error",
            message=f"Python version is {platform.python_version()}.",
            details={"required": ">=3.10", "actual": platform.python_version()},
        )
    )

    git_path = shutil.which("git")
    checks.append(
        PreflightCheck(
            name="executable_git",
            ok=git_path is not None,
            severity="error",
            message="`git` executable found." if git_path else "`git` executable not found.",
            details={"path": git_path},
        )
    )

    resolved_lake: Path | None = None
    lake_message = ""
    try:
        resolved_lake = resolve_lake_binary(repo_dir, explicit_lake_binary=lake_binary)
        lake_ok = True
        lake_message = "Resolved `lake` executable."
    except Exception as exc:  # pragma: no cover - defensive path
        lake_ok = False
        lake_message = f"Failed to resolve `lake`: {exc}"

    checks.append(
        PreflightCheck(
            name="executable_lake",
            ok=lake_ok,
            severity="error",
            message=lake_message,
            details={"path": str(resolved_lake) if resolved_lake else None},
        )
    )

    lean_binary = resolve_lean_binary_from_lake(resolved_lake) if resolved_lake else None
    checks.append(
        PreflightCheck(
            name="executable_lean",
            ok=lean_binary is not None,
            severity="warning",
            message="Resolved sibling `lean` executable from lake." if lean_binary else "Could not resolve sibling `lean` executable from lake path.",
            details={"path": str(lean_binary) if lean_binary else None},
        )
    )

    toolchain_file = repo_dir / "lean-toolchain"
    toolchain_exists = toolchain_file.exists()
    checks.append(
        PreflightCheck(
            name="lean_toolchain_file",
            ok=toolchain_exists,
            severity="warning",
            message="lean-toolchain file found." if toolchain_exists else "lean-toolchain file not found.",
            details={"path": str(toolchain_file)},
        )
    )

    if backend == "leandojo_v2":
        has_lean_dojo = importlib.util.find_spec("lean_dojo") is not None
        checks.append(
            PreflightCheck(
                name="python_package_lean_dojo",
                ok=has_lean_dojo,
                severity="error",
                message="Python package `lean_dojo` is installed."
                if has_lean_dojo
                else "Python package `lean_dojo` is not installed.",
                details={"package": "lean_dojo"},
            )
        )

    disk_usage = shutil.disk_usage(output_dir)
    free_gb = _gb(disk_usage.free)
    disk_ok = free_gb >= min_free_disk_gb
    checks.append(
        PreflightCheck(
            name="free_disk_space",
            ok=disk_ok,
            severity="error",
            message=(
                f"Sufficient free disk space detected ({free_gb:.2f} GiB)."
                if disk_ok
                else f"Insufficient free disk space ({free_gb:.2f} GiB), requires >= {min_free_disk_gb:.2f} GiB."
            ),
            details={
                "free_bytes": disk_usage.free,
                "free_gb": round(free_gb, 3),
                "required_gb": min_free_disk_gb,
                "output_dir": str(output_dir),
            },
        )
    )

    probe_file = output_dir / ".preflight_write_probe"
    try:
        probe_file.write_text("ok", encoding="utf-8")
        probe_file.unlink(missing_ok=True)
        writable = True
    except Exception as exc:  # pragma: no cover - platform dependent
        writable = False
        write_error = str(exc)
    else:
        write_error = ""

    checks.append(
        PreflightCheck(
            name="output_dir_writable",
            ok=writable,
            severity="error",
            message="Output directory is writable." if writable else "Output directory is not writable.",
            details={"output_dir": str(output_dir), "error": write_error},
        )
    )

    return PreflightReport(
        repo_dir=repo_dir,
        output_dir=output_dir,
        backend=backend,
        min_free_disk_gb=min_free_disk_gb,
        generated_at_utc=datetime.now(timezone.utc).isoformat(),
        checks=checks,
    )


def write_preflight_artifacts(report: PreflightReport, *, output_json: Path, output_markdown: Path) -> None:
    write_json(output_json, report.to_dict())

    lines = [
        "# Trace Preflight",
        "",
        f"- generated_at_utc: `{report.generated_at_utc}`",
        f"- repo_dir: `{report.repo_dir}`",
        f"- output_dir: `{report.output_dir}`",
        f"- backend: `{report.backend}`",
        f"- min_free_disk_gb: `{report.min_free_disk_gb}`",
        f"- can_proceed: `{report.can_proceed}`",
        "",
        "## Checks",
        "",
    ]

    for check in report.checks:
        status = "PASS" if check.ok else "FAIL"
        lines.append(f"- [{status}] `{check.name}` ({check.severity}): {check.message}")

    output_markdown.parent.mkdir(parents=True, exist_ok=True)
    output_markdown.write_text("\n".join(lines) + "\n", encoding="utf-8")
