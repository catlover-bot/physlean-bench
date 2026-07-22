import Cslib.Foundations.Control.Monad.Free.Effects
import Cslib.Foundations.Control.Monad.Free

open Cslib

@[simp]
theorem FreeM.FreeState.FreeWriter.liftM_toWriterT_pure
    {ω : Type u} [Monoid ω]
    {F : Type u → Type u} {m : Type u → Type u}
    [Monad m]
    (interp : {ι : Type u} → F ι → m ι) (a : α) :
    (FreeM.FreeState.FreeWriter.toWriterT
        (FreeM.pure (F := F) a : FreeState (FreeWriter ω) α)).run
      = pure (FreeM.FreeState.FreeWriter.run (FreeM.pure (F := F) a)) :=
by
  -- Simplify `toWriterT` on a pure value using `run_toWriterT`
  simpa using
    (FreeM.FreeState.FreeWriter.run_toWriterT
      (α := α) (ω := ω) (comp := FreeM.pure (F := F) a))
