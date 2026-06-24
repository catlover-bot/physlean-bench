# Base vs LoRA: valid/test evaluation summary

## Main result

| split | n | Base | LoRA | Δ | both_pass | base_only | lora_only | both_fail |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| CSLib valid 41 | 41 | 3 (7.32%) | 7 (17.07%) | +4 | 1 | 2 | 6 | 32 |
| CSLib test 83 | 83 | 6 (7.23%) | 3 (3.61%) | -3 | 2 | 4 | 1 | 76 |
| Physlib valid 491 | 491 | 24 (4.89%) | 37 (7.54%) | +13 | 18 | 6 | 19 | 448 |
| Physlib test 680 | 680 | 31 (4.56%) | 30 (4.41%) | -1 | 21 | 10 | 9 | 640 |

## Interpretation

The LoRA models improve pass@1 on the validation splits, but the improvement does not consistently transfer to the held-out test splits.

- On CSLib valid, CSLib-only LoRA improves from 3/41 to 7/41.
- On CSLib test, CSLib-only LoRA drops from 6/83 to 3/83.
- On Physlib valid, Physlib-only LoRA improves from 24/491 to 37/491.
- On Physlib test, Physlib-only LoRA is almost tied with base, 31/680 vs 30/680.

This suggests that LoRA does not simply produce a uniformly stronger prover. Instead, it changes the distribution of solved theorems. The existence of both base_only and lora_only cases indicates that fine-tuning creates complementary successes and failures.

## Research claim

A useful research direction is to analyze LoRA-based theorem proving not only by aggregate pass rate, but also by success redistribution: which theorem families are newly solved, which are forgotten, and whether validation improvements generalize to held-out mathematical domains.

