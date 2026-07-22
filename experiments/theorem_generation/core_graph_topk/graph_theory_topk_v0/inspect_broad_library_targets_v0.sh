#!/bin/bash
set -euo pipefail

WORK=/project/nlp-work11/$USER/physlean_eval_work/physlib_eval_smoke_built
OUT=/project/nlp-work11/$USER/theorem_generation/graph_theory_topk_v0/broad_library_targets_inventory_v0.txt

{
  echo "=== broad target inventory v0 ==="
  echo "WORK=$WORK"
  echo

  echo "=== candidate roots ==="
  for p in \
    "$WORK/.lake/packages/mathlib/Mathlib" \
    "$WORK/.lake/packages/mathlib/Mathlib/Combinatorics/SimpleGraph" \
    "$WORK/Physlib" \
    "$WORK/Cslib" \
    "$WORK/CSLib" \
    "$WORK/.lake/packages/Cslib" \
    "$WORK/.lake/packages/CSLib" \
    "$WORK/.lake/packages/cslib"
  do
    if [ -d "$p" ]; then
      n=$(find "$p" -type f -name '*.lean' | wc -l)
      echo "FOUND $n lean files :: $p"
    else
      echo "MISSING :: $p"
    fi
  done

  echo
  echo "=== shallow CSLib-like directories ==="
  find "$WORK" "$WORK/.lake/packages" -maxdepth 3 -type d \( -iname '*cslib*' -o -iname '*cs-lib*' \) 2>/dev/null | sort | head -n 80

  echo
  echo "=== shallow Physlib-like directories ==="
  find "$WORK" "$WORK/.lake/packages" -maxdepth 3 -type d \( -iname '*physlib*' -o -iname '*physics*' \) 2>/dev/null | sort | head -n 80

  echo
  echo "=== current graph/topk artifacts ==="
  find /project/nlp-work11/$USER/theorem_generation -maxdepth 4 -type f \
    \( -name '*cslib*' -o -name '*physlib*' -o -name '*simplegraph*' -o -name '*topk*' \) \
    2>/dev/null | sort | head -n 200
} | tee "$OUT"

echo
echo "saved: $OUT"
