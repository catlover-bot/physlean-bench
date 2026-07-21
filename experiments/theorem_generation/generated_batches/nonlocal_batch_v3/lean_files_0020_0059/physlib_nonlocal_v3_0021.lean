import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.NoGrav.One.Lemmas

lemma SM.SMNoGrav.one_E_zero_of_cubeSol_and_Q_zero
    (S : (SMNoGrav 1).Sols)
    (hS : accCube S.val = 0)
    (hQ : Q S.val (0 : Fin 1) = 0) :
    E S.val (0 : Fin 1) = 0 :=
by
  have hCube := SM.SMNoGrav.cubeSol (n := 1) S
  have hEiff := SM.SMNoGrav.One.E_zero_iff_Q_zero (S := S)
  have hE := (hEiff).1
  exact hE hQ
