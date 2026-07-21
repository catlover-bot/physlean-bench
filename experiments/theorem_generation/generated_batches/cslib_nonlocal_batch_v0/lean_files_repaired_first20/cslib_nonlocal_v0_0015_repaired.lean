import Cslib.Foundations.Control.Monad.Free

open Cslib

@[simp]
theorem cslib_nonlocal_candidate_0015
    {F : Type u → Type u} [Functor F]
    {m : Type u → Type v} [Monad m]
    (interp : {α : Type u} → F α → m α)
    {α : Type u} (a : α) :
    FreeM.liftM interp (FreeM.pure (F := F) a) = (pure a : m α) :=
by
  -- `FreeM.liftM` coincides with `pure` on `FreeM.pure` by the monad law
  simpa using (FreeM.liftM_pure (F := F) (m := m) (interp := interp) (a := a))
