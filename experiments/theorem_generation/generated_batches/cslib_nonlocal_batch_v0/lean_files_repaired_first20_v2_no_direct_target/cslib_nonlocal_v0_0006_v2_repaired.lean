import Cslib.Languages.CombinatoryLogic.Evaluation
import Cslib.Foundations.Data.Relation

theorem cslib_nonlocal_candidate_v2_0006
  (R : α → α → Prop) (x : α) :
  Relation.Normal R x →
  (∀ y : α, R x y → False) :=
by
  intro h
  intro y hy
  have hx := Relation.Normal_iff.mp h
  exact hx y hy
