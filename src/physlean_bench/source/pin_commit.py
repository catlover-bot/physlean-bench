"""Commit pinning utilities for reproducible source snapshots."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import logging

from physlean_bench.utils.subprocess import run_command

logger = logging.getLogger(__name__)


@dataclass
class PinCommitResult:
    repo_dir: Path
    requested_commit: str | None
    resolved_commit: str
    working_tree_dirty: bool
    dirty_files: list[str]
    checkout_performed: bool


def _is_git_repo(path: Path) -> bool:
    result = run_command(["git", "rev-parse", "--is-inside-work-tree"], cwd=path)
    return result.ok and result.stdout.strip() == "true"


def _dirty_files(repo_dir: Path) -> list[str]:
    result = run_command(["git", "status", "--porcelain"], cwd=repo_dir, check=True)
    return [line for line in result.stdout.splitlines() if line.strip()]


def _commit_exists(repo_dir: Path, commit: str) -> bool:
    result = run_command(["git", "cat-file", "-e", f"{commit}^{{commit}}"], cwd=repo_dir)
    return result.ok


def _fetch_commit(repo_dir: Path, commit: str) -> None:
    # Best effort: fetch tags and then specific commit/ref from origin.
    run_command(["git", "fetch", "--tags", "origin"], cwd=repo_dir)
    run_command(["git", "fetch", "origin", commit], cwd=repo_dir)


def pin_or_read_commit(
    repo_dir: Path,
    commit: str | None = None,
    *,
    allow_dirty: bool = False,
    fetch_if_missing: bool = True,
) -> PinCommitResult:
    """Pin repository to a commit hash and return resolved HEAD metadata."""
    repo_dir = repo_dir.resolve()
    if not _is_git_repo(repo_dir):
        raise RuntimeError(f"Not a git repository: {repo_dir}")

    dirty = _dirty_files(repo_dir)
    if dirty and not allow_dirty:
        raise RuntimeError(
            "Working tree is dirty. Refusing to pin commit with allow_dirty=False.\n"
            f"Repo: {repo_dir}\n"
            f"Dirty entries (git status --porcelain):\n" + "\n".join(dirty[:50])
        )

    checkout_performed = False
    if commit:
        if not _commit_exists(repo_dir, commit) and fetch_if_missing:
            logger.info("Commit %s not found locally. Fetching from origin.", commit)
            _fetch_commit(repo_dir, commit)

        if not _commit_exists(repo_dir, commit):
            raise RuntimeError(
                f"Commit {commit} is not available in {repo_dir}, even after fetch."
            )

        logger.info("Checking out pinned commit %s in %s", commit, repo_dir)
        run_command(["git", "checkout", "--detach", commit], cwd=repo_dir, check=True)
        checkout_performed = True

    head = run_command(["git", "rev-parse", "HEAD"], cwd=repo_dir, check=True)
    return PinCommitResult(
        repo_dir=repo_dir,
        requested_commit=commit,
        resolved_commit=head.stdout.strip(),
        working_tree_dirty=bool(dirty),
        dirty_files=dirty,
        checkout_performed=checkout_performed,
    )
