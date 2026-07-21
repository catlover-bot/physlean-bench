import Cslib.Foundations.Data.OmegaSequence.Flatten

open ωSequence

theorem cslib_nonlocal_candidate_v2_0005
    {α : Type} (xs : ωSequence (List α))
    (hpos : ∀ k, (xs k).length > 0) :
    ∀ k, (extract (flatten xs) (cumLen xs k) (cumLen xs (k + 1))).length = (xs k).length := by
  intro k
  -- use the library lemma about extracting from the flattened sequence
  simpa using ωSequence.extract_flatten xs hpos k
