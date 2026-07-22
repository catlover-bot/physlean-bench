import Cslib.Foundations.Semantics.LTS.Bisimulation
import Cslib.Foundations.Semantics.LTS.HasTau

open HasTau

namespace Cslib.LTS

variable {State₁ State₂ Label : Type _} [HasTau Label]

/--
If `hswb` is a strong weak bisimulation between `lts₁` and `lts₂`, and `hrs : r s₁ s₂`
relates the states `s₁` and `s₂`, then a single silent transition (label `τ`) in `lts₂`
from `s₂` to `s₂'` can be matched in `lts₁` by a (possibly multi-step) silent
transition sequence `τSTr` from `s₁` to some `s₁'` that is still related to `s₂'`.
This is just `IsSWBisimulation.follow_internal_snd` restated using ordinary
labelled transitions and the characterization of `τSTr` in terms of `STr` and `τ`.
-/
theorem IsSWBisimulation.follow_internal_snd_sTr
    {lts₁ : LTS State₁ Label} {lts₂ : LTS State₂ Label}
    (hswb : IsSWBisimulation lts₁ lts₂ r) {s₁ s₁' : State₁} {s₂ s₂' : State₂}
    (hr : r s₁ s₂) (hstep : lts₂.STr s₂ τ s₂') :
    ∃ s₁', lts₁.τSTr s₁ s₁' ∧ r s₁' s₂' := by
  -- Convert the τ-labelled step in `lts₂` into a `τSTr` step
  have hτ₂ : lts₂.τSTr s₂ s₂' :=
    (sTr_τSTr (lts := lts₂)).mp hstep
  -- Apply the existing bisimulation lemma on τSTr
  simpa using hswb.follow_internal_snd hr hτ₂

end Cslib.LTS
