import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.One.Lemmas

lemma SM.SMNoGrav.One.accGrav_eq_accCube
    (S₁ : (SM.SMNoGrav 1).Sols) (Sₙ : (SM.SMNoGrav n).Sols) :
    accGrav S₁.val = accCube Sₙ.val :=
by
  have h₁ : accGrav S₁.val = 0 := SM.SMNoGrav.One.accGravSatisfied
  have h₂ : accCube Sₙ.val = 0 := SM.SMNoGrav.cubeSol Sₙ
  simpa [h₁, h₂]
