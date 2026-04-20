"""Fallback source scanner for theorem extraction when LeanDojo tracing is unavailable."""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
import logging
import re

from physlean_bench.schemas import TracedTheoremInfo

logger = logging.getLogger(__name__)


_DECL_START = re.compile(r"^(theorem|lemma)\s+(?P<name>[A-Za-z0-9_'.]+)")
_NAMESPACE = re.compile(r"^namespace\s+([A-Za-z0-9_.']+)")
_END = re.compile(r"^end(?:\s+([A-Za-z0-9_.']+))?$")


@dataclass
class SourceScanConfig:
    repo_dir: Path
    include_prefixes: list[str]
    exclude_prefixes: list[str]


def _extract_imports(lines: list[str]) -> list[str]:
    imports: list[str] = []
    in_block_comment = False
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        if in_block_comment:
            if "-/" in stripped:
                in_block_comment = False
            continue
        if stripped.startswith("/-"):
            if "-/" not in stripped:
                in_block_comment = True
            continue
        if stripped.startswith("--"):
            continue
        if stripped.startswith("import "):
            imports.extend(stripped[len("import ") :].split())
            continue
        break
    return list(dict.fromkeys(imports))


def _is_top_level_command(line: str) -> bool:
    stripped = line.lstrip()
    if line.startswith(" ") or line.startswith("\t"):
        return False
    return stripped.startswith(
        (
            "theorem ",
            "lemma ",
            "def ",
            "instance ",
            "example ",
            "axiom ",
            "namespace ",
            "section ",
            "end",
            "open ",
            "set_option",
            "attribute",
            "@[",
        )
    )


def _extract_theorem_blocks(path: Path, rel_path: str) -> list[TracedTheoremInfo]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines()
    imports = _extract_imports(lines)

    records: list[TracedTheoremInfo] = []
    namespace_stack: list[str] = []
    i = 0

    while i < len(lines):
        stripped = lines[i].strip()

        ns = _NAMESPACE.match(stripped)
        if ns:
            namespace_stack.append(ns.group(1))
            i += 1
            continue

        end = _END.match(stripped)
        if end and namespace_stack:
            namespace_stack.pop()
            i += 1
            continue

        start_match = _DECL_START.match(stripped)
        if not start_match:
            i += 1
            continue

        decl_start = i
        declaration_lines = [lines[i]]
        j = i + 1
        while j < len(lines):
            declaration_lines.append(lines[j])
            if ":=" in lines[j] or ":=" in declaration_lines[0]:
                break
            if _is_top_level_command(lines[j]) and j > i + 1:
                break
            j += 1

        header_text = "\n".join(declaration_lines)
        if ":=" not in header_text:
            i = max(j, i + 1)
            continue

        header_before, header_after = header_text.split(":=", maxsplit=1)
        statement = header_before.strip() + " :="

        proof_lines: list[str] = []
        tail = header_after.strip()
        if tail:
            proof_lines.append(tail)

        k = j + 1
        while k < len(lines):
            line_k = lines[k]
            if _is_top_level_command(line_k):
                break
            proof_lines.append(line_k)
            k += 1

        proof_text = "\n".join(proof_lines).strip() if proof_lines else None
        if proof_text == "":
            proof_text = None

        local_name = start_match.group("name")
        namespace = ".".join(namespace_stack)
        full_name = f"{namespace}.{local_name}" if namespace else local_name
        module_path = rel_path.replace("/", ".").removesuffix(".lean")

        theorem_id = f"source_scan::{rel_path}::{decl_start + 1}::{full_name}"
        has_sorry = bool(proof_text and "sorry" in proof_text) or "sorry" in statement
        has_admit = bool(proof_text and "admit" in proof_text) or "admit" in statement

        records.append(
            TracedTheoremInfo(
                theorem_id=theorem_id,
                declaration_name=full_name,
                namespace=namespace,
                module_path=module_path,
                file_path=rel_path,
                statement=statement,
                proof_text=proof_text,
                imports=imports,
                declaration_kind=start_match.group(1),
                has_sorry=has_sorry,
                has_admit=has_admit,
                is_auto_generated=full_name.startswith("_") or ".match_" in full_name,
                accessible_premises=[],
                used_premises=[],
                line_start=decl_start + 1,
                line_end=k if k > decl_start else decl_start + 1,
                tags=["source_scan", "real_source"],
                trace_backend="source_scan_fallback",
                proof_extraction_method="source_scan",
            )
        )

        i = max(k, i + 1)

    return records


def scan_repo_theorems(config: SourceScanConfig) -> list[TracedTheoremInfo]:
    include_prefixes = config.include_prefixes or ["Physlib/", "PhysLean/"]
    exclude_prefixes = config.exclude_prefixes or []

    records: list[TracedTheoremInfo] = []
    for file_path in sorted(config.repo_dir.rglob("*.lean")):
        rel_path = file_path.relative_to(config.repo_dir).as_posix()
        if include_prefixes and not any(rel_path.startswith(prefix) for prefix in include_prefixes):
            continue
        if any(rel_path.startswith(prefix) for prefix in exclude_prefixes):
            continue
        records.extend(_extract_theorem_blocks(file_path, rel_path))

    logger.info("Source scan extracted %d theorem/lemma declarations", len(records))
    return records
