"""Load traced theorem records from JSONL."""

from __future__ import annotations

from pathlib import Path

from physlean_bench.schemas import TracedTheoremInfo, read_jsonl
from physlean_bench.utils.io import read_json


def load_traced_theorems(path: Path) -> list[TracedTheoremInfo]:
    if not path.exists():
        raise FileNotFoundError(f"Traced theorem JSONL does not exist: {path}")
    return read_jsonl(path, TracedTheoremInfo)  # type: ignore[return-value]


def load_trace_metadata(path: Path) -> dict[str, object]:
    if not path.exists():
        raise FileNotFoundError(f"Trace metadata JSON does not exist: {path}")
    return read_json(path)
