import Cslib.Foundations.Data.OmegaSequence.Flatten

open Cslib

theorem cslib_nonlocal_candidate_v2_0014
    {α : Type} (xs : ωSequence (List α)) :
    ∀ k : ℕ, (xs.cumLen k) < (xs.cumLen (k + 1)) ↔ (xs (k + 1)).length > 0 := by
  intro k
  constructor
  · intro hlt
    have hmono := ωSequence.cumLen_strictMono xs k
    -- `hlt` plus strict monotonicity forces strict increase at step `k`
    have hle : xs.cumLen (k + 1) ≤ xs.cumLen (k + 2) := by
      exact Nat.le_of_lt (hmono (Nat.lt_succ_self _))
    -- now relate the step `(k+1) → (k+2)` to the length of `xs (k+1)`
    have hstep := ωSequence.cumLen_succ xs (k + 1)
    -- `cumLen (k+2) = cumLen (k+1) + length (xs (k+1))`
    have : xs.cumLen (k + 1) < xs.cumLen (k + 1) + (xs (k + 1)).length := by
      have := Nat.lt_of_lt_of_le hlt hle
      simpa [ωSequence.cumLen_succ] using this
    -- conclude the length is positive
    exact Nat.lt_of_lt_of_le
      (Nat.lt_of_add_lt_add_left this)
      (Nat.le_of_lt_succ (Nat.lt_succ_self _))
  · intro hpos
    -- direct computation using the `succ` formula
    simpa [ωSequence.cumLen_succ, Nat.add_comm, Nat.add_left_comm, Nat.add_assoc,
      Nat.lt_add_iff_pos_right] using hpos
