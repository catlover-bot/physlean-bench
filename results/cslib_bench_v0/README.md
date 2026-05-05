# CSLibBench v0

CSLibBench v0 is a theorem-level benchmark extracted from CSLib using the PhysLeanBench / LeanDojo-based tracing pipeline.

## Status

- Source library: CSLib
- Domain: computer science
- Trace strategy: prefix/file-level tracing followed by merge
- Coverage audit: source theorem/lemma-like files were covered by traced records
- Output files:
  - `merged_raw.jsonl`
  - `clean.jsonl`
  - `train.jsonl`
  - `valid.jsonl`
  - `test.jsonl`
  - `summary.json`
  - `split_summary.json`

## Notes

The full CSLib trace was difficult to finish as a single job under the 4-hour walltime limit. We therefore split tracing by CSLib subdirectories and files, then merged successful theorem-level JSONL artifacts.
