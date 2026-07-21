import Cslib.Foundations.Control.Monad.Free.Effects
import Cslib.Foundations.Control.Monad.Free

lemma cslib_nonlocal_candidate_0010
    {F : Type u → Type v} [Functor F]
    {ι α β : Type u}
    (op : F ι) (cont : ι → FreeM F α) (f : α → FreeM F β) :
    Cslib.FreeM.liftBind op (fun i => cont i >>= f)
    =
    Cslib.FreeM.liftBind op cont >>= fun x => Cslib.FreeM.liftBind op (fun _ => f x) :=
by
  simpa [Cslib.FreeM.liftBind_bind op cont f]
