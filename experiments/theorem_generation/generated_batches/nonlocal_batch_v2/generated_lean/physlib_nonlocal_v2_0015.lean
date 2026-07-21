import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.Basic
import Physlib.Particles.BeyondTheStandardModel.RHN.AnomalyCancellation.PlusU1.BMinusL
import Mathlib.Data.Rat.Basic
import Mathlib.Algebra.Module.Basic
import Mathlib.Tactic

lemma SMRHN.PlusU1.quadSol_eq_BL_add_quad
    (S : (PlusU1 n).QuadSols) :
    accQuad S.val = accQuad (1 • S.val + 0 • (BL n).val) :=
by
  have h₁ : accQuad S.val = 0 := SMRHN.PlusU1.quadSol (n:=n) S
  have h₂ : accQuad (1 • S.val + 0 • (BL n).val) = 0 :=
    SMRHN.PlusU1.BL.add_quad (n:=n) S 1 0
  simpa [h₁, h₂]
