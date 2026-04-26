# DeepSeek-Prover-V2-7B Baseline Results

This directory contains baseline results for DeepSeek-Prover-V2-7B on PhyslibBench.

## Main result

- Model: `deepseek-ai/DeepSeek-Prover-V2-7B`
- Setting: statement-only
- Split: held-out test
- Test size: 680
- Passed: 81
- pass@1: 11.91%
- Timeout: 0

## Evaluation protocol

For each theorem:

1. Provide the theorem statement to the model.
2. Generate a Lean proof body.
3. Replace the original proof in the corresponding Physlib source file.
4. Run `lake env lean <file>`.
5. Mark as success if Lean compilation succeeds.

## Files

- `summary_deepseek_v2_7b_test_statement_only.json`
- `eval_deepseek_v2_7b_test_statement_only.jsonl`
- `domain_pass_rates_deepseek_v2_7b_test_statement_only.tsv`
- `examples_deepseek_v2_7b_test_passed.md`
- `examples_deepseek_v2_7b_test_failed.md`
