import Physlib.QFT.QED.AnomalyCancellation.Odd.LineInCubic
import Physlib.QFT.QED.AnomalyCancellation.Even.LineInCubic

lemma PureU1.bridge_lineInCubicPerm_odd_even
  {n : ℕ}
  {S₁ : (PureU1 (2 * n.succ.succ + 1)).LinSols}
  {S₂ : (PureU1 (2 * n.succ.succ)).LinSols}
  (h₁ : PureU1.Odd.lineInCubicPerm_zero (n := n) (S := S₁))
  (h₂ : PureU1.Even.lineInCubicPerm_last_perm (n := n) (S := S₂)) :
  S₁ = 0 ∧ LineInPlaneCond S₂ :=
by
  refine And.intro ?hS₁ ?hS₂
  · exact h₁
  · exact h₂
