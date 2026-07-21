import Cslib.Foundations.Semantics.LTS.OmegaExecution
import Cslib.Foundations.Data.OmegaSequence.Flatten

open scoped BigOperators

namespace Cslib

variable {Label State : Type} [Inhabited Label]

namespace LTS

/--
In an infinite execution built by `OmegaExecution.flatten_execution`, the segment of
the state sequence corresponding to the `k`-th local execution is nonempty.

This bridges `OmegaExecution.flatten_execution` (from the LTS semantics side) with
`ωSequence.cumLen_strictMono` (from the sequence/length side) via `cumLen` and `extract`.
-/
theorem OmegaExecution.segment_states_nonempty
    {lts : LTS Label State}
    {ts : ωSequence State} {μls : ωSequence (List Label)} {sls : ωSequence (List State)}
    (hexec : ∀ k, lts.Execution (ts k) (μls k) (ts (k + 1)) (sls k))
    (hpos : ∀ k, (μls k).length > 0) :
    ∀ k, ∃ ss,
      lts.OmegaExecution ss μls.flatten ∧
      (ss.extract (μls.cumLen k) (μls.cumLen (k + 1))).length > 0 := by
  intro k
  obtain ⟨ss, hOmega, hseg⟩ :=
    OmegaExecution.flatten_execution (lts := lts) (ts := ts) (μls := μls) (sls := sls) hexec hpos
  refine ⟨ss, hOmega, ?_⟩
  -- use the segment equality from `flatten_execution`
  have hseg_eq :
      ss.extract (μls.cumLen k) (μls.cumLen (k + 1)) =
        (sls k).take (μls k).length :=
    hseg k
  -- lengths of equal lists are equal
  have hlen :
      (ss.extract (μls.cumLen k) (μls.cumLen (k + 1))).length =
        ((sls k).take (μls k).length).length := by
    simpa [hseg_eq]
  -- the `k`-th label segment is nonempty, hence so is the corresponding state segment
  have hμpos : (μls k).length > 0 := hpos k
  -- taking a positive number of elements yields a nonempty list
  have htake_pos :
      ((sls k).take (μls k).length).length > 0 := by
    -- `List.length_take` and monotonicity of `Nat.min` give the inequality
    have : ((sls k).take (μls k).length).length =
        min (sls k).length (μls k).length := by
      simpa using (List.length_take (μls k).length (sls k))
    -- `min_le_right` and `hμpos` imply the RHS is positive
    have hmin_pos : min (sls k).length (μls k).length > 0 := by
      -- `Nat.min_le_right` gives `min a b ≤ b`
      have hle : min (sls k).length (μls k).length ≤ (μls k).length :=
        Nat.min_le_right _ _
      exact lt_of_le_of_lt hle hμpos
    simpa [this]
  -- transport the positivity via length equality
  exact hlen ▸ htake_pos

end LTS

end Cslib
