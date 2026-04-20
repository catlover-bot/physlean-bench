"""Source repository preparation for physlib workflows."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import logging

from physlean_bench.utils.subprocess import CommandResult, run_command

logger = logging.getLogger(__name__)


@dataclass
class SourceRepoStatus:
    repo_dir: Path
    remote_url: str
    head_commit: str
    is_dirty: bool
    dirty_files: list[str]
    reused_existing_checkout: bool


def _is_git_repo(path: Path) -> bool:
    result = run_command(["git", "rev-parse", "--is-inside-work-tree"], cwd=path)
    return result.ok and result.stdout.strip() == "true"


def _get_origin_url(repo_dir: Path) -> str:
    result = run_command(["git", "config", "--get", "remote.origin.url"], cwd=repo_dir, check=True)
    return result.stdout.strip()


def _get_head_commit(repo_dir: Path) -> str:
    result = run_command(["git", "rev-parse", "HEAD"], cwd=repo_dir, check=True)
    return result.stdout.strip()


def _get_dirty_files(repo_dir: Path) -> list[str]:
    result = run_command(["git", "status", "--porcelain"], cwd=repo_dir, check=True)
    return [line for line in result.stdout.splitlines() if line.strip()]


def _normalize_git_url(url: str) -> str:
    normalized = url.strip().rstrip("/")
    if normalized.endswith(".git"):
        normalized = normalized[:-4]
    if normalized.startswith("git@github.com:"):
        normalized = normalized.replace("git@github.com:", "https://github.com/")
    return normalized


def _require_success(result: CommandResult, action: str) -> None:
    if result.ok:
        return
    raise RuntimeError(
        f"{action} failed with exit code {result.returncode}\n"
        f"Command: {' '.join(result.command)}\n"
        f"STDOUT:\n{result.stdout}\n"
        f"STDERR:\n{result.stderr}"
    )


def prepare_source_repo(
    url: str,
    destination: Path,
    depth: int | None = None,
    include_submodules: bool = False,
    reuse_if_exists: bool = True,
    fetch_if_exists: bool = True,
) -> SourceRepoStatus:
    """Ensure a local checkout exists and points to the expected remote URL.

    Existing checkouts are reused when possible, with explicit guard rails for URL mismatch.
    """
    destination = destination.resolve()
    requested_url = _normalize_git_url(url)

    if destination.exists():
        if not reuse_if_exists:
            raise RuntimeError(
                f"Destination {destination} already exists and reuse_if_exists is false."
            )
        if not _is_git_repo(destination):
            raise RuntimeError(f"Destination exists but is not a git repository: {destination}")

        existing_url = _normalize_git_url(_get_origin_url(destination))
        if existing_url != requested_url:
            raise RuntimeError(
                "Existing checkout remote URL does not match requested URL.\n"
                f"Requested: {requested_url}\n"
                f"Existing:  {existing_url}\n"
                f"Path:      {destination}"
            )

        if fetch_if_exists:
            fetch_result = run_command(["git", "fetch", "--tags", "origin"], cwd=destination)
            _require_success(fetch_result, "git fetch --tags origin")

        dirty_files = _get_dirty_files(destination)
        return SourceRepoStatus(
            repo_dir=destination,
            remote_url=existing_url,
            head_commit=_get_head_commit(destination),
            is_dirty=bool(dirty_files),
            dirty_files=dirty_files,
            reused_existing_checkout=True,
        )

    cmd = ["git", "clone"]
    if depth is not None:
        cmd.extend(["--depth", str(depth)])
    if include_submodules:
        cmd.append("--recurse-submodules")
    cmd.extend([url, str(destination)])
    clone_result = run_command(cmd)
    _require_success(clone_result, "git clone")

    dirty_files = _get_dirty_files(destination)
    return SourceRepoStatus(
        repo_dir=destination,
        remote_url=_normalize_git_url(_get_origin_url(destination)),
        head_commit=_get_head_commit(destination),
        is_dirty=bool(dirty_files),
        dirty_files=dirty_files,
        reused_existing_checkout=False,
    )


def clone_physlib(
    url: str,
    destination: Path,
    depth: int | None = None,
    include_submodules: bool = False,
    skip_if_exists: bool = True,
) -> CommandResult:
    """Backwards-compatible thin wrapper over :func:`prepare_source_repo`."""
    status = prepare_source_repo(
        url=url,
        destination=destination,
        depth=depth,
        include_submodules=include_submodules,
        reuse_if_exists=skip_if_exists,
        fetch_if_exists=True,
    )
    return CommandResult(
        command=["git", "clone", url, str(destination)],
        returncode=0,
        stdout=(
            f"repo_dir={status.repo_dir}\n"
            f"remote_url={status.remote_url}\n"
            f"head_commit={status.head_commit}\n"
            f"reused_existing_checkout={status.reused_existing_checkout}\n"
            f"is_dirty={status.is_dirty}"
        ),
        stderr="",
    )
