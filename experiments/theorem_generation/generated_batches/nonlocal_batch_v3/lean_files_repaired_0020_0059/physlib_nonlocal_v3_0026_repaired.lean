import Physlib.Units.Integral
import Physlib.Units.UnitDependent

lemma UnitChoices.scaleUnit_apply_fst
  (u : UnitChoices) (x : UnitChoices × UnitChoices) :
  (u.scaleUnit u x).1 = x.1 := by
  -- `scaleUnit` only rescales the second component of the pair
  cases x with
  | mk a b =>
    -- now `x = (a, b)` and `scaleUnit` leaves `a` unchanged
    rfl
