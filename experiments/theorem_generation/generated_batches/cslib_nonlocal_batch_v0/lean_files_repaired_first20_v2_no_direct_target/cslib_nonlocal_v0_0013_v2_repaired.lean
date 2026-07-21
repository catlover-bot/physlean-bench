import Cslib.Foundations.Data.OmegaSequence.Flatten

open Cslib

lemma cslib_nonlocal_candidate_v2_0013
    {α : Type _} (s : ωSequence (List α)) (n : ℕ) :
    (ωSequence.flatten s) n ∈ s (ωSequence.segment (ωSequence.cumLen s) n) :=
by
  classical
  -- Use the definition of `flatten` at index `n`
  obtain ⟨hlen, k, hk, hk', rfl⟩ := ωSequence.flatten_def s n
  -- Now the goal is `[k]! ∈ s _`, which is immediate by `List.get_mem`
  simpa using List.get_mem (l := s (ωSequence.segment (ωSequence.cumLen s) n))
                           (i := k)
