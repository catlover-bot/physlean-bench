"""Schema definitions for dataset generation and evaluation artifacts."""

from __future__ import annotations

from dataclasses import asdict, dataclass, field
from pathlib import Path
from typing import Any, Iterable, TypeVar
import json

T = TypeVar("T")


@dataclass
class SourceRepoInfo:
    name: str
    url: str
    commit: str
    clone_path: Path
    tracing_tool: str
    tracing_tool_version: str
    lean_toolchain: str | None
    build_command: list[str]
    generation_timestamp_utc: str

    def to_dict(self) -> dict[str, Any]:
        payload = asdict(self)
        payload["clone_path"] = str(self.clone_path)
        return payload

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "SourceRepoInfo":
        return cls(
            name=payload["name"],
            url=payload["url"],
            commit=payload["commit"],
            clone_path=Path(payload["clone_path"]),
            tracing_tool=payload["tracing_tool"],
            tracing_tool_version=payload["tracing_tool_version"],
            lean_toolchain=payload.get("lean_toolchain"),
            build_command=list(payload.get("build_command", [])),
            generation_timestamp_utc=payload["generation_timestamp_utc"],
        )


@dataclass
class TracedTheoremInfo:
    theorem_id: str
    declaration_name: str
    namespace: str
    module_path: str
    file_path: str
    statement: str
    proof_text: str | None
    imports: list[str] = field(default_factory=list)
    declaration_kind: str = "theorem"
    has_sorry: bool = False
    has_admit: bool = False
    is_auto_generated: bool = False
    accessible_premises: list[str] = field(default_factory=list)
    used_premises: list[str] = field(default_factory=list)
    used_local_premises: list[str] = field(default_factory=list)
    depends_on_local_physlib: bool = False
    line_start: int | None = None
    line_end: int | None = None
    tags: list[str] = field(default_factory=list)
    trace_backend: str | None = None
    proof_extraction_method: str | None = None
    filter_excluded_reason: str | None = None
    quality_flags: list[str] = field(default_factory=list)
    quality_metrics: dict[str, Any] = field(default_factory=dict)
    source_url: str | None = None
    source_commit: str | None = None

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "TracedTheoremInfo":
        return cls(**payload)


@dataclass
class CompletionExample:
    example_id: str
    theorem_id: str
    imports: list[str]
    context_header: str
    theorem_statement: str
    prompt_with_sorry: str
    gold_proof: str
    theorem_metadata: dict[str, Any]
    accessible_premises: list[str] = field(default_factory=list)
    used_premises: list[str] = field(default_factory=list)

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "CompletionExample":
        return cls(**payload)


@dataclass
class TacticExample:
    example_id: str
    theorem_id: str
    proof_state: str
    next_tactic: str
    next_proof_state: str | None
    theorem_metadata: dict[str, Any]

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "TacticExample":
        return cls(**payload)


@dataclass
class RetrievalExample:
    example_id: str
    theorem_id: str
    query: str
    candidate_premises: list[str]
    relevant_premises: list[str]
    theorem_metadata: dict[str, Any]

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "RetrievalExample":
        return cls(**payload)


@dataclass
class SplitAssignment:
    example_id: str
    split: str
    strategy: str
    group_key: str
    random_seed: int
    notes: str | None = None

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "SplitAssignment":
        return cls(**payload)


@dataclass
class EvaluationConfig:
    run_id: str
    task_type: str
    model_name: str
    adapter: str
    pass_at_k: list[int]
    temperature: float
    max_tokens: int
    verify_proofs: bool
    input_dataset_path: Path
    output_dir: Path
    max_examples: int | None = None

    def to_dict(self) -> dict[str, Any]:
        payload = asdict(self)
        payload["input_dataset_path"] = str(self.input_dataset_path)
        payload["output_dir"] = str(self.output_dir)
        return payload

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "EvaluationConfig":
        return cls(
            run_id=payload["run_id"],
            task_type=payload["task_type"],
            model_name=payload["model_name"],
            adapter=payload["adapter"],
            pass_at_k=list(payload["pass_at_k"]),
            temperature=float(payload["temperature"]),
            max_tokens=int(payload["max_tokens"]),
            verify_proofs=bool(payload["verify_proofs"]),
            input_dataset_path=Path(payload["input_dataset_path"]),
            output_dir=Path(payload["output_dir"]),
            max_examples=payload.get("max_examples"),
        )


@dataclass
class EvaluationResult:
    run_id: str
    example_id: str
    theorem_id: str
    generated_proofs: list[str]
    pass_at_k: dict[str, bool]
    verification_success: bool
    selected_proof: str | None
    verification_error: str | None
    latency_ms: float | None
    raw_model_response: dict[str, Any] | None

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "EvaluationResult":
        return cls(**payload)


@dataclass
class FailureCase:
    run_id: str
    example_id: str
    theorem_id: str
    failure_stage: str
    error_type: str
    message: str
    lean_error: str | None = None
    candidate_proof: str | None = None
    metadata: dict[str, Any] = field(default_factory=dict)

    def to_dict(self) -> dict[str, Any]:
        return asdict(self)

    @classmethod
    def from_dict(cls, payload: dict[str, Any]) -> "FailureCase":
        return cls(**payload)


def write_jsonl(path: Path, records: Iterable[Any]) -> None:
    """Write dataclass records to JSONL using their `to_dict` method when present."""
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as handle:
        for record in records:
            if hasattr(record, "to_dict"):
                payload = record.to_dict()
            elif isinstance(record, dict):
                payload = record
            else:
                raise TypeError(f"Record does not support JSONL serialization: {type(record)}")
            handle.write(json.dumps(payload, ensure_ascii=False) + "\n")


def read_jsonl(path: Path, record_type: type[T] | None = None) -> list[T] | list[dict[str, Any]]:
    """Read JSONL file and optionally parse each line into `record_type` via from_dict."""
    output: list[Any] = []
    with path.open("r", encoding="utf-8") as handle:
        for line in handle:
            if not line.strip():
                continue
            payload = json.loads(line)
            if record_type is None:
                output.append(payload)
            elif hasattr(record_type, "from_dict"):
                output.append(record_type.from_dict(payload))
            else:
                output.append(record_type(**payload))
    return output
