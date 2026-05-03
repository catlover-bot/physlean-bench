# CSLib trace audit rc1

CSLib build succeeded, but LeanDojo tracing did not complete within the 4-hour walltime.

Observed status:
- CSLib build completed successfully
- trace_backend started
- trace_pipeline started
- final `traced_theorems.jsonl` was not produced
- Slurm state: TIMEOUT after ~4 hours
- MaxRSS: ~55GB

Next step:
- Run smaller include-prefix pilots before attempting full CSLib tracing.
