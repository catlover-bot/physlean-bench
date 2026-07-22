import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.HasTau

open HasTau

variable {State₁ State₂ Label : Type _} [HasTau Label]

theorem IsSWBisimulation.follow_internal_fst_sTr
    {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
    {r : State₁ → State₂ → Prop} {s₁ s₁' : State₁} {s₂ : State₂}
    (hswb : IsSWBisimulation lts₁ lts₂ r)
    (hr : r s₁ s₂)
    (hstr : lts₁.STr s₁ τ s₁') :
    ∃ s₂', lts₂.STr s₂ τ s₂' ∧ r s₁' s₂' := by
  -- Translate the strong τ-transition on lts₁ to a τSTr transition
  have hτ₁ : lts₁.τSTr s₁ s₁' :=
    (sTr_τSTr (lts := lts₁) (s := s₁) (s' := s₁')).1 hstr
  -- Use the silent-step bisimulation property on τSTr
  obtain ⟨s₂', hτ₂, hr'⟩ := IsSWBisimulation.follow_internal_fst hswb hr hτ₁
  -- Translate back the τSTr transition on lts₂ to a strong τ-transition
  have hstr₂ : lts₂.STr s₂ τ s₂' :=
    (sTr_τSTr (lts := lts₂) (s := s₂) (s' := s₂')).2 hτ₂
  exact ⟨s₂', hstr₂, hr'⟩
