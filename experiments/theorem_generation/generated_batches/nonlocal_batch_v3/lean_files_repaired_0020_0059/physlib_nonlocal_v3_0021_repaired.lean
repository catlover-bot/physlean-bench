import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.One.Lemmas

lemma SM.SMNoGrav.One.E_zero_of_Q_zero
    (S : (SMNoGrav 1).Sols)
    (hQ : SM.SMNoGrav.One.Q S (0 : Fin 1) = 0) :
    SM.SMNoGrav.One.E S (0 : Fin 1) = 0 :=
by
  have hEiff := SM.SMNoGrav.One.E_zero_iff_Q_zero (S := S)
  exact (hEiff).1 hQ
