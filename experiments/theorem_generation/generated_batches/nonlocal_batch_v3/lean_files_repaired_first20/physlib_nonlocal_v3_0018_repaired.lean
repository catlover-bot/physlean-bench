import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.HyperCharge

lemma SMRHN.PlusU1.Y.add_AFL_quad
    (n : ℕ) (S : (PlusU1 n).LinSols) (a b c : ℚ) :
    SMνACCs.accQuad (a • S.val + b • (Y n).val + c • (BL n).val) =
      a ^ 2 * SMνACCs.accQuad S.val :=
by
  have hY := SMRHN.PlusU1.Y.add_AFL_quad (n := n) S a b
  have hBL := SMRHN.PlusU1.BL.add_quad (n := n) (Q := ⟨a • S.val + b • (Y n).val, by
    have h0 := SMRHN.PlusU1.BL.add_quad (n := n) (Q := ⟨S.val, by
      exact S.property⟩) (a := 0) (b := 0)
    simpa using h0⟩) (a := 1) (b := c)
  have : SMνACCs.accQuad (a • S.val + b • (Y n).val + c • (BL n).val) =
      SMνACCs.accQuad (a • S.val + b • (Y n).val) :=
  by
    have hBL0 := SMRHN.PlusU1.BL.add_quad (n := n)
      (Q := ⟨a • S.val + b • (Y n).val, by
        have h0 := SMRHN.PlusU1.BL.add_quad (n := n) (Q := ⟨S.val, by
          exact S.property⟩) (a := 0) (b := 0)
        simpa using h0⟩) (a := 1) (b := 0)
    have h1 : SMνACCs.accQuad (1 • (a • S.val + b • (Y n).val)) =
              SMνACCs.accQuad (a • S.val + b • (Y n).val) := by
      simpa using rfl
    have h2 : SMνACCs.accQuad (1 • (a • S.val + b • (Y n).val) + c • (BL n).val) =
              SMνACCs.accQuad (1 • (a • S.val + b • (Y n).val)) := by
      simpa using hBL
    have h3 : a • S.val + b • (Y n).val + c • (BL n).val =
              1 • (a • S.val + b • (Y n).val) + c • (BL n).val := by
      simp
    calc
      SMνACCs.accQuad (a • S.val + b • (Y n).val + c • (BL n).val)
          = SMνACCs.accQuad (1 • (a • S.val + b • (Y n).val) + c • (BL n).val) := by
              simpa [h3]
      _ = SMνACCs.accQuad (1 • (a • S.val + b • (Y n).val)) := h2
      _ = SMνACCs.accQuad (a • S.val + b • (Y n).val) := h1
  simpa [this] using hY
