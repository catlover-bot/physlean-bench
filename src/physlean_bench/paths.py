"""Centralized project path helpers."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import os


@dataclass(frozen=True)
class ProjectPaths:
    """Filesystem layout used by physlean_bench.

    Paths are derived from repository root and can be overridden by environment variables.
    """

    root: Path
    data_dir: Path
    output_dir: Path
    logs_dir: Path
    configs_dir: Path
    examples_dir: Path

    @classmethod
    def from_env(cls, root: Path | None = None) -> "ProjectPaths":
        resolved_root = (root or Path.cwd()).resolve()
        data_dir = Path(os.getenv("PHYSLEAN_BENCH_DATA_DIR", resolved_root / "data")).resolve()
        output_dir = Path(os.getenv("PHYSLEAN_BENCH_OUTPUT_DIR", resolved_root / "outputs")).resolve()
        logs_dir = output_dir / "logs"
        return cls(
            root=resolved_root,
            data_dir=data_dir,
            output_dir=output_dir,
            logs_dir=logs_dir,
            configs_dir=resolved_root / "configs",
            examples_dir=resolved_root / "examples",
        )

    def ensure_base_dirs(self) -> None:
        """Create standard runtime directories if missing."""
        for directory in (self.data_dir, self.output_dir, self.logs_dir):
            directory.mkdir(parents=True, exist_ok=True)
