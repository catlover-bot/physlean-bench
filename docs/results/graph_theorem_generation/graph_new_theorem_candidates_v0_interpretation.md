# Interpretation of graph theorem generation v0

## Question

Is this graph-theory theorem generation?

## Answer

Yes, but v0 should be interpreted as a seed experiment rather than full theorem discovery.

The generated candidates use graph-theoretic objects and properties from Mathlib:

- `SimpleGraph.completeGraph`
- `⊤ : SimpleGraph V`
- `K n := completeGraph (Fin n)`
- `pathGraph`
- `cycleGraph`
- `degree`
- `Connected`
- subgraph relation `≤`

All 10 candidates were verified by Lean in the Mathlib-enabled CSLib environment.

## Candidate types

| theorem | concept | type |
|---|---|---|
| `K_eq_completeGraph` | K_n definition | definitional |
| `K_eq_top` | complete graph = top graph | wrapper |
| `K_degree` | degree of K_n | wrapper |
| `top_degree_fin` | degree of top graph | reformulation |
| `K_connected_succ` | connectivity of K_n | reformulation |
| `top_connected_fin_succ` | connectivity of top graph | reformulation |
| `path_connected_succ` | path graph connectivity | wrapper |
| `cycle_connected_succ` | cycle graph connectivity | wrapper |
| `cycle_degree_two` | cycle graph degree | wrapper |
| `path_le_cycle` | path graph as subgraph of cycle graph | wrapper |

## Research interpretation

This v0 experiment demonstrates that graph-theory theorem candidates can be generated and machine-verified in Lean using Mathlib's `SimpleGraph` library.

However, most v0 candidates are direct reformulations of existing Mathlib facts. Therefore, v0 is best described as:

> verified graph-theory theorem candidate generation from existing library primitives

rather than:

> discovery of mathematically novel graph theorems

## Next step

The next experiment should generate composed candidates that combine multiple facts.

Examples:

- combine `K_n = ⊤` with degree facts
- combine connectivity of complete graphs with `Fin (n+1)`
- combine path/cycle inclusion with connectivity or degree facts
- generate theorem families and classify them as direct, reformulated, or composed

The important research question is not only whether Lean verifies the final theorem, but whether the generated theorem is a nontrivial composition of existing graph-theory knowledge.
