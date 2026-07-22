import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.Basic

open Cslib.LTS

namespace Cslib.LTS

variable {State Label : Type} (lts : LTS State Label)

theorem MTr_of_single_trace_not_homBisimulation
  (h : ¬ IsHomBisimulation lts (HomTraceEq lts))
  {s₁ s₂ : State} {μ : Label}
  (ht : (HomTraceEq lts).Rel s₁ s₂)
  (htr : lts.Tr s₁ μ s₁) :
  ∃ s₂', lts.MTr s₂ [μ] s₂' :=
by
  -- Use the fact that `HomTraceEq` is a homomorphism-respecting relation
  -- on traces, together with the existence of a concrete transition `Tr`
  -- turned into a multi-step trace `MTr.single`.
  rcases ht with ⟨σ, hσ₁, hσ₂⟩
  -- From the trace equation and the concrete transition on s₁, we know
  -- that s₂ can perform the same single-labelled trace.
  have hM₁ : lts.MTr s₁ (σ ++ [μ]) s₁ := by
    -- first follow σ (possibly empty), then the single step μ
    clear h σ hσ₂
    revert s₁
    intro s
    induction σ with
    | nil =>
        intro s htr'
        simpa using (MTr.single (lts := lts) htr')
    | cons μ' σ ih =>
        intro s hM
        cases hM with
        | step hstep hrest =>
            specialize ih hrest
            simpa [List.cons_append] using
              MTr.step (lts := lts) hstep ih
  -- Now use the trace equality to transfer this multi-step trace to s₂.
  have hM₂ : ∃ s₂', lts.MTr s₂ (σ ++ [μ]) s₂' := by
    -- HomTraceEq ensures existence of matching traces from related states.
    exact (HomTraceEq.exists_MTr_of_MTr (lts := lts) hσ₂ hM₁)
  rcases hM₂ with ⟨s₂', hM₂'⟩
  -- Finally, σ was a common prefix; we only care about the final [μ] trace.
  -- Since (σ ++ [μ]) from s₂ exists, in particular there is a state after [μ].
  -- We can extract the suffix [μ] by standard decomposition of MTr.
  have : ∃ s₂'', lts.MTr s₂ [μ] s₂'' := by
    -- use general lemma about decomposition by suffix
    exact lts.MTr_exists_suffix_of_suffix_eq (α := Label) (s := s₂)
      (t := s₂') (u := [μ]) (v := σ) (by simp) hM₂'
  exact this

end Cslib.LTS
