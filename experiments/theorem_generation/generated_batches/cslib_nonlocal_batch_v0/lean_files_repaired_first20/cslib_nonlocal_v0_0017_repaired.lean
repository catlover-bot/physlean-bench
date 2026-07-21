import Cslib.Languages.CombinatoryLogic.Evaluation
import Cslib.Languages.CombinatoryLogic.Defs

theorem cslib_nonlocal_candidate_0017
    {x y : Cslib.SKI.SKI}
    (h : x.RedexFree)
    (hxy : x ↠ y) :
    x ≠ Cslib.SKI.Red.mk y := by
  have hy : y.RedexFree := by
    exact (Cslib.SKI.redexFree_of_mred_of_redexFree hxy h)
  intro hEq
  have : (Cslib.SKI.Red.mk y).IsRedex := Cslib.SKI.Red.isRedex_mk y
  have hNot : ¬ (Cslib.SKI.Red.mk y).IsRedex := by
    have := Cslib.SKI.redexFree_iff_no_redex.mp hy
    exact this (Cslib.SKI.Red.mk y) rfl
  exact hNot (this.trans ?_)
  simpa [hEq]
