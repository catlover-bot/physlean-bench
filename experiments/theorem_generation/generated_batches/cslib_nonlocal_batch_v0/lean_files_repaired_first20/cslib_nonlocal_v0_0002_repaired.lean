import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.HasTau

open HasTau

theorem cslib_nonlocal_candidate_0002
    {State₁ State₂ Label : Type _} [HasTau Label]
    {r : State₁ → State₂ → Prop}
    {lts₁ : Cslib.LTS.LTS State₁ Label} {lts₂ : Cslib.LTS.LTS State₂ Label}
    (hswb : Cslib.LTS.IsSWBisimulation lts₁ lts₂ r)
    {s₁ : State₁} {s₂ s₂' : State₂}
    (hr : r s₁ s₂) (hstep : lts₂.STr s₂ HasTau.τ s₂') :
    ∃ s₁', lts₁.τSTr s₁ s₁' ∧ r s₁' s₂' := by
  have hτ₂ : lts₂.τSTr s₂ s₂' :=
    (Cslib.LTS.sTr_τSTr (lts := lts₂)).mp hstep
  simpa using hswb.follow_internal_snd hr hτ₂
