from __future__ import annotations

from datetime import datetime, timezone
from pathlib import Path

from physlean_bench.schemas import CompletionExample, SourceRepoInfo, read_jsonl, write_jsonl


def test_source_repo_info_roundtrip() -> None:
    src = SourceRepoInfo(
        name="leanprover-community/physlib",
        url="https://github.com/leanprover-community/physlib.git",
        commit="abc123",
        clone_path=Path("data/source/physlib"),
        tracing_tool="leandojo-v2",
        tracing_tool_version="v2-placeholder",
        lean_toolchain="leanprover/lean4:v4.10.0",
        build_command=["lake", "build"],
        generation_timestamp_utc=datetime.now(timezone.utc).isoformat(),
    )

    restored = SourceRepoInfo.from_dict(src.to_dict())
    assert restored.url == src.url
    assert restored.clone_path == src.clone_path


def test_completion_jsonl_roundtrip(tmp_path: Path) -> None:
    record = CompletionExample(
        example_id="completion::1",
        theorem_id="theorem::1",
        imports=["Mathlib"],
        context_header="import Mathlib",
        theorem_statement="theorem t : True := by trivial",
        prompt_with_sorry="theorem t : True := by sorry",
        gold_proof="by trivial",
        theorem_metadata={"namespace": "PhysLean.Mock"},
        accessible_premises=["True.intro"],
        used_premises=["True.intro"],
    )

    path = tmp_path / "completion.jsonl"
    write_jsonl(path, [record])
    loaded = read_jsonl(path, CompletionExample)

    assert len(loaded) == 1
    assert loaded[0].example_id == record.example_id
    assert loaded[0].used_premises == ["True.intro"]
