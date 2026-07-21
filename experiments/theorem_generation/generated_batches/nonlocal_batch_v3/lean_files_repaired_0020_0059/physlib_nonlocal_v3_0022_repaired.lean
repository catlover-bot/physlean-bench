import Physlib.QFT.QED.AnomalyCancellation.LowDim.Three
import Physlib.QFT.QED.AnomalyCancellation.Basic
import Mathlib

lemma PureU1.pureU1_cube
  (S : (PureU1 3).Sols) :
  (S.val (0 : Fin 3)) ^ 3 = 0 ∨ (S.val (1 : Fin 3)) ^ 3 = 0 ∨ (S.val (2 : Fin 3)) ^ 3 = 0 :=
by
  simpa using PureU1.Three.three_sol_zero S
