import Physlib.QFT.PerturbationTheory.WickAlgebra.WicksTheorem
import Physlib.QFT.PerturbationTheory.WickAlgebra.WicksTheoremNormal

lemma FieldSpecification.wicks_theorem_normal_order_congr
    {𝓕 : FieldSpecification} (φs φs' : List 𝓕.FieldOp)
    (h : φs = φs') :
    𝓣 (𝓝 (ofFieldOpList φs)) =
      ∑ (φs'Λ : {φs'Λ : WickContraction φs'.length // ¬ HaveEqTime φs'Λ}), φs'Λ.1.wickTerm :=
by
  classical
  subst h
  simpa using FieldSpecification.WickAlgebra.wicks_theorem_normal_order
        (𝓕 := 𝓕) (φs := φs')
