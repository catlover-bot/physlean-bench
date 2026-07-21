import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.One.Lemmas

lemma SM.SMNoGrav.One.accGravSatisfied_val
    (S₁ : (SM.SMNoGrav 1).Sols) :
    SM.accGrav S₁.val = 0 :=
SM.SMNoGrav.One.accGravSatisfied S₁
