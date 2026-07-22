import Physlib.QFT.QED.AnomalyCancellation.Odd.LineInCubic
import Physlib.QFT.QED.AnomalyCancellation.Even.LineInCubic

lemma PureU1.lineInCubicPerm_even_iff_odd_zero
  {n : ℕ}
  {S₁ : (PureU1 (2 * n.succ.succ + 1)).LinSols}
  {S₂ : (PureU1 (2 * n.succ.succ)).LinSols}
  (h₁ : S₁ = 0)
  (h₂ : LineInPlaneCond S₂) :
  (∃ LIC₁ : LineInCubicPerm S₁, S₁ = 0) ∧ (∃ LIC₂ : LineInCubicPerm S₂, LineInPlaneCond S₂) :=
by
  refine And.intro ?hodd ?heven
  · refine ⟨?LIC₁, rfl⟩
    have : S₁ = 0 := h₁
    subst this
    have : LineInCubicPerm (0 : (PureU1 (2 * n.succ.succ + 1)).LinSols) := by
      classical
      exact (by
        have h := PureU1.Odd.lineInCubicPerm_zero
        have h' := h (n := n)
        exact False.elim (by
          have : (0 : (PureU1 (2 * n.succ.succ + 1)).LinSols) = 0 := rfl
          exact False.elim (by cases this)))
    exact this
  · refine ⟨?LIC₂, h₂⟩
    classical
    have : LineInPlaneCond S₂ := h₂
    have : LineInCubicPerm S₂ := by
      classical
      have h := PureU1.Even.lineInCubicPerm_last_perm (n := n) (S := S₂)
      have : LineInPlaneCond S₂ := h₂
      exact False.elim (by cases this)
    exact this
