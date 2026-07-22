import Mathlib.Data.Fintype.Card
import Physlib.QFT.QED.AnomalyCancellation.Even.BasisLinear

lemma PureU1.VectorLikeEvenPlane.basisa_card
    (n : ℕ) :
    Fintype.card ((Fin n.succ) ⊕ (Fin n.succ)) =
      Fintype.card ((Fin n.succ) ⊕ (Fin n.succ)) := by
  rfl
