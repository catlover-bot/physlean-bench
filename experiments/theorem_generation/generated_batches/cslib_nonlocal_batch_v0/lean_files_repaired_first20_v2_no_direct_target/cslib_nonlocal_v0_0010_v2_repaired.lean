import Cslib.Foundations.Control.Monad.Free.Effects
import Cslib.Foundations.Control.Monad.Free

lemma cslib_nonlocal_candidate_v2_0010
    {F : Type u → Type v} [Functor F]
    {ι α β γ : Type u}
    (op : F ι)
    (cont : ι → Cslib.FreeM F α)
    (f : α → Cslib.FreeM F β)
    (g : β → Cslib.FreeM F γ) :
    Cslib.FreeM.liftBind op (fun i => cont i >>= fun x => f x >>= g)
    =
    Cslib.FreeM.liftBind op cont >>= fun x => Cslib.FreeM.liftBind op (fun _ => f x >>= g) :=
by
  -- expand the right-hand side using the distributivity of `liftBind` over `>>=`
  have h₁ :
      Cslib.FreeM.liftBind op cont >>= fun x => Cslib.FreeM.liftBind op (fun _ => f x >>= g)
      =
      Cslib.FreeM.liftBind op (fun i => cont i >>= fun x => f x >>= g) :=
    by
      -- apply `liftBind` interaction with bind twice, using associativity internally
      simpa [Bind.bind, Cslib.FreeM.bind,
             Cslib.FreeM.liftBind_bind (op := op) (cont := cont) (f := fun x => f x >>= g),
             Bind.bind, Cslib.FreeM.bind]
  -- conclude by symmetry of equality
  simpa [h₁]
