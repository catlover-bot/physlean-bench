import Physlib.QFT.QED.AnomalyCancellation.LowDim.Three
import Physlib.QFT.QED.AnomalyCancellation.Basic

lemma PureU1.pureU1_linear
  (S : (PureU1 3).LinSols)
  (hlin : ∑ i : Fin 3, S.val i = 0)
  (hcube : (PureU1 3).cubicACC S.val = 0) :
  S.val (0 : Fin 3) = 0 ∨ S.val (1 : Fin 3) = 0 ∨ S.val (2 : Fin 3) = 0 :=
by
  -- `cube_for_linSol` expresses that for linear solutions,
  -- vanishing cubic anomaly implies at least one charge is zero.
  exact (PureU1.Three.cube_for_linSol S).mpr hcube
