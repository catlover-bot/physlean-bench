"""Build orchestration for physlib source repositories."""

from __future__ import annotations

from dataclasses import asdict, dataclass
from datetime import datetime, timezone
from pathlib import Path
import logging
import os
import shutil
from typing import Sequence

from physlean_bench.utils.io import write_json
from physlean_bench.utils.subprocess import CommandResult, run_command

logger = logging.getLogger(__name__)


@dataclass
class BuildStepResult:
    name: str
    command: list[str]
    returncode: int
    duration_seconds: float
    stdout_log: Path
    stderr_log: Path


@dataclass
class BuildRunResult:
    repo_dir: Path
    artifacts_dir: Path
    toolchain: str | None
    lake_binary: Path
    lean_binary: Path | None
    target: str
    used_cache_get: bool
    success: bool
    duration_seconds: float
    steps: list[BuildStepResult]

    def to_dict(self) -> dict[str, object]:
        payload = asdict(self)
        payload["repo_dir"] = str(self.repo_dir)
        payload["artifacts_dir"] = str(self.artifacts_dir)
        payload["lake_binary"] = str(self.lake_binary)
        payload["lean_binary"] = str(self.lean_binary) if self.lean_binary else None
        payload["steps"] = [
            {
                **asdict(step),
                "stdout_log": str(step.stdout_log),
                "stderr_log": str(step.stderr_log),
            }
            for step in self.steps
        ]
        return payload


def _read_toolchain(repo_dir: Path) -> str | None:
    toolchain_file = repo_dir / "lean-toolchain"
    if not toolchain_file.exists():
        return None
    return toolchain_file.read_text(encoding="utf-8").strip() or None


def _toolchain_to_elan_dirname(toolchain: str) -> str:
    # e.g. leanprover/lean4:v4.20.0 -> leanprover--lean4---v4.20.0
    return toolchain.replace("/", "--").replace(":", "---")


def resolve_lake_binary(repo_dir: Path, explicit_lake_binary: Path | None = None) -> Path:
    """Resolve lake binary path from explicit path, PATH, or local elan toolchain."""
    if explicit_lake_binary is not None:
        if not explicit_lake_binary.exists():
            raise FileNotFoundError(f"Specified lake binary does not exist: {explicit_lake_binary}")
        return explicit_lake_binary.resolve()

    from_path = shutil.which("lake")
    if from_path:
        return Path(from_path).resolve()

    toolchain = _read_toolchain(repo_dir)
    if toolchain:
        candidate = (
            Path.home()
            / ".elan"
            / "toolchains"
            / _toolchain_to_elan_dirname(toolchain)
            / "bin"
            / "lake"
        )
        if candidate.exists():
            return candidate.resolve()

    raise FileNotFoundError(
        "Unable to locate `lake` binary. Provide --lake-binary or ensure lake is available in PATH/elán toolchain."
    )


def resolve_lean_binary_from_lake(lake_binary: Path) -> Path | None:
    candidate = lake_binary.with_name("lean")
    return candidate.resolve() if candidate.exists() else None


def _run_step(
    step_name: str,
    command: Sequence[str],
    repo_dir: Path,
    artifacts_dir: Path,
    timeout_seconds: int | None,
    env: dict[str, str],
    dry_run: bool,
) -> BuildStepResult:
    stdout_log = artifacts_dir / f"{step_name}.stdout.log"
    stderr_log = artifacts_dir / f"{step_name}.stderr.log"

    if dry_run:
        stdout_log.write_text("dry_run=true: command not executed\n", encoding="utf-8")
        stderr_log.write_text("", encoding="utf-8")
        return BuildStepResult(
            name=step_name,
            command=list(command),
            returncode=0,
            duration_seconds=0.0,
            stdout_log=stdout_log,
            stderr_log=stderr_log,
        )

    result: CommandResult = run_command(
        list(command),
        cwd=repo_dir,
        timeout_seconds=timeout_seconds,
        env=env,
    )
    max_log_chars = 1_000_000
    stdout_payload = result.stdout
    stderr_payload = result.stderr
    if len(stdout_payload) > max_log_chars:
        stdout_payload = (
            stdout_payload[:max_log_chars]
            + f"\n\n[truncated stdout: kept first {max_log_chars} characters]"
        )
    if len(stderr_payload) > max_log_chars:
        stderr_payload = (
            stderr_payload[:max_log_chars]
            + f"\n\n[truncated stderr: kept first {max_log_chars} characters]"
        )
    stdout_log.write_text(stdout_payload, encoding="utf-8")
    stderr_log.write_text(stderr_payload, encoding="utf-8")

    return BuildStepResult(
        name=step_name,
        command=list(command),
        returncode=result.returncode,
        duration_seconds=result.duration_seconds or 0.0,
        stdout_log=stdout_log,
        stderr_log=stderr_log,
    )


