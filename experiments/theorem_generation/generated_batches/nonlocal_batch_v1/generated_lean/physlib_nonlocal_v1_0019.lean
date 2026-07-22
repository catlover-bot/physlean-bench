import Physlib.QFT.QED.AnomalyCancellation.BasisLinear
import Physlib.QFT.QED.AnomalyCancellation.Even.BasisLinear

lemma PureU1.even_finrank_eq_basisa_card
    (n : ℕ) :
    Module.finrank ℚ (((PureU1 (2 * n.succ)).LinSols)) =
      Fintype.card ((Fin n.succ) ⊕ (Fin n)) :=
by
  simpa [eq_comm] using
    (PureU1.VectorLikeEvenPlane.basisa_card (n := n))
