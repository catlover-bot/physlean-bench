from __future__ import annotations

from pathlib import Path

from physlean_bench.tracing.preflight import run_trace_preflight, write_preflight_artifacts
from physlean_bench.utils.io import read_json


def _init_git_repo(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)
    (path / "README.md").write_text("test\n", encoding="utf-8")
    import subprocess

    subprocess.run(["git", "init"], cwd=path, check=True, capture_output=True)
    subprocess.run(["git", "add", "README.md"], cwd=path, check=True, capture_output=True)
    subprocess.run(
        ["git", "-c", "user.email=test@example.com", "-c", "user.name=test", "commit", "-m", "init"],
        cwd=path,
        check=True,
        capture_output=True,
    )


def test_preflight_reports_disk_failure_and_writes_artifacts(tmp_path: Path) -> None:
    repo_dir = tmp_path / "repo"
    _init_git_repo(repo_dir)

    output_dir = tmp_path / "out"
    report = run_trace_preflight(
        repo_dir=repo_dir,
        output_dir=output_dir,
        backend="source_scan",
        min_free_disk_gb=10_000.0,
    )
    assert not report.can_proceed
    disk_checks = [item for item in report.checks if item.name == "free_disk_space"]
    assert len(disk_checks) == 1
    assert not disk_checks[0].ok

    out_json = tmp_path / "preflight.json"
    out_md = tmp_path / "preflight.md"
    write_preflight_artifacts(report, output_json=out_json, output_markdown=out_md)
    payload = read_json(out_json)
    assert payload["can_proceed"] is False
    assert out_md.exists()
