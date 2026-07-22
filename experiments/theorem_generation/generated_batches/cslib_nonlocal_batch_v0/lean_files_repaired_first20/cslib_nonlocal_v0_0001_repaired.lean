import Cslib.Foundations.Semantics.LTS.HasTau

open HasTau

variable {State Label : Type _} [HasTau Label]

theorem cslib_nonlocal_candidate_0001
    (lts : HasTau.LTS State Label) {s s' : State} :
    lts.STr s τ s' → lts.τSTr s s' := by
  intro h
  exact (HasTau.sTr_τSTr (lts := lts) (s := s) (s' := s')).1 h
