# Physlib / CSLib benchmark results

This directory contains lightweight artifacts for the Physlib and CSLib theorem-level benchmark experiments.

## Included

- `physlib_bench_v0/`
  - Physlib trace outputs
  - Physlib cross-domain heuristic split
  - evaluation subsets

- `cslib_bench_v0/`
  - CSLib trace / benchmark split
  - CSLib gold proof evaluation
  - DeepSeek-Prover-V2-7B statement-only evaluation
  - CSLib cross-domain heuristic pilot 100

## Not included

Large caches, build directories, Slurm temporary directories, model caches, and external dataset directories are intentionally excluded.

## Premise selection

Cross-library Physlib and CSLib premise-selection artifacts are available in [`premise_selection_v1/`](premise_selection_v1/).
