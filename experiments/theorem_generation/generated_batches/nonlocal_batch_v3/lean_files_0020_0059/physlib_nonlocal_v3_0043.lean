import Mathlib.MeasureTheory.Integral.InnerProductSpace
import Physlib.Mathematics.VariationalCalculus.Basic
import Physlib.Mathematics.VariationalCalculus.IsTestFunction

lemma testFunction_orthogonal_zero
  {Y V : Type _} [NormedAddCommGroup V] [InnerProductSpace ℝ V]
  [TopologicalSpace Y] [OpensMeasurableSpace Y] [MeasurableSpace Y]
  (μ : Measure Y) [IsFiniteMeasureOnCompacts μ] [μ.IsOpenPosMeasure]
  {f : Y → V} (hf : Continuous f)
  (horth : ∀ g : Y → V, IsTestFunction g → ∫ x, ⟪f x, g x⟫_ℝ ∂μ = 0)
  {g : Y → V} (hg : IsTestFunction g) :
  ∫ x, ⟪f x, g x⟫_ℝ ∂μ = 0 :=
by
  have hconst : f = 0 :=
    fundamental_theorem_of_variational_calculus' (μ := μ) (f := f) hf horth
  have hfg : (fun x => ⟪f x, g x⟫_ℝ) = fun x => ⟪0, g x⟫_ℝ := by
    funext x
    simpa [hconst]
  have hg_int : MeasureTheory.Integrable g μ :=
    IsTestFunction.integrable (X := Y) (U := V) hg μ
  have hzero : (fun x => ⟪0, g x⟫_ℝ) = fun _ => (0 : ℝ) := by
    funext x
    simp
  simpa [hfg, hzero]
