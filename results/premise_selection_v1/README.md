# Premise-selection results v1

This directory contains the principal artifacts from the Physlib and CSLib premise-selection experiments.

## Headline results

| Library / method | MRR | R@10 | R@20 | R@50 | Imported R@20 | Imported R@50 |
|---|---:|---:|---:|---:|---:|---:|
| Physlib BM25 | 0.5547 | 0.5110 | 0.6019 | 0.7493 | 0.4091 | 0.6277 |
| Physlib balanced quota | 0.5564 | 0.5358 | 0.6350 | 0.7741 | 0.4654 | 0.6710 |
| Physlib recall-oriented quota | 0.5567 | 0.5110 | 0.6515 | 0.7727 | 0.4957 | 0.6688 |
| CSLib BM25 | 0.4825 | 0.4276 | 0.5855 | 0.7368 | 0.4299 | 0.6262 |
| CSLib imported quota | 0.4786 | 0.3618 | 0.5855 | 0.7632 | 0.4299 | 0.6636 |

## Main interpretation

- Raw graph retrieval alone does not outperform BM25.
- Physlib shows a clear Top-20 improvement from import-aware dual-channel reranking.
- CSLib does not reproduce the Top-20 improvement.
- CSLib shows statistically supported Top-50 and imported Top-50 improvements.
- CSLib Top-10 recall decreases, indicating a coverage-versus-early-precision trade-off.
- The method should therefore be presented as library-dependent rather than universally beneficial.

## Directory structure

### `physlib/`

- benchmark summary and audit
- graph-transfer and import-quota results
- bootstrap comparison
- test predictions
- premise catalog, positive targets, and import graph

### `cslib/`

- benchmark summary
- graph-transfer and import-quota results
- paired bootstrap comparison
- test predictions
- premise catalog, positive targets, and import graph

### `cross_library/`

- consolidated Physlib-CSLib comparison report

### `exploratory_cslib/`

- post-hoc transfer-signal analyses
- structure-aware reranking experiment
- exploratory artifacts that are not untouched-test main results

## Important metric note

Recall@K measures recovery of gold premise labels within the candidate ranking. It does not measure whether Lean can synthesize or verify a complete proof from the returned premises.