def run_physlib_build(
    repo_dir: Path,
    *,
    artifacts_root: Path,
    target: str = "PhysLean",
    run_cache_get: bool = True,
    timeout_seconds: int | None = None,
    dry_run: bool = False,
    lake_binary: Path | None = None,
) -> BuildRunResult:
    """Run a reproducible Physlib-focused build and persist logs/artifacts."""
    repo_dir = repo_dir.resolve()
    if not repo_dir.exists():
        raise FileNotFoundError(f"Repository directory does not exist: {repo_dir}")

    resolved_lake = resolve_lake_binary(repo_dir, explicit_lake_binary=lake_binary)
    resolved_lean = resolve_lean_binary_from_lake(resolved_lake)
    toolchain = _read_toolchain(repo_dir)

    run_stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")
    artifacts_dir = (artifacts_root / f"build_{run_stamp}").resolve()
    artifacts_dir.mkdir(parents=True, exist_ok=True)

    env = dict(os.environ)
    env["PATH"] = f"{resolved_lake.parent}:{env.get('PATH', '')}"

    steps: list[BuildStepResult] = []
    if run_cache_get:
        steps.append(
            _run_step(
                "cache_get",
                [str(resolved_lake), "exe", "cache", "get"],
                repo_dir,
                artifacts_dir,
                timeout_seconds,
                env,
                dry_run,
            )
        )

    build_cmd = [str(resolved_lake), "build"]
    if target:
        build_cmd.append(target)
    steps.append(
        _run_step(
            "build_target",
            build_cmd,
            repo_dir,
            artifacts_dir,
            timeout_seconds,
            env,
            dry_run,
        )
    )

    success = all(step.returncode == 0 for step in steps)
    duration_seconds = sum(step.duration_seconds for step in steps)

    result = BuildRunResult(
        repo_dir=repo_dir,
        artifacts_dir=artifacts_dir,
        toolchain=toolchain,
        lake_binary=resolved_lake,
        lean_binary=resolved_lean,
        target=target,
        used_cache_get=run_cache_get,
        success=success,
        duration_seconds=duration_seconds,
        steps=steps,
    )

    write_json(artifacts_dir / "build_summary.json", result.to_dict())

    if not success:
        failed = [step for step in steps if step.returncode != 0]
        first = failed[0]
        raise RuntimeError(
            "Physlib build failed.\n"
            f"Repo: {repo_dir}\n"
            f"Artifacts: {artifacts_dir}\n"
            f"Failed step: {first.name}\n"
            f"Command: {' '.join(first.command)}\n"
            f"STDERR log: {first.stderr_log}\n"
            f"STDOUT log: {first.stdout_log}"
        )

    logger.info("Build succeeded. Artifacts stored at %s", artifacts_dir)
    return result


def build_physlib(
    repo_dir: Path,
    build_cmd: Sequence[str] | None = None,
    dry_run: bool = False,
) -> CommandResult:
    """Backwards-compatible single-command wrapper."""
    repo_dir = repo_dir.resolve()
    command = list(build_cmd or ["lake", "build", "PhysLean"])
    return run_command(command, cwd=repo_dir)
