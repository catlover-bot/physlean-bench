import Physlib.Units.Integral
import Physlib.Units.UnitDependent
import Mathlib.MeasureTheory/Measure/MeasureSpace

lemma scaleUnit_measure_apply_fst
  {M : Type _} [MeasurableSpace M] (u : UnitChoices) (μ : MeasureTheory.Measure UnitChoices) :
  scaleUnit u u (scaleUnit u u μ) = μ := by
  have h₁ := scaleUnit_measure u u μ
  have h₂ := scaleUnit_measure u u (scaleUnit u u μ)
  simp [h₁, h₂, UnitChoices.scaleUnit_apply_fst]
