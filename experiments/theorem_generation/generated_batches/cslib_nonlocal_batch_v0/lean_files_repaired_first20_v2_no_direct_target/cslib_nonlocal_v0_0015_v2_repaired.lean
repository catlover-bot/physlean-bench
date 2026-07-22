import Cslib.Foundations.Control.Monad.Free

open Cslib

@[simp]
theorem cslib_nonlocal_candidate_v2_0015
    {F : Type u → Type u} {m : Type u → Type v}
    [Monad m]
    (interp : {α : Type u} → F α → m α)
    {α : Type u} (a : α) :
    FreeM.liftM interp (FreeM.pure (F := F) a) = (pure a : m α) :=
by
  -- unfold `liftM` on `pure` and simplify using monad laws
  -- `FreeM.liftM` is defined by recursion on `FreeM`; the `pure` case
  -- reduces to `pure`.
  simpa using (FreeM.liftM_pure (F := F) (m := m) (interp := interp) (a := a))
