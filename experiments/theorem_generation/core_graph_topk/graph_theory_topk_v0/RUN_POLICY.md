# graph_theory_topk_v0 run policy

Do NOT run heavy graph processing on the login node.

Run via sbatch when the task includes:
- O(N^2) pair scoring
- embedding or retrieval over many declarations
- LLM generation
- Lean verification
- DeepSeekProver proof generation
- large JSONL scan / reranking

Login node is allowed only for:
- small file inspection
- head/tail/wc
- viewing summaries
- creating sbatch scripts
