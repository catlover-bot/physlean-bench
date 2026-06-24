# Base vs LoRA evaluation summary

| split | n | Base | LoRA | Δ | both_pass | base_only | lora_only | both_fail |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| CSLib valid 41 | 41 | 3 (7.32%) | 7 (17.07%) | +4 | 1 | 2 | 6 | 32 |
| CSLib test 83 | 83 | 6 (7.23%) | 3 (3.61%) | -3 | 2 | 4 | 1 | 76 |
| Physlib valid 491 | 491 | 24 (4.89%) | 37 (7.54%) | +13 | 18 | 6 | 19 | 448 |
| Physlib test 680 | 680 | 31 (4.56%) | 30 (4.41%) | -1 | 21 | 10 | 9 | 640 |
