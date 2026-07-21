import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.HasTau

open HasTau

variable {State₁ State₂ Label : Type _} [HasTau Label]

theorem cslib_nonlocal_candidate_v2_0001
    {lts₁ : Cslib.LTS State₁ Label} {lts₂ : Cslib.LTS State₂ Label}
    {r : State₁ → State₂ → Prop} {s₁ s₁' : State₁} {s₂ : State₂}
    (hswb : Cslib.LTS.IsSWBisimulation lts₁ lts₂ r)
    (hr : r s₁ s₂)
    (hstr : lts₁.STr s₁ τ s₁') :
    ∃ s₂', lts₂.τSTr s₂ s₂' ∧ r s₁' s₂' := by
  have hτ₁ : lts₁.τSTr s₁ s₁' := by
    exact (Cslib.LTS.sTr_τSTr (lts := lts₁) (s := s₁) (s' := s₁')).1 hstr
  exact Cslib.LTS.IsSWBisimulation.follow_internal_fst hswb hr hτ₁
