import Cslib.Foundations.Semantics.LTS.OmegaExecution
import Cslib.Foundations.Data.OmegaSequence.Flatten

open ωSequence

namespace Cslib
namespace LTS

variable {Label State : Type} [Inhabited Label]

/--
If we have an infinite family of executions stitched together into an `OmegaExecution`
whose state segments match the canonical `extract`-of-`flatten` decomposition of the
label sequence, then each segment’s state list has the same length as the corresponding
label list.

This bridges the semantic `OmegaExecution` decomposition with the generic
`ωSequence.extract_flatten` lemma on lists.
-/
theorem OmegaExecution.segment_state_length_eq_label_length
    {lts : LTS Label State}
    {ts : ωSequence State} {μls : ωSequence (List Label)} {sls : ωSequence (List State)}
    (hexec : ∀ k, lts.Execution (ts k) (μls k) (ts (k + 1)) (sls k))
    (hpos : ∀ k, (μls k).length > 0)
    (hslen : ∀ k, (sls k).length = (μls k).length) :
    ∃ ss, lts.OmegaExecution ss μls.flatten ∧
      ∀ k, (ss.extract (μls.cumLen k) (μls.cumLen (k + 1))).length = (μls k).length := by
  obtain ⟨ss, hOmega, hseg⟩ :=
    OmegaExecution.flatten_execution (ts := ts) (μls := μls) (sls := sls) hexec hpos
  refine ⟨ss, hOmega, ?_⟩
  intro k
  specialize hseg k
  -- `hseg` identifies the state segment with an initial segment of `sls k`;
  -- its length therefore matches the length of `μls k` via `hslen`.
  have := congrArg List.length hseg
  simpa [hslen k] using this

end LTS
end Cslib
