import Mathlib.Data.Nat.Interval
import Mathlib.Data.Set.LocallyFinite
import Cslib.Foundations.Data.OmegaSequence.InfOcc
import Cslib.Foundations.Data.Nat.Segment

theorem Nat.infinite_strictMono_iff_omega_strictMono {ns : Set ℕ} :
    (∃ f : ℕ → ℕ, StrictMono f ∧ range f = ns) ↔ (∃ φ : ℕ → ℕ, StrictMono φ ∧ range φ = ns) := by
  constructor
  · intro h
    rcases h with ⟨f, hf_mono, hf_range⟩
    refine ⟨f, hf_mono, hf_range⟩
  · intro h
    rcases h with ⟨φ, hφ_mono, hφ_range⟩
    refine ⟨φ, hφ_mono, hφ_range⟩
