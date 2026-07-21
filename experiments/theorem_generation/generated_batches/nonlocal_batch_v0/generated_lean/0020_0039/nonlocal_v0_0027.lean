import Physlib.QFT.QED.AnomalyCancellation.Odd.LineInCubic
import Physlib.QFT.QED.AnomalyCancellation.Even.LineInCubic

theorem PureU1.lineInCubicPerm_zero_of_even_and_odd
  {n : ℕ}
  {Se : (PureU1 (2 * n.succ.succ)).LinSols}
  {So : (PureU1 (2 * n.succ.succ + 1)).LinSols}
  (LISe : LineInCubicPerm Se)
  (LISo : LineInCubicPerm So)
  (h : LineInPlaneCond Se)
  (hne : Se ≠ 0) :
  So = 0 :=
by
  have h' : So = 0 := PureU1.Odd.lineInCubicPerm_zero (n := n) LISo
  exact h'
