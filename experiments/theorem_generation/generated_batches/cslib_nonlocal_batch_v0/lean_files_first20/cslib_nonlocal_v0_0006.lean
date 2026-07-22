import Cslib.Languages.CombinatoryLogic.Evaluation
import Cslib.Foundations.Data.Relation

theorem Cslib.SKI.RedexFree_iff_normal_form :
  ∀ x : SKI, x.RedexFree ↔ Normal SKIRed x :=
by
  intro x
  constructor
  · intro hx
    exact Cslib.SKI.RedexFree.normal_red hx
  · intro h
    -- unfold `Normal` and use `Relation.Normal_iff` instantiated with `SKIRed`
    have h' : ∀ y, ¬ SKIRed x y := (Relation.Normal_iff SKIRed x).1 h
    -- RedexFree means no one-step reduction is possible
    -- `RedexFree` is defined so that it is equivalent to there being no `SKIRed` successor
    -- We can use the characterization via `Relation.Normal_iff` in the SKI setting.
    -- By definition in the SKI evaluation development, this matches `RedexFree`.
    -- So we just use the same idea in the forward direction: if it weren't `RedexFree`,
    -- there would be a reduction step.
    -- Concretely, rewriting via the SKI-specific lemma:
    -- `RedexFree.normal_red` already shows the forward direction; the backward
    -- direction is exactly the contrapositive: if not `RedexFree`, there is a redex,
    -- i.e. a reduction step, contradicting normality.
    by_contra hnf
    -- From `¬ x.RedexFree` obtain existence of a reduction step, contradicting `h'`.
    -- This lemma is available in the SKI library as the contrapositive of
    -- `RedexFree.normal_red`, commonly given as `RedexFree.not_normal_iff`-style.
    -- Here we derive the contradiction directly using the SKI reduction structure.
    -- We destruct the definition of `RedexFree` to obtain a redex.
    rcases x with
    | S =>
      -- `S` is a normal form in SKI (no redex), contradiction to `¬ RedexFree`
      exact hnf (by infer_instance)
    | K =>
      exact hnf (by infer_instance)
    | I =>
      exact hnf (by infer_instance)
    | app f a =>
      -- If the application is not redex-free, then either it is itself a redex
      -- or one of its subterms reduces; in any case we obtain `SKIRed (app f a) _`.
      -- That contradicts `h'`.
      have : ∃ y, SKIRed (app f a) y := by
        classical
        -- exhaustive analysis on `f` to find the redex
        cases f <;> first
        | refine ⟨_, ?_⟩; simp [SKIRed]  -- head redex
        | refine ⟨_, ?_⟩; simp [SKIRed]  -- reduction in subterm
      rcases this with ⟨y, hy⟩
      exact (h' y) hy
