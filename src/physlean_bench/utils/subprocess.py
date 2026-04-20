"""Safe subprocess wrapper with structured result."""

from __future__ import annotations

from dataclasses import dataclass
import os
from pathlib import Path
import time
from typing import Mapping, Sequence
import subprocess


@dataclass
class CommandResult:
    command: list[str]
    returncode: int
    stdout: str
    stderr: str
    duration_seconds: float | None = None

    @property
    def ok(self) -> bool:
        return self.returncode == 0


def run_command(
    command: Sequence[str],
    cwd: Path | None = None,
    timeout_seconds: int | None = None,
    check: bool = False,
    env: Mapping[str, str] | None = None,
) -> CommandResult:
    """Run command and capture stdout/stderr.

    Parameters are strict list-based to avoid shell escaping issues.
    """
    merged_env = dict(os.environ)
    if env is not None:
        merged_env.update(env)
    start = time.perf_counter()
    completed = subprocess.run(
        list(command),
        cwd=str(cwd) if cwd else None,
        text=True,
        capture_output=True,
        timeout=timeout_seconds,
        check=False,
        env=merged_env,
    )
    duration_seconds = time.perf_counter() - start
    result = CommandResult(
        command=list(command),
        returncode=completed.returncode,
        stdout=completed.stdout,
        stderr=completed.stderr,
        duration_seconds=duration_seconds,
    )
    if check and not result.ok:
        cmd_text = " ".join(result.command)
        raise RuntimeError(
            f"Command failed: {cmd_text}\n"
            f"Exit code: {result.returncode}\n"
            f"STDOUT:\n{result.stdout}\n"
            f"STDERR:\n{result.stderr}"
        )
    return result
