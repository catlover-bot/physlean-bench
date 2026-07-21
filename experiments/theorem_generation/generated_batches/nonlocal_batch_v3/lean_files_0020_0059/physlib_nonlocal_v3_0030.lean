import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BoundPlaneDim
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.PlaneNonSols
import LinearAlgebra.Basis
import LinearAlgebra.DirectSum.Finsupp

open Classical BigOperators

noncomputable
lemma SMRHN.PlusU1.exists_plane_basis_with_no_sols_on_left
  {n : ℕ} (hE : ExistsPlane n) :
  ∃ (B : (Fin 11 ⊕ Fin n) → (PlusU1 3).Charges),
    LinearIndependent ℚ B ∧
      ∀ (f : Fin 11 → ℚ),
        (PlusU1 3).IsSolution (∑ i, f i • B (Sum.inl i)) →
        ∑ i, f i • B (Sum.inl i) = 0 :=
by
  obtain ⟨Bplane, hBplane⟩ := SMRHN.PlusU1.exists_plane_exists_basis (n := n) hE
  classical
  obtain ⟨B11, hB11li, hB11nosol⟩ :=
    SMRHN.PlusU1.ElevenPlane.eleven_dim_plane_of_no_sols_exists
  refine ⟨_, ?_, ?_⟩
  · have hdisj : Disjoint (Set.range (fun i : Fin 11 => Sum.inl i))
      (Set.range (fun j : Fin n => Sum.inr j)) := by
        refine Set.disjoint_left.mpr ?_
        intro x hx11 hxn
        rcases hx11 with ⟨i, rfl⟩
        rcases hxn with ⟨j, h⟩
        cases h
  -- Build a new family that agrees with Bplane but whose left block is replaced by B11
    let Bnew : Fin 11 ⊕ Fin n → (PlusU1 3).Charges :=
      fun ij =>
        match ij with
        | Sum.inl i => B11 i
        | Sum.inr j => Bplane (Sum.inr j)
    have hBnewli : LinearIndependent ℚ Bnew :=
    by
      have hLi11 : LinearIndependent ℚ (fun i : Fin 11 => Bnew (Sum.inl i)) := by
        simpa using hB11li
      have hLin : LinearIndependent ℚ (fun j : Fin n => Bnew (Sum.inr j)) := by
        have : (fun j : Fin n => Bnew (Sum.inr j)) =
            fun j : Fin n => Bplane (Sum.inr j) := rfl
        simpa [this] using
          (hBplane.comp (fun j : Fin n => Sum.inr j))
      -- use linear independence on disjoint index union
      -- turn into linear independent on sum index
      classical
      have hUnion :
        LinearIndependent ℚ
          (fun ij : Fin 11 ⊕ Fin n =>
            match ij with
            | Sum.inl i => Bnew (Sum.inl i)
            | Sum.inr j => Bnew (Sum.inr j)) :=
      by
        refine hLi11.sum_type hLin ?_
        intro i j hij
        have : (Bnew (Sum.inl i)) ≠ (Bnew (Sum.inr j)) := by
          intro h
          -- derive contradiction via linear independence of Bplane
          have hDep :
            (1 : ℚ) • Bplane (Sum.inr j)
              + (-1 : ℚ) • Bplane (Sum.inr j) = 0 := by
              simp
          exact one_ne_zero (by simp [Bnew] at h)
        exact this
      simpa using hUnion
    exact hBnewli
  · intro f hf
    have hf' : (PlusU1 3).IsSolution (∑ i, f i • B11 i) := by
      simpa [Bplane, hBplane] using hf
    have hzero : ∑ i, f i • B11 i = 0 := hB11nosol f hf'
    simpa [Bplane, hBplane] using hzero
