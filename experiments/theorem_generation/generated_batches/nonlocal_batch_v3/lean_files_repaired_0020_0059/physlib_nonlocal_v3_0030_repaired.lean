import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.PlaneNonSols

open Classical

noncomputable
lemma SMRHN.PlusU1.ElevenPlane.eleven_plane_solution_is_zero
  (f : Fin 11 → ℚ)
  (hf : (PlusU1 3).IsSolution
    (∑ i, f i • (SMRHN.PlusU1.ElevenPlane.eleven_dim_plane_of_no_sols_exists).choose i)) :
  ∑ i, f i • (SMRHN.PlusU1.ElevenPlane.eleven_dim_plane_of_no_sols_exists).choose i = 0 :=
by
  obtain ⟨B11, hB11li, hB11nosol⟩ :=
    SMRHN.PlusU1.ElevenPlane.eleven_dim_plane_of_no_sols_exists
  -- the `choose` in the statement is this `B11`
  have hB11_eq :
      (SMRHN.PlusU1.ElevenPlane.eleven_dim_plane_of_no_sols_exists).choose = B11 :=
    rfl
  -- rewrite everything in terms of `B11` and apply the `no_sols` property
  have hf' : (PlusU1 3).IsSolution (∑ i, f i • B11 i) := by
    simpa [hB11_eq] using hf
  have hzero : ∑ i, f i • B11 i = 0 := hB11nosol f hf'
  simpa [hB11_eq] using hzero
