import Physlib.QFT.QED.AnomalyCancellation.Odd.LineInCubic
import Physlib.QFT.QED.AnomalyCancellation.Even.LineInCubic

lemma PureU1.lineInCubicPerm_odd_zero_of_even_plane
    {n : ℕ}
    {S₁ : (PureU1 (2 * n.succ.succ + 1)).LinSols}
    {S₂ : (PureU1 (2 * n.succ.succ)).LinSols}
    (h : (PureU1.Even.toOddLinSols S₂) = S₁)
    (LIC₁ : LineInCubicPerm S₁)
    (LIC₂ : LineInCubicPerm S₂) :
    S₁ = 0 :=
by
  have h_plane : LineInPlaneCond S₂ := PureU1.Even.lineInCubicPerm_last_perm (n := n) LIC₂
  have h_zero : S₁ = 0 := PureU1.Odd.lineInCubicPerm_zero (n := n) LIC₁
  exact h_zero
