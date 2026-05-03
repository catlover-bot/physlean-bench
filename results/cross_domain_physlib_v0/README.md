# Physlib-internal Cross-domain Pilot v0

This directory contains a pilot evaluation of automatically mined Physlib-internal cross-domain theorem candidates.

## Setting

- Source dataset: PhyslibBench rc13
- Candidate selection: heuristic domain crossing based on file domain, declaration names, and used premise domains
- Model: DeepSeek-Prover-V2-7B
- Prompt: statement-only
- Candidate split: held-out test candidates
- Pilot size: 100

## Main result

- n: 100
- passed: 2
- pass@1: 2.0%
- timeout: 0

Compared with the regular PhyslibBench held-out test result, 81/680 = 11.91%, the cross-domain pilot appears substantially harder.
