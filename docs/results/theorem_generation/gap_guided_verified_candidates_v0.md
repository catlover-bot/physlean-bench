# Gap-guided verified theorem candidates v0

## Summary

We extended graph-guided theorem generation into gap-guided theorem generation.

Starting from existing positivity theorems in Physlib, we detected missing closure/composition patterns and verified the generated candidates in Lean.

## Verified candidates

| Candidate | Source facts | Pattern | Lean |
|---|---|---|---|
| `Constants.inv_kB_pos` | `Constants.kB_pos` | positive inverse | passed |
| `Constants.inv_ℏ_pos` | `Constants.ℏ_pos` | positive inverse | passed |
| `Constants.kB_mul_ℏ_pos` | `Constants.kB_pos`, `Constants.ℏ_pos` | product of positives | passed |
| `Constants.kB_div_ℏ_pos` | `Constants.kB_pos`, `Constants.ℏ_pos` | quotient of positives | passed |
| `Constants.ℏ_div_kB_pos` | `Constants.ℏ_pos`, `Constants.kB_pos` | quotient of positives | passed |

## Novelty check

The following candidates had no hit in the extracted Physlib/CSLib theorem graph:

- `inv_ℏ_pos`
- `kB_mul_ℏ_pos`
- `kB_div_ℏ_pos`
- `ℏ_div_kB_pos`

Earlier, `inv_kB_pos` also had no hit.

## Interpretation

This suggests that theorem graph retrieval can be extended from local candidate generation to gap-guided theorem completion.

The current successful pattern is:

1. Detect existing positivity facts.
2. Identify missing closure/composition lemmas.
3. Generate candidate Lean statements.
4. Verify the candidates in the Physlib Lean environment.
5. Check non-duplication against the extracted theorem graph.

This gives a small but concrete feasibility result for theorem gap completion in domain-specific Lean libraries.
