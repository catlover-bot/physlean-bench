# PhyslibBench Dataset

PhyslibBench is a theorem-level Lean 4 benchmark derived from the Physlib repository.

## Source

- Source repository: https://github.com/leanprover-community/physlib.git
- Source commit: `4ef4cb5e1af18faf59ca3437d50d260d05e9b85d`
- Lean toolchain: `leanprover/lean4:v4.29.1`
- Trace backend: `leandojo_v2`

## Files

- `traced_theorems.clean.v0.jsonl`: clean theorem-level records
- `train.jsonl`: training split
- `valid.jsonl`: validation split
- `test.jsonl`: held-out test split
- `metadata.json`: trace run metadata
- `dataset_summary_rc13.json`: dataset summary
- `module_counts_rc13.tsv`: module/domain counts
- `checksums.sha256`: file checksums

## Dataset size

- traced theorem records: 5601
- clean usable records: 5593
- train / valid / test: 4337 / 576 / 680

## Record fields

Each record may include:

- `theorem_id`
- `declaration_name`
- `statement`
- `proof_text`
- `used_premises`
- `accessible_premises`
- `file_path`
- `module_path`
- `namespace`
- `line_start`
- `line_end`
- `proof_extraction_method`
- `source_commit`

## Split policy

The dataset uses a file-level split. Theorems from the same Lean source file are assigned to the same split to reduce leakage between train, validation, and test.
