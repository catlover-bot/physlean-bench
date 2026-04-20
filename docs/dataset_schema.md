# Dataset Schema

This document describes the JSON/JSONL artifacts produced by `physlean-bench`.

## Core JSONL Records

### `SourceRepoInfo` (manifest embedded object)

- `name: str`
- `url: str`
- `commit: str`
- `clone_path: str`
- `tracing_tool: str`
- `tracing_tool_version: str`
- `lean_toolchain: str | null`
- `build_command: list[str]`
- `generation_timestamp_utc: str`

### `TracedTheoremInfo`

Required core fields:
- `theorem_id: str`
- `declaration_name: str`
- `namespace: str`
- `module_path: str`
- `file_path: str`
- `statement: str`
- `proof_text: str | null`

Metadata and provenance fields:
- `imports: list[str]`
- `declaration_kind: str`
- `has_sorry: bool`
- `has_admit: bool`
- `is_auto_generated: bool`
- `accessible_premises: list[str]`
- `used_premises: list[str]`
- `used_local_premises: list[str]`
- `depends_on_local_physlib: bool`
- `line_start: int | null`
- `line_end: int | null`
- `tags: list[str]`
- `trace_backend: str | null`
- `proof_extraction_method: str | null`
- `source_url: str | null`
- `source_commit: str | null`

Filtering/audit fields:
- `filter_excluded_reason: str | null`
- `quality_flags: list[str]`
- `quality_metrics: dict`

### `CompletionExample`

- `example_id: str`
- `theorem_id: str`
- `imports: list[str]`
- `context_header: str`
- `theorem_statement: str`
- `prompt_with_sorry: str`
- `gold_proof: str`
- `theorem_metadata: dict`
- `accessible_premises: list[str]`
- `used_premises: list[str]`

`theorem_metadata` now commonly includes:
- declaration/file/namespace/module,
- trace backend + proof extraction method,
- source URL/commit,
- quality flags/metrics.

### `SplitAssignment`

- `example_id: str`
- `split: "train" | "valid" | "test"`
- `strategy: str`
- `group_key: str`
- `random_seed: int`
- `notes: str | null`

### `EvaluationConfig`, `EvaluationResult`, `FailureCase`

These are unchanged from the initial scaffold and still used for model-eval runs:
- `EvaluationConfig`: run/model/generation/verification settings.
- `EvaluationResult`: generated candidates + pass@k + verification outputs.
- `FailureCase`: failure-stage taxonomy records used by error reports.

## Validation and Audit JSON

### `trace_validation.json`

Top-level fields:
- `ok: bool`
- `required_backend: str`
- `expected_source_url: str | null`
- `expected_source_commit: str | null`
- `issues: list[{severity, code, message, details}]`
- `stats: {...}`

### `audit_sample.json`

Top-level fields:
- `config`
- `counts`
- `difficulty_distribution_filtered`
- `suspicious_flag_counts_filtered`
- `excluded_summary` (if excluded inventory provided)
- `sampled_examples`

### `comparison_traced_vs_source_scan.json`

Top-level fields:
- `traced_count`
- `source_scan_count`
- `overlap_count`
- `traced_only_count`
- `source_scan_only_count`
- sampled key differences

## Manifest Schemas

### Completion manifest (`dataset/manifests.py`)

Includes:
- source repo metadata,
- tracing tool/version,
- generation config,
- config fingerprints,
- artifact hashes,
- deterministic manifest hash.

### Release manifest (`outputs/releases/<name>/release_manifest.json`)

Includes:
- release name + generation timestamp,
- authoritative path label,
- source URL/commit,
- trace backend/tool metadata,
- copied file map,
- per-artifact hashes,
- config snapshot listing,
- release manifest hash.

## Backend Semantics

`trace_backend` values in this repo:
- `leandojo_v2`: authoritative traced path.
- `source_scan_fallback`: explicit fallback path.

For benchmark-release claims, use traced-only (`leandojo_v2`) artifacts.
