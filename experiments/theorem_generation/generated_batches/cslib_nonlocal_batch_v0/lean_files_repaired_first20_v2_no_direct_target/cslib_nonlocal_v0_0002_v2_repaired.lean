import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.HasTau

open Cslib.LTS

variable {State₁ State₂ Label : Type _} [HasTau Label]

theorem cslib_nonlocal_candidate_v2_0002
    {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
    {r : State₁ → State₂ → Prop}
    (hswb : IsSWBisimulation lts₁ lts₂ r)
    {s₁ s₁₁ s₁₂ : State₁} {s₂ s₂' : State₂}
    (hr : r s₁ s₂)
    (hτ₁ : lts₁.τSTr s₁ s₁₁)
    (hstep : lts₂.STr s₂ HasTau.τ s₂')
    (hτ₂ : lts₁.τSTr s₁₁ s₁₂) :
    ∃ s₁', lts₁.τSTr s₁ s₁' ∧ r s₁' s₂' := by
  -- first, follow the internal τ-behavior on the second system
  obtain ⟨s₁', hτ₁', hr'⟩ :=
    hswb.follow_internal_snd hr
      ((IsSWBisimulation.sTr_τSTr (lts := lts₂)).mpr hstep)
  -- then compose the existing τ-trace from s₁ to s₁₁, the bisimulation τ-trace
  -- from s₁ to s₁', and the further τ-trace from s₁₁ to s₁₂ to obtain
  -- a single τ-trace from s₁ to a state still related to s₂'
  refine ⟨s₁', ?_, hr'⟩
  -- use transitivity of τSTr via its characterization with STr
  have hτ_all : lts₁.STr s₁ HasTau.τ s₁' :=
    (IsSWBisimulation.sTr_τSTr (lts := lts₁)).mp hτ₁'
  exact (IsSWBisimulation.sTr_τSTr (lts := lts₁)).mpr hτ_all
