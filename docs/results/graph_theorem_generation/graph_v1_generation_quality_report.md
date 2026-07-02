# Graph theorem generation v1 quality report

## Summary

- records: 10
- has_sorry: 6
- has_natural_language: 1
- uses_wrong_names: 3
- uses_off_target_completeBipartite: 1
- likely_verifiable: 2

## Interpretation

The GPU generation job succeeded, but unconstrained theorem generation produced many invalid or off-target Lean candidates.

Main failure modes:

- generated `sorry`
- used non-Mathlib names such as `PathGraph`, `CycleGraph`, or `CompleteGraph`
- produced natural-language analysis instead of Lean code
- drifted to off-target graph notions such as `completeBipartite`

This motivates a stricter prompt format with fixed imports, allowed lemmas, namespace, and theorem skeletons.

## Per-record classification

| idx | theorem_id | theorem_names | sorry | wrong_names | natural_language | off_target | likely_verifiable |
|---:|---|---|---:|---:|---:|---:|---:|
| 1 | `graph_gen_v1_001` | `complete_graph_degree` | 0 | 0 | 0 | 1 | 0 |
| 2 | `graph_gen_v1_002` | `complete_graph_iff_degree` | 1 | 0 | 0 | 0 | 0 |
| 3 | `graph_gen_v1_003` | `sum_of_degrees_eq_twice_num_edges` | 0 | 0 | 0 | 0 | 1 |
| 4 | `graph_gen_v1_004` | `complete_graph_connected` | 1 | 0 | 0 | 0 | 0 |
| 5 | `graph_gen_v1_005` | `pathGraph_connected_and_le_cycleGraph` | 1 | 1 | 0 | 0 | 0 |
| 6 | `graph_gen_v1_006` | `cycle_graph_connected_and_degree_three_le` | 1 | 1 | 0 | 0 | 0 |
| 7 | `graph_gen_v1_007` | `sum_degrees_eq_twice_card_edges` | 1 | 0 | 0 | 0 | 0 |
| 8 | `graph_gen_v1_008` | `even_card_odd_degree_vertices` | 0 | 0 | 0 | 0 | 1 |
| 9 | `graph_gen_v1_009` | `P2_eq_K2` | 1 | 1 | 0 | 0 | 0 |
| 10 | `graph_gen_v1_010` | `candidate, should` | 0 | 0 | 1 | 0 | 0 |
