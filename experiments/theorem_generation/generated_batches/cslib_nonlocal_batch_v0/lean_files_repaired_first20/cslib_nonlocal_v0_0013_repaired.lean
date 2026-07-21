import Cslib.Foundations.Data.OmegaSequence.Flatten

lemma cslib_nonlocal_candidate_0013
    {α : Type _} (xs : ℕ → List α) (n : ℕ) :
    (ωSequence.flatten xs) n =
      (xs (ωSequence.segment (fun k => (xs k).length) n))
        [n - ωSequence.cumLen (fun k => (xs k).length)
              (ωSequence.segment (fun k => (xs k).length) n)] :=
by
  simpa [ωSequence.flatten_def]
