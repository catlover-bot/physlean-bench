import Cslib.Foundations.Data.OmegaSequence.Flatten

open Cslib

theorem cslib_nonlocal_candidate_0005
    {α : Type} (xs : ωSequence (List α)) (n : ℕ) :
    (xs.extract (xs.cumLen n) (xs.cumLen (n + 1))) = xs n := by
  simpa using ωSequence.extract_flatten xs n
