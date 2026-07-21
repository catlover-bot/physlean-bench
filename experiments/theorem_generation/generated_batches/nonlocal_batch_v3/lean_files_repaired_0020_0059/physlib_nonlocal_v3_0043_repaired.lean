import Mathlib.Analysis.InnerProductSpace.Pi_L2
import Physlib.Mathematics.VariationalCalculus.IsTestFunction

lemma IsTestFunction.integrable
  {X U : Type _} [TopologicalSpace X] [OpensMeasurableSpace X]
  [MeasurableSpace X] (μ : Measure X) [IsFiniteMeasureOnCompacts μ]
  [NormedAddCommGroup U] [InnerProductSpace ℝ U]
  {g : X → U} (hg : IsTestFunction g) :
  MeasureTheory.Integrable g μ :=
by
  simpa using IsTestFunction.integrable (X := X) (U := U) (μ := μ) hg
