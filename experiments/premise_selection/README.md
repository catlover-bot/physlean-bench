# Cross-library premise selection experiments

This directory contains the scripts used for graph-guided premise-selection experiments on Physlib and CSLib.

## Task

For each theorem target, rank legally visible theorem or lemma premises and measure whether the gold premises appear in the top-K candidates.

These experiments evaluate **premise retrieval**. Recall@K must not be interpreted as end-to-end Lean proof success.

## Methods

- BM25 lexical retrieval
- structural graph and name features
- nearest-theorem dependency transfer
- imported-premise quota reranking
- candidate-level safe imported-premise replacement
- paired bootstrap comparison

## Layout

- `physlib/`: Physlib benchmark construction and evaluation scripts
- `cslib/`: CSLib benchmark construction and evaluation scripts
- `cross_library/`: Physlib-CSLib aggregate report generation

## Data and outputs

Benchmark datasets, prediction files, and evaluation summaries are stored under:

```text
results/premise_selection_v1/
```

The scripts were developed in the NAIST cluster environment. Their original cluster paths are retained for provenance. The copied benchmark data and result files can be inspected independently of that environment.
