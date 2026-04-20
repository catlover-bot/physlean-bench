"""Lean proof verification pipeline scaffold."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

from physlean_bench.schemas import CompletionExample
from physlean_bench.utils.subprocess import CommandResult, run_command


@dataclass
class VerificationConfig:
    source_repo_dir: Path
    work_dir: Path
    lean_check_cmd: list[str]
    timeout_seconds: int = 60
    dry_run: bool = True


@dataclass
class VerificationOutcome:
    success: bool
    returncode: int
    stdout: str
    stderr: str
    candidate_file: Path


def _inject_proof(prompt_with_sorry: str, candidate_proof: str) -> str:
    clean_candidate = candidate_proof.strip()
    if "by sorry" in prompt_with_sorry:
        if clean_candidate.startswith("by"):
            replacement = clean_candidate
        else:
            replacement = f"by\n  {clean_candidate}"
        return prompt_with_sorry.replace("by sorry", replacement, 1)

    # Fallback path if prompt format deviates from `by sorry`.
    if clean_candidate.startswith("by"):
        return f"{prompt_with_sorry}\n{clean_candidate}"
    return f"{prompt_with_sorry}\nby\n  {clean_candidate}"


def materialize_candidate_file(
    example: CompletionExample,
    candidate_proof: str,
    output_path: Path,
) -> Path:
    output_path.parent.mkdir(parents=True, exist_ok=True)
    candidate_decl = _inject_proof(example.prompt_with_sorry, candidate_proof)

    source = []
    if example.context_header:
        source.append(example.context_header)
    source.append(candidate_decl)
    output_path.write_text("\n\n".join(source) + "\n", encoding="utf-8")
    return output_path


def verify_candidate(
    example: CompletionExample,
    candidate_proof: str,
    config: VerificationConfig,
    candidate_name: str,
) -> VerificationOutcome:
    candidate_file = materialize_candidate_file(
        example,
        candidate_proof,
        config.work_dir / f"{candidate_name}.lean",
    )

    if config.dry_run:
        return VerificationOutcome(
            success=False,
            returncode=0,
            stdout="dry_run=true: verification command not executed",
            stderr="",
            candidate_file=candidate_file,
        )

    cmd = list(config.lean_check_cmd) + [str(candidate_file)]
    result: CommandResult = run_command(
        cmd,
        cwd=config.source_repo_dir,
        timeout_seconds=config.timeout_seconds,
    )

    return VerificationOutcome(
        success=result.ok,
        returncode=result.returncode,
        stdout=result.stdout,
        stderr=result.stderr,
        candidate_file=candidate_file,
    )
