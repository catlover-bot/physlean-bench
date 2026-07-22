import Cslib.Foundations.Data.OmegaSequence.Basic

open Cslib

theorem cslib_nonlocal_candidate_0014
    {α : Type} (xs : ωSequence (List α)) (hpos : ∀ n : ℕ, (xs n).length > 0) :
    StrictMono (fun n => xs.cumLen n) := by
  intro m n hmn
  -- Use the standard `StrictMono` characterization on `ℕ`
  have hle : xs.cumLen m + (xs n).length ≤ xs.cumLen n := by
    -- `cumLen` is monotone, and `xs.cumLen (n+1) = xs.cumLen n + (xs n).length`
    have hmono : Monotone xs.cumLen := ωSequence.cumLen_mono xs
    have hle' : xs.cumLen (n + 1) ≤ xs.cumLen n := by
      exact hmono (Nat.le_of_lt_succ hmn)
    -- But `xs.cumLen (n+1) = xs.cumLen n + (xs n).length`
    have hstep : xs.cumLen (n + 1) = xs.cumLen n + (xs n).length :=
      ωSequence.cumLen_succ xs n
    -- Rewrite and use `hle'`
    have : xs.cumLen n + (xs n).length ≤ xs.cumLen n := by
      simpa [hstep] using hle'
    exact this
  -- From `hpos n`, we know `(xs n).length ≥ 1`
  have hlen_pos : (xs n).length ≥ 1 := Nat.succ_le_of_lt (hpos n)
  -- Combine inequalities: `cumLen m + 1 ≤ cumLen m + (xs n).length ≤ cumLen n`
  have hlt : xs.cumLen m + 1 ≤ xs.cumLen n :=
    le_trans (Nat.add_le_add_left hlen_pos _) hle
  exact Nat.lt_of_le_of_lt hlt (Nat.lt_succ_self _)
