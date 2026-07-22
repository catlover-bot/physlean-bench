import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.One.Lemmas
import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.Basic

lemma SM.SMNoGrav.cubeSol_one {S : (SMNoGrav 1).Sols} :
    SM.SMNoGrav.cubeSol (n := 1) S = 0 := by
  simpa using (SM.SMNoGrav.cubeSol (n := 1) S)
