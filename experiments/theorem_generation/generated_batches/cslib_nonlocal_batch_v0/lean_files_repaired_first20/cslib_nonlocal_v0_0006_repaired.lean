import Cslib.Foundations.Data.Relation

lemma cslib_nonlocal_candidate_0006 {α : Type} {R : α → α → Prop} {x : α} :
  Relation.Normal R x ↔ (∀ y : α, R x y → False) :=
Relation.Normal_iff R x
