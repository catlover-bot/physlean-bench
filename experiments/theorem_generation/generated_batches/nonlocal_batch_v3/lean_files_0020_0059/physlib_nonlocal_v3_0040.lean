import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.One.Lemmas
import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.Basic

lemma SM.SMNoGrav.accGrav_add_cube_zero
    {S₁ : (SMNoGrav 1).Sols} {S₂ : (SMNoGrav 1).Sols} :
    accGrav S₁.val + accCube S₂.val = 0 := by
  have h₁ : accGrav S₁.val = 0 := SM.SMNoGrav.One.accGravSatisfied
  have h₂ : accCube S₂.val = 0 := by
    simpa using (SM.SMNoGrav.cubeSol (n := 1) S₂)
  simpa [h₁, h₂]
