# physlean-bench

`physlean-bench` builds Lean 4 benchmark datasets from `physlib` (`https://github.com/leanprover-community/physlib`) for theorem-proving research, with a Physlib-first focus and later extensibility to QuantumInfo.

Primary benchmark target in this repo: theorem completion.
Planned extensions: tactic prediction, premise retrieval, and DeepSeek-Prover-V2 evaluation.

## What Is Authoritative vs Fallback

- Authoritative benchmark path: `leandojo_v2` traced pipeline.
- Fallback/dev path: `source_scan` (real source extraction, but lower-fidelity metadata).

`source_scan` is explicitly marked in artifacts and is **not** treated as traced release-candidate output.

## Current Implementation Status

Implemented:
- source clone/reuse, remote checks, commit pinning,
- Physlib build orchestration (`lake exe cache get`, `lake build PhysLean`) with logs,
- trace preflight checks (disk/tooling/python/package checks),
- resumable trace pipeline with stage markers,
- traced output validation (`trace_validation.json` + `.md`),
- traced-only inventory guard,
- stronger filtering/quality heuristics + exclusion reasons,
- completion extraction with provenance/quality metadata,
- split generation (random/file/namespace/novel-local-premise + split profiles),
- audit exports and traced-vs-source-scan comparison,
- release packaging layout under `outputs/releases/<release_name>/...`.

Not guaranteed on every machine:
- full end-to-end `leandojo_v2` tracing if disk/tooling is insufficient.

## Environment Expectations

- Python 3.10+
- Lean toolchain available via `lake`/elan
- `lean-dojo` installed for authoritative tracing
- Substantial free disk for full tracing/build (often tens of GiB+)

Quick setup:

```bash
python3.11 -m venv .venv311
source .venv311/bin/activate
pip install -e '.[dev,trace]'
```

## Traced Release-Candidate Command Sequence (Staged)

1) Clone/reuse and pin source:

```bash
physlean-bench clone-source \
  --url https://github.com/leanprover-community/physlib.git \
  --destination data/source/physlib \
  --commit <PINNED_COMMIT> \
  --output-json outputs/rc/source_prep.json
```

2) Build Physlib-focused target:

```bash
physlean-bench build-source \
  --repo-dir data/source/physlib \
  --target PhysLean \
  --artifacts-dir outputs/rc/build
```

3) Trace with authoritative backend:

```bash
physlean-bench trace-source \
  --backend leandojo_v2 \
  --repo-dir data/source/physlib \
  --source-url https://github.com/leanprover-community/physlib.git \
  --expected-source-commit <PINNED_COMMIT> \
  --output-dir outputs/rc/trace \
  --output-jsonl outputs/rc/trace/traced_theorems.jsonl
```

4) Validate traced provenance/structure:

```bash
physlean-bench validate-trace \
  --traced-jsonl outputs/rc/trace/traced_theorems.jsonl \
  --trace-metadata-json outputs/rc/trace/trace_run_metadata.json \
  --required-backend leandojo_v2 \
  --expected-source-url https://github.com/leanprover-community/physlib.git \
  --expected-source-commit <PINNED_COMMIT> \
  --output-json outputs/rc/trace/trace_validation.json \
  --output-markdown outputs/rc/trace/trace_validation.md
```

5) Build traced-only inventory:

```bash
physlean-bench inventory \
  --traced-only \
  --trace-metadata-json outputs/rc/trace/trace_run_metadata.json \
  --input-traced-jsonl outputs/rc/trace/traced_theorems.jsonl \
  --output-inventory-jsonl outputs/rc/inventory/inventory.jsonl \
  --summary-json outputs/rc/inventory/summary.json \
  --summary-markdown outputs/rc/inventory/summary.md
```

6) Build traced-only completion data:

```bash
physlean-bench make-completion \
  --traced-only \
  --inventory-jsonl outputs/rc/inventory/inventory.jsonl \
  --output-jsonl outputs/rc/completion/completion.jsonl \
  --trace-metadata-json outputs/rc/trace/trace_run_metadata.json \
  --manifest-json outputs/rc/completion/manifest.json \
  --summary-json outputs/rc/completion/stats.json \
  --summary-markdown outputs/rc/completion/summary.md
```

7) Make splits + audit bundle:

```bash
physlean-bench make-splits \
  --inventory-jsonl outputs/rc/inventory/inventory.jsonl \
  --output-jsonl outputs/rc/splits/split.assignments.jsonl \
  --strategy novel_local_premise \
  --profile release_candidate \
  --summary-json outputs/rc/splits/summary.json \
  --summary-markdown outputs/rc/splits/summary.md

physlean-bench audit-completion \
  --completion-jsonl outputs/rc/completion/completion.jsonl \
  --excluded-inventory-jsonl outputs/rc/inventory/inventory.excluded.jsonl \
  --output-json outputs/rc/reports/audit_sample.json \
  --output-markdown outputs/rc/reports/audit_sample.md
```

8) Package release artifacts:

```bash
physlean-bench make-release \
  --release-root outputs/releases \
  --release-name physlean_rc_v0 \
  --traced-jsonl outputs/rc/trace/traced_theorems.jsonl \
  --trace-metadata-json outputs/rc/trace/trace_run_metadata.json \
  --trace-validation-json outputs/rc/trace/trace_validation.json \
  --trace-validation-markdown outputs/rc/trace/trace_validation.md \
  --inventory-jsonl outputs/rc/inventory/inventory.jsonl \
  --completion-jsonl outputs/rc/completion/completion.jsonl
```

Optional helper command (runs staged pipeline and packages release):

```bash
physlean-bench release-candidate-physlib \
  --source-commit <PINNED_COMMIT> \
  --release-name physlean_rc_v0
```

## Fallback Dev Path

When full tracing is blocked, run `--backend source_scan` explicitly. Artifacts remain useful for development, but should not be labeled as traced release-candidate outputs.

## Release Layout

Release packaging writes:

- `outputs/releases/<release_name>/trace/`
- `outputs/releases/<release_name>/inventory/`
- `outputs/releases/<release_name>/completion/`
- `outputs/releases/<release_name>/splits/`
- `outputs/releases/<release_name>/reports/`
- `outputs/releases/<release_name>/configs/`
- `outputs/releases/<release_name>/release_manifest.json`
- `outputs/releases/<release_name>/release_summary.md`

## What Still Blocks DeepSeek-Prover-V2 Evaluation

- full authoritative traced release on a machine with enough disk/resources,
- final model-serving/runtime integration for DeepSeek-Prover-V2,
- full proof verification at benchmark scale.

## Immediate Next Steps

1. Pin final physlib commit for release.
2. Run full `leandojo_v2` trace on a high-disk machine.
3. Validate trace (`validate-trace`) and generate traced-only inventory/completion.
4. Finalize split assignment artifacts for release.
5. Run DeepSeek-Prover-V2 evaluation on release data.
