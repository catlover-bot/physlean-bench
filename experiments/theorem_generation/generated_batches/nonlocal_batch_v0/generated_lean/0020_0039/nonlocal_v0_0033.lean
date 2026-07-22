import Cslib.Foundations.Semantics.LTS.HasTau
import Cslib.Foundations.Semantics.LTS.Basic

open Set

variable {State Label : Type _} [HasTau Label]

theorem Cslib.LTS.mem_setImage_iff_STr {lts : Cslib.LTS.StateLabel.LTS State Label} {S : Set State} {μ : Label} {s' : State} :
    s' ∈ lts.setImage S μ ↔ ∃ s ∈ S, lts.STr s μ s' := by
  constructor
  · intro h
    rcases (Cslib.LTS.mem_setImage (lts := lts) (S := S) (μ := μ) (s' := s')).1 h with ⟨s, hsS, hTr⟩
    exact ⟨s, hsS, (Cslib.LTS.STr.single (lts := lts) hTr)⟩
  · intro h
    rcases h with ⟨s, hsS, hSTr⟩
    cases hSTr with
    | single hTr =>
        exact (Cslib.LTS.mem_setImage (lts := lts) (S := S) (μ := μ) (s' := s')).2 ⟨s, hsS, hTr⟩
