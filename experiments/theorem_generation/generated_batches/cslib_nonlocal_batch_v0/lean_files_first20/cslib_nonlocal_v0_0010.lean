import Cslib.Foundations.Control.Monad.Free.Effects
import Cslib.Foundations.Control.Monad.Free

@[simp]
lemma Cslib.FreeM.FreeState.FreeWriter.FreeCont.run_liftBind_bind
    {F : Type u → Type v} [Functor F]
    {ι α β r : Type u}
    (op : F ι) (cont : ι → FreeM F α) (f : α → FreeM F β)
    (k : β → r) :
    Cslib.FreeM.FreeState.FreeWriter.FreeCont.run
      (Cslib.FreeM.liftBind op cont >>= fun x => Cslib.FreeM.liftBind op (fun _ => f x))
      k
    =
    Cslib.FreeM.FreeState.FreeWriter.FreeCont.run
      (Cslib.FreeM.liftBind op (fun i => cont i >>= f))
      k :=
by
  -- use associativity-like behavior from `run_bind`
  simpa [Bind.bind, Cslib.FreeM.bind, Cslib.FreeM.liftBind_bind op cont f]
