from __future__ import annotations

from pathlib import Path

from physlean_bench.dataset.release import package_release_candidate
from physlean_bench.utils.io import read_json, write_json


def _touch(path: Path, content: str = "x\n") -> Path:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")
    return path


def test_release_packaging_copies_files_and_writes_manifest(tmp_path: Path) -> None:
    traced_jsonl = _touch(tmp_path / "inputs" / "traced_theorems.jsonl", '{"a":1}\n')
    trace_meta = tmp_path / "inputs" / "trace_meta.json"
    write_json(
        trace_meta,
        {
            "source_url": "https://github.com/leanprover-community/physlib.git",
            "source_commit": "abc",
            "trace_backend": "leandojo_v2",
            "tracing_tool": "leandojo-v2",
            "tracing_tool_version": "test",
            "generated_at_utc": "2026-01-01T00:00:00+00:00",
        },
    )
    inventory_jsonl = _touch(tmp_path / "inputs" / "inventory.jsonl", '{"a":1}\n')
    completion_jsonl = _touch(tmp_path / "inputs" / "completion.jsonl", '{"a":1}\n')

    result = package_release_candidate(
        release_root=tmp_path / "releases",
        release_name="rc0",
        trace_files={"traced_jsonl": traced_jsonl, "metadata_json": trace_meta},
        inventory_files={"inventory_jsonl": inventory_jsonl},
        completion_files={"completion_jsonl": completion_jsonl},
        split_files={},
        report_files={},
        config_paths=[],
    )

    assert result.manifest_path.exists()
    payload = read_json(result.manifest_path)
    assert payload["release_name"] == "rc0"
    assert payload["trace"]["backend"] == "leandojo_v2"
    assert "trace/traced_jsonl" in payload["copied_files"]
