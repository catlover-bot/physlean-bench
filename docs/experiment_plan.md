# Experiment Plan

## Objective

Produce a traced Physlib benchmark release candidate and evaluate DeepSeek-Prover-V2 under leakage-aware splits with domain-shift analysis.

## Current State (Code)

Implemented and runnable:
- traced-first staged pipeline commands,
- preflight checks and stage markers,
- trace validation reports,
- traced-only guards for inventory/completion,
- quality heuristics and exclusion tracking,
- split profiles + novelty-aware split summary,
- audit sampling/comparison reports,
- release packaging layout + release manifest.

Known environment-sensitive step:
- full `leandojo_v2` trace run can still fail when machine disk is insufficient.

## Phase 1: Generate Traced Release Candidate

1. Pin source commit.
2. Run `trace-source --backend leandojo_v2` (after preflight passes).
3. Run `validate-trace` with expected URL/commit/backend.
4. Build traced-only inventory.
5. Build traced-only completion dataset.
6. Generate splits (`namespace`, `file`, `novel_local_premise`; choose release profile).
7. Export audit bundle and comparison reports.
8. Package release via `make-release`.

If preflight fails due disk/tooling, move the run to a better machine without changing pipeline semantics.

## Phase 2: Evaluation Readiness

1. Confirm release candidate artifacts and manifest completeness.
2. Finalize DeepSeek-Prover-V2 serving mode (API/local) and credentials setup.
3. Run small dry-run verification loop on release subset.
4. Run pass@k experiments on chosen split.

## Phase 3: Analysis

1. Build failure taxonomy (syntax/typeclass/search/domain-specific failures).
2. Compare performance by namespace/file cluster.
3. Analyze sensitivity to local premise novelty split.
4. Produce traced-vs-fallback comparison appendix (methodological, not performance claim).

## Command Skeleton

```bash
physlean-bench clone-source ...
physlean-bench build-source ...
physlean-bench trace-source --backend leandojo_v2 ...
physlean-bench validate-trace ...
physlean-bench inventory --traced-only ...
physlean-bench make-completion --traced-only ...
physlean-bench make-splits ...
physlean-bench audit-completion ...
physlean-bench make-release ...
```

Optional single helper:

```bash
physlean-bench release-candidate-physlib --source-commit <PIN> --release-name <NAME>
```

## Remaining Blockers Before Full DeepSeek Runs

- complete full traced release candidate on high-disk machine,
- finalize DeepSeek-Prover-V2 runtime/endpoint configuration,
- execute full proof verification and evaluation loops at scale.
