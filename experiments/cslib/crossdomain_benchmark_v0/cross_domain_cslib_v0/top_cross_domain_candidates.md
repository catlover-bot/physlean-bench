# Top Physlib-internal cross-domain candidates

## 1. Cslib.Automata.NA.Buchi.inter_language_eq

- split: `test`
- file: `Cslib/Computability/Automata/NA/BuchiInter.lean`
- primary_domain: `Automata`
- domains: `Automata, FormalLanguage, OmegaSequence`
- used_premise_domains: `Automata, FormalLanguage, OmegaSequence`
- cross_domain_score: `6.00`
- evidence:
  - Automata: Cslib.Automata.ωAcceptor.language, Cslib.Automata.NA.Buchi.mk, Cslib.Automata.NA.Buchi.interNA, Cslib.Automata.NA.Buchi.interAccept, Cslib.Automata.NA.hist_run_proj, Cslib.Automata.NA.Buchi.inter_freq_acc_freq_acc, Cslib.Automata.NA.iProd, Cslib.Automata.NA.Run
  - FormalLanguage: Cslib.ωLanguage.mem_ext, Cslib.ωLanguage.mem_iInf
  - OmegaSequence: Cslib.ωSequence

```lean
theorem inter_language_eq :
    language (Buchi.mk (interNA na acc) (interAccept acc)) =
    ⨅ i, language (Buchi.mk (na i) (acc i)) :=
```

## 2. Cslib.ωSequence.cumLen_segment_one_add

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, LinearLogic, OmegaSequence`
- used_premise_domains: `LinearLogic, OmegaSequence`
- cross_domain_score: `6.00`
- evidence:
  - LinearLogic: le_add_iff_nonneg_left
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.cumLen, Cslib.ωSequence.cumLen_zero, Cslib.ωSequence.cumLen_one_add_drop

```lean
theorem cumLen_segment_one_add {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0)
    (n : ℕ) (h_n : (ls 0).length ≤ n) :
    segment ls.cumLen n = 1 + segment (ls.drop 1).cumLen (n - (ls 0).length) :=
```

## 3. Cslib.ωSequence.cons_flatten

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `6.00`
- evidence:
  - FormalLanguage: Cslib.ωSequence.flatten_def
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.flatten_def, Cslib.ωSequence.head.eq_1, Cslib.ωSequence.tail_eq_drop, Cslib.ωSequence.get_append_left, Cslib.ωSequence.cumLen_segment_zero, Cslib.ωSequence.cumLen_zero, Cslib.ωSequence.get_append_right'

```lean
theorem cons_flatten [Inhabited α] {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0) :
    ls.head ++ω ls.tail.flatten = ls.flatten :=
```

## 4. Cslib.ωSequence.flatten_take_drop

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `6.00`
- evidence:
  - FormalLanguage: List.flatten, Cslib.ωSequence.flatten, Cslib.ωSequence.append_flatten, Cslib.ωSequence.length_flatten_take
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.flatten, Cslib.ωSequence.append_left_right_injective, Cslib.ωSequence.append_flatten, Cslib.ωSequence.append_take_drop, Cslib.ωSequence.length_flatten_take, Cslib.ωSequence.length_take

```lean
theorem flatten_take_drop [Inhabited α]
    {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0) (n : ℕ) :
    (ls.take n).flatten = ls.flatten.take (ls.cumLen n) ∧
    (ls.drop n).flatten = ls.flatten.drop (ls.cumLen n) :=
```

## 5. Cslib.ωSequence.strictMono_flatten

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `5.90`
- evidence:
  - FormalLanguage: Cslib.ωSequence.flatten, Cslib.ωSequence.flatten_def
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.flatten, Cslib.ωSequence.flatten_def, Cslib.ωSequence.segment_toSegs_cumLen, Cslib.ωSequence.toSegs_def

```lean
theorem strictMono_flatten [Inhabited α] {f : ℕ → ℕ}
    (hm : StrictMono f) (h0 : f 0 = 0) (s : ωSequence α) :
    (s.toSegs f).flatten = s :=
```

## 6. Cslib.ωSequence.append_flatten

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `5.80`
- evidence:
  - FormalLanguage: List.flatten, Cslib.ωSequence.flatten
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.flatten, Cslib.ωSequence.tail_eq_drop, Cslib.ωSequence.take_succ

```lean
theorem append_flatten [Inhabited α] {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0)
    (n : ℕ) : (ls.take n).flatten ++ω (ls.drop n).flatten = ls.flatten :=
```

## 7. Cslib.ωLanguage.omegaPow_coind'

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `Computability, FormalLanguage, OmegaSequence`
- used_premise_domains: `Computability, FormalLanguage, OmegaSequence`
- cross_domain_score: `5.70`
- evidence:
  - Computability: _private.Cslib.Computability.Languages.OmegaLanguage.0.Cslib.ωLanguage.iter_helper
  - FormalLanguage: Cslib.ωLanguage.le_def, Cslib.ωLanguage.hmul_seq_prop, _private.Cslib.Computability.Languages.OmegaLanguage.0.Cslib.ωLanguage.iter_helper, Cslib.ωLanguage.omegaPow_seq_prop
  - OmegaSequence: Cslib.ωSequence.extract_eq_drop_take

```lean
theorem omegaPow_coind' [Inhabited α] (h_nn : [] ∉ l) (h_le : p ≤ l * p) : p ≤ l^ω :=
```

## 8. Cslib.ωSequence.extract_flatten

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `5.70`
- evidence:
  - FormalLanguage: Cslib.ωSequence.flatten_drop, Cslib.ωSequence.flatten_take
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.flatten_drop, Cslib.ωSequence.flatten_take, Cslib.ωSequence.extract_eq_drop_take

```lean
theorem extract_flatten [Inhabited α] {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0)
    (n : ℕ) : ls.flatten.extract (ls.cumLen n) (ls.cumLen (n + 1)) = ls n :=
```

## 9. Cslib.ωSequence.flatten_def

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `5.60`
- evidence:
  - FormalLanguage: Cslib.ωSequence.flatten
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.flatten

```lean
theorem flatten_def [Inhabited α] (ls : ωSequence (List α)) (n : ℕ) :
    flatten ls n = (ls (segment ls.cumLen n))[n - ls.cumLen (segment ls.cumLen n)]! :=
```

## 10. Cslib.ωSequence.flatten_take

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `5.60`
- evidence:
  - FormalLanguage: List.flatten, Cslib.ωSequence.flatten_take_drop
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.flatten_take_drop

```lean
theorem flatten_take [Inhabited α]
    {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0) (n : ℕ) :
    (ls.take n).flatten = ls.flatten.take (ls.cumLen n) :=
```

## 11. Cslib.ωSequence.flatten_drop

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `5.60`
- evidence:
  - FormalLanguage: Cslib.ωSequence.flatten, Cslib.ωSequence.flatten_take_drop
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.flatten, Cslib.ωSequence.flatten_take_drop

```lean
theorem flatten_drop [Inhabited α]
    {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0) (n : ℕ) :
    (ls.drop n).flatten = ls.flatten.drop (ls.cumLen n) :=
```

## 12. Cslib.ωSequence.length_flatten_take

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, FormalLanguage, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `4.30`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.take_succ'

```lean
theorem length_flatten_take {ls : ωSequence (List α)} (n : ℕ) :
    (ls.take n).flatten.length = ls.cumLen n :=
```

## 13. Cslib.Automata.NA.Buchi.inter_freq_acc_freq_acc

- split: `test`
- file: `Cslib/Computability/Automata/NA/BuchiInter.lean`
- primary_domain: `Automata`
- domains: `Automata, OmegaSequence`
- used_premise_domains: `Automata, OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - Automata: Cslib.Automata.NA.Buchi.interNA, Cslib.Automata.NA.Run, Cslib.Automata.NA.Buchi.interAcc
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.frequently_leadsTo_frequently, Cslib.ωSequence.leadsTo_trans, Cslib.ωSequence.step_leadsTo, Cslib.ωSequence.until_frequently_not_leadsTo

```lean
lemma inter_freq_acc_freq_acc {xs : ωSequence Symbol} {ss : ωSequence ((Π i, State i) × Bool)}
    {i : Bool} (h_run : (interNA na acc).Run xs ss) (h_inf : ∃ᶠ k in atTop, ss k ∈ interAcc i acc) :
    ∃ᶠ k in atTop, ss k ∈ interAcc (!i) acc :=
```

## 14. Cslib.Automata.NA.Buchi.inter_freq_comp_acc_freq_acc

- split: `test`
- file: `Cslib/Computability/Automata/NA/BuchiInter.lean`
- primary_domain: `Automata`
- domains: `Automata, OmegaSequence`
- used_premise_domains: `Automata, OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - Automata: Cslib.Automata.NA.Buchi.interNA, Cslib.Automata.NA.Run, Cslib.Automata.NA.Buchi.interAccept, Cslib.Automata.NA.Buchi.interAcc
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.frequently_leadsTo_frequently, Cslib.ωSequence.leadsTo_cases_or, Cslib.ωSequence.until_frequently_leadsTo_and

```lean
lemma inter_freq_comp_acc_freq_acc {xs : ωSequence Symbol} {ss : ωSequence ((Π i, State i) × Bool)}
    (h_run : (interNA na acc).Run xs ss)
    (h_inf_f : ∃ᶠ k in atTop, ss k ∈ {s | s.fst false ∈ acc false})
    (h_inf_t : ∃ᶠ k in atTop, ss k ∈ {s | s.fst true ∈ acc true}) :
    ∃ᶠ k in atTop, ss k ∈ interAccept acc :=
```

## 15. Cslib.ωLanguage.omegaPow_seq_prop

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - FormalLanguage: Cslib.ωSequence.strictMono_flatten, Language.mem_sub_one
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.cumLen_strictMono, Cslib.ωSequence.cumLen_zero, Cslib.ωSequence.strictMono_flatten, Cslib.ωSequence.extract_eq_nil_iff

```lean
theorem omegaPow_seq_prop [Inhabited α] :
    l^ω = { s : ωSequence α |
      ∃ f : ℕ → ℕ, StrictMono f ∧ f 0 = 0 ∧ ∀ m, s.extract (f m) (f (m + 1)) ∈ l } :=
```

## 16. Cslib.ωSequence.take_take

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - OmegaSequence: Cslib.ωSequence, List.take, List.take_zero, Cslib.ωSequence.take_zero, List.take_nil, Cslib.ωSequence.take_succ, List.take_succ_cons

```lean
theorem take_take {s : ωSequence α} : ∀ {m n}, (s.take n).take m = s.take (min n m)
```

## 17. Cslib.ωSequence.append_take_drop

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.appendωSequence, Cslib.ωSequence.take, Cslib.ωSequence.drop, Cslib.ωSequence.take_succ, Cslib.ωSequence.drop_succ, Cslib.ωSequence.cons_append_ωSequence, Cslib.ωSequence.tail

```lean
theorem append_take_drop (n : ℕ) (s : ωSequence α) : appendωSequence (take n s) (drop n s) = s :=
```

## 18. Cslib.SKI.List.tailStep_correct

- split: `test`
- file: `Cslib/Languages/CombinatoryLogic/List.lean`
- primary_domain: `CombinatoryLogic`
- domains: `CombinatoryLogic, OmegaSequence`
- used_premise_domains: `CombinatoryLogic, OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - CombinatoryLogic: Cslib.SKI, Cslib.SKI.IsChurch, Cslib.SKI.IsChurchListPair, Cslib.SKI.List.TailStep, Cslib.SKI.isChurchListPair_trans, Cslib.SKI.List.tailStep_def, Cslib.SKI.isChurchList_trans, Cslib.SKI.fst_correct
  - OmegaSequence: Cslib.SKI.List.tailStep_def

```lean
theorem tailStep_correct {x : ℕ} {xs : List ℕ} {cx p : SKI}
    (hcx : IsChurch x cx) (hp : IsChurchListPair xs.tail xs p) :
    IsChurchListPair xs (x :: xs) (TailStep ⬝ cx ⬝ p) :=
```

## 19. Cslib.SKI.List.tailFold_correct

- split: `test`
- file: `Cslib/Languages/CombinatoryLogic/List.lean`
- primary_domain: `CombinatoryLogic`
- domains: `CombinatoryLogic, OmegaSequence`
- used_premise_domains: `CombinatoryLogic, OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - CombinatoryLogic: Cslib.SKI, Cslib.SKI.IsChurchList, Cslib.SKI.List.TailStep, Cslib.SKI.MkPair, Cslib.SKI.List.Nil, Cslib.SKI.IsChurchListPair, Cslib.SKI.List.tail_init, Cslib.SKI.List.tailStep_correct
  - OmegaSequence: Cslib.SKI.List.tail_init, Cslib.SKI.List.tailStep_correct, Cslib.SKI.MRed.tail

```lean
theorem tailFold_correct (ns : List ℕ) (cns : SKI) (hcns : IsChurchList ns cns) :
    ∃ p, (cns ⬝ TailStep ⬝ (MkPair ⬝ Nil ⬝ Nil)) ↠ p ∧
         IsChurchListPair ns.tail ns p :=
```

## 20. Cslib.SKI.List.succHead_correct

- split: `test`
- file: `Cslib/Languages/CombinatoryLogic/List.lean`
- primary_domain: `CombinatoryLogic`
- domains: `CombinatoryLogic, OmegaSequence`
- used_premise_domains: `CombinatoryLogic, OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - CombinatoryLogic: Cslib.SKI, Cslib.SKI.IsChurchList, Cslib.SKI.List.SuccHead, Cslib.SKI.List.head_correct, Cslib.SKI.succ_correct, Cslib.SKI.List.Head, Cslib.SKI.isChurchList_trans, Cslib.SKI.B_tail_mred
  - OmegaSequence: Cslib.SKI.B_tail_mred

```lean
theorem succHead_correct (ns : List ℕ) (cns : SKI) (hcns : IsChurchList ns cns) :
    IsChurchList [ns.headD 0 + 1] (SuccHead ⬝ cns) :=
```

## 21. Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub.narrow_aux

- split: `test`
- file: `Cslib/Languages/LambdaCalculus/LocallyNameless/Fsub/Subtype.lean`
- primary_domain: `LambdaCalculus`
- domains: `LambdaCalculus, OmegaSequence`
- used_premise_domains: `LambdaCalculus, OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - LambdaCalculus: Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub, Cslib.LambdaCalculus.LocallyNameless.Fsub.Binding.sub, Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub.weaken, Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub.wf, Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub.trans_tvar, Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub.all, Cslib.LambdaCalculus.LocallyNameless.Fsub.Env.Wf.narrow, Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Wf.narrow
  - OmegaSequence: List.append_assoc, List.dlookup_append, List.singleton_append, List.cons_append, List.mem_append, List.sublist_append_of_sublist_right

```lean
lemma narrow_aux
    (trans : ∀ Γ σ τ, Sub Γ σ δ → Sub Γ δ τ → Sub Γ σ τ)
    (sub₁ : Sub (Γ ++ ⟨X, Binding.sub δ⟩ :: Δ) σ τ) (sub₂ : Sub Δ δ' δ) :
      Sub (Γ ++ ⟨X, Binding.sub δ'⟩ :: Δ) σ τ :=
```

## 22. Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub.map_subst

- split: `test`
- file: `Cslib/Languages/LambdaCalculus/LocallyNameless/Fsub/Subtype.lean`
- primary_domain: `LambdaCalculus`
- domains: `LambdaCalculus, OmegaSequence`
- used_premise_domains: `LambdaCalculus, OmegaSequence`
- cross_domain_score: `4.00`
- evidence:
  - LambdaCalculus: Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub, Cslib.LambdaCalculus.LocallyNameless.Fsub.Binding.sub, Cslib.LambdaCalculus.LocallyNameless.Fsub.Sub.all, Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.open_subst_var, Cslib.LambdaCalculus.LocallyNameless.Fsub.Env.Wf.map_subst_nmem, Cslib.LambdaCalculus.LocallyNameless.Context.map_val_mem, Cslib.LambdaCalculus.LocallyNameless.Fsub.Binding, Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.subst_fresh
  - OmegaSequence: Cslib.LambdaCalculus.LocallyNameless.Fsub.Env.Wf.map_subst_nmem, Cslib.LambdaCalculus.LocallyNameless.Context.map_val_mem, Cslib.LambdaCalculus.LocallyNameless.Fsub.Env.Wf.map_subst, Cslib.LambdaCalculus.LocallyNameless.Fsub.Ty.Wf.map_subst

```lean
lemma map_subst (sub₁ : Sub (Γ ++ ⟨X, Binding.sub δ'⟩ :: Δ) σ τ) (sub₂ : Sub Δ δ δ') :
    Sub (Γ.map_val (·[X:=δ]) ++ Δ) (σ[X:=δ]) (τ[X:=δ]) :=
```

## 23. Cslib.ωSequence.map_append_ωSequence

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.90`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.map, List.map, Cslib.ωSequence.cons_append_ωSequence, List.map_cons, Cslib.ωSequence.map_cons

```lean
theorem map_append_ωSequence (f : α → β) :
    ∀ (l : List α) (s : ωSequence α), map f (l ++ω s) = List.map f l ++ω map f s
```

## 24. Cslib.ωSequence.drop_append_ωSequence

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.90`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.drop, Cslib.ωSequence.drop_succ, Cslib.ωSequence.cons_append_ωSequence, Cslib.ωSequence.tail_cons

```lean
theorem drop_append_ωSequence : ∀ (l : List α) (s : ωSequence α), drop l.length (l ++ω s) = s
```

## 25. Cslib.ωSequence.drop_append_of_le_length

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.90`
- evidence:
  - OmegaSequence: Cslib.ωSequence.drop, Cslib.ωSequence.get_drop, Cslib.ωSequence.get_append_left, List.getElem_drop, Cslib.ωSequence.get_append_right

```lean
lemma drop_append_of_le_length (h : n ≤ x.length) :
    (x ++ω a).drop n = x.drop n ++ω a :=
```

## 26. Cslib.SKI.List.tail_correct

- split: `test`
- file: `Cslib/Languages/CombinatoryLogic/List.lean`
- primary_domain: `CombinatoryLogic`
- domains: `CombinatoryLogic, OmegaSequence`
- used_premise_domains: `CombinatoryLogic, OmegaSequence`
- cross_domain_score: `3.90`
- evidence:
  - CombinatoryLogic: Cslib.SKI, Cslib.SKI.IsChurchList, Cslib.SKI.List.Tail, Cslib.SKI.isChurchList_trans, Cslib.SKI.List.tail_def, Cslib.SKI.List.tailFold_correct, Cslib.SKI.MRed.tail, Cslib.SKI.Fst
  - OmegaSequence: Cslib.SKI.List.tail_def, Cslib.SKI.List.tailFold_correct, Cslib.SKI.MRed.tail

```lean
theorem tail_correct (ns : List ℕ) (cns : SKI) (hcns : IsChurchList ns cns) :
    IsChurchList ns.tail (Tail ⬝ cns) :=
```

## 27. Cslib.ωSequence.getElem?_take

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.80`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.length_take, Cslib.ωSequence.take_succ, Cslib.ωSequence.get_succ

```lean
theorem getElem?_take {s : ωSequence α} : ∀ {k n}, k < n → (s.take n)[k]? = s k
```

## 28. Cslib.ωSequence.dropLast_take

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.80`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.take, List.dropLast, Cslib.ωSequence.take_succ', List.dropLast_concat

```lean
theorem dropLast_take {n : ℕ} {xs : ωSequence α} :
    (ωSequence.take n xs).dropLast = ωSequence.take (n-1) xs :=
```

## 29. Cslib.ωSequence.cumLen_segment_zero

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.80`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.cumLen_zero, Cslib.ωSequence.cumLen_succ, Cslib.ωSequence.cumLen_strictMono

```lean
theorem cumLen_segment_zero {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0)
    (n : ℕ) (h_n : n < (ls 0).length) : segment ls.cumLen n = 0 :=
```

## 30. Cslib.LambdaCalculus.LocallyNameless.Stlc.FullBeta.progress

- split: `test`
- file: `Cslib/Languages/LambdaCalculus/LocallyNameless/Stlc/Safety.lean`
- primary_domain: `LambdaCalculus`
- domains: `LambdaCalculus, OmegaSequence`
- used_premise_domains: `LambdaCalculus, OmegaSequence`
- cross_domain_score: `3.80`
- evidence:
  - LambdaCalculus: Cslib.LambdaCalculus.LocallyNameless.Untyped.Term, Cslib.LambdaCalculus.LocallyNameless.Stlc.Ty, Cslib.LambdaCalculus.LocallyNameless.Untyped.Term.LC.abs, Cslib.LambdaCalculus.LocallyNameless.Stlc.Typing.lc, Cslib.LambdaCalculus.LocallyNameless.Untyped.Term.Value.abs
  - OmegaSequence: forall_const

```lean
theorem progress {t : Term Var} {τ : Ty Base} (ht : [] ⊢ t ∶ τ) : t.Value ∨ ∃ t', t ⭢βᶠ t' :=
```

## 31. Cslib.ωSequence.map_eq

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.70`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.map, Cslib.ωSequence.head, Cslib.ωSequence.tail, Cslib.ωSequence.eta, Cslib.ωSequence.tail_map, Cslib.ωSequence.head_map

```lean
theorem map_eq (s : ωSequence α) : map f s = f (head s) ::ω map f (tail s) :=
```

## 32. Cslib.SKI.isChurchListPair_trans

- split: `test`
- file: `Cslib/Languages/CombinatoryLogic/List.lean`
- primary_domain: `CombinatoryLogic`
- domains: `CombinatoryLogic, OmegaSequence`
- used_premise_domains: `CombinatoryLogic, OmegaSequence`
- cross_domain_score: `3.70`
- evidence:
  - CombinatoryLogic: Cslib.SKI, Cslib.SKI.IsChurchListPair, Cslib.SKI.isChurchList_trans, Cslib.SKI.MRed.tail, Cslib.SKI.Fst, Cslib.SKI.Snd
  - OmegaSequence: Cslib.SKI.MRed.tail

```lean
theorem isChurchListPair_trans {prev curr : List ℕ} {p p' : SKI} (hp : p ↠ p')
    (hp' : IsChurchListPair prev curr p') : IsChurchListPair prev curr p :=
```

## 33. Cslib.ωLanguage.mem_sSup

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - FormalLanguage: Cslib.ωLanguage, Cslib.ωLanguage.sSup_def, Cslib.ωLanguage.mem_def
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_sSup (ps : Set (ωLanguage α)) {s : ωSequence α} :
    s ∈ sSup ps ↔ ∃ p ∈ ps, s ∈ p :=
```

## 34. Cslib.ωLanguage.mem_sInf

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - FormalLanguage: Cslib.ωLanguage, Cslib.ωLanguage.sInf_def, Cslib.ωLanguage.mem_def
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_sInf (ps : Set (ωLanguage α)) {s : ωSequence α} :
    s ∈ sInf ps ↔ ∀ p ∈ ps, s ∈ p :=
```

## 35. Cslib.ωLanguage.omegaPow_eq_empty

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - FormalLanguage: Cslib.ωSequence.flatten, Cslib.ωLanguage.mem_def, Cslib.ωLanguage.bot_def
  - OmegaSequence: Cslib.ωSequence.const, Cslib.ωSequence.flatten

```lean
theorem omegaPow_eq_empty [Inhabited α] (h : l^ω = ⊥) : l ≤ 1 :=
```

## 36. Cslib.ωSequence.cons_injective2

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence.cons, Cslib.ωSequence, Cslib.ωSequence.get_zero_cons, Cslib.ωSequence.ext, Cslib.ωSequence.get_succ_cons

```lean
theorem cons_injective2 : Function.Injective2 (cons : α → ωSequence α → ωSequence α) :=
```

## 37. Cslib.ωSequence.get_succ_iterate'

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence.iterate, Cslib.ωSequence.get_iterate, Function.iterate_add_apply

```lean
theorem get_succ_iterate' (n : ℕ) (f : α → α) (a : α) :
    iterate f a (succ n) = f (iterate f a n) :=
```

## 38. Cslib.ωSequence.tail_iterate

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence.tail, Cslib.ωSequence.iterate, Cslib.ωSequence.get_tail, Cslib.ωSequence.get_succ_iterate'

```lean
theorem tail_iterate (f : α → α) (a : α) : tail (iterate f a) = iterate f (f a) :=
```

## 39. Cslib.ωSequence.append_append_ωSequence

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence, List.cons_append, Cslib.ωSequence.cons_append_ωSequence

```lean
theorem append_append_ωSequence : ∀ (l₁ l₂ : List α) (s : ωSequence α),
    l₁ ++ l₂ ++ω s = l₁ ++ω (l₂ ++ω s)
```

## 40. Cslib.ωSequence.take_succ

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.take, Cslib.ωSequence.head, Cslib.ωSequence.tail

```lean
theorem take_succ (n : ℕ) (s : ωSequence α) : take (succ n) s = head s :: take n (tail s) :=
```

## 41. Cslib.ωSequence.getElem?_take_succ

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.take, Cslib.ωSequence.getElem?_take

```lean
theorem getElem?_take_succ (n : ℕ) (s : ωSequence α) :
    (take (succ n) s)[n]? = some (s n) :=
```

## 42. Cslib.ωSequence.take_theorem

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.take, Cslib.ωSequence.getElem?_take_succ

```lean
theorem take_theorem (s₁ s₂ : ωSequence α) (h : ∀ n : ℕ, take n s₁ = take n s₂) : s₁ = s₂ :=
```

## 43. Cslib.ωSequence.extract_eq_ofFn

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.extract_eq_drop_take, Cslib.ωSequence.getElem?_take

```lean
theorem extract_eq_ofFn {xs : ωSequence α} {m n : ℕ} :
    xs.extract m n = List.ofFn (fun k : Fin (n - m) ↦ xs (m + k)) :=
```

## 44. Cslib.ωSequence.extract_eq_extract

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.60`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.extract_eq_ofFn

```lean
theorem extract_eq_extract {xs xs' : ωSequence α} {m n m' n' : ℕ}
    (h : xs.extract m n = xs'.extract m' n') :
    n - m = n' - m' ∧ ∀ k < n - m, xs (m + k) = xs' (m' + k) :=
```

## 45. Cslib.SKI.isChurchList_trans

- split: `test`
- file: `Cslib/Languages/CombinatoryLogic/List.lean`
- primary_domain: `CombinatoryLogic`
- domains: `CombinatoryLogic, LinearLogic`
- used_premise_domains: `CombinatoryLogic, LinearLogic`
- cross_domain_score: `3.60`
- evidence:
  - CombinatoryLogic: Cslib.SKI, Cslib.SKI.IsChurchList, Cslib.SKI.parallel_mRed, Cslib.SKI.MRed.head
  - LinearLogic: Cslib.SKI.parallel_mRed

```lean
theorem isChurchList_trans {ns : List ℕ} {cns cns' : SKI} (h : cns ↠ cns')
    (hcns' : IsChurchList ns cns') : IsChurchList ns cns :=
```

## 46. Cslib.Automata.NA.hist_run_exists

- split: `test`
- file: `Cslib/Computability/Automata/NA/Hist.lean`
- primary_domain: `Automata`
- domains: `Automata, OmegaSequence`
- used_premise_domains: `Automata, OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - Automata: Cslib.Automata.NA.Run, Cslib.Automata.NA.makeHist, Cslib.Automata.NA.addHist
  - OmegaSequence: Cslib.ωSequence

```lean
theorem hist_run_exists {xs : ωSequence Symbol} {ss : ωSequence State}
    (h_run : na.Run xs ss) : ∃ ss', (na.addHist start' tr').Run xs ss' ∧ ss'.map fst = ss :=
```

## 47. Cslib.ωLanguage.toSet_ofSet

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - FormalLanguage: Cslib.ωLanguage.ofSet, Cslib.ωLanguage.toSet
  - OmegaSequence: Cslib.ωSequence

```lean
lemma toSet_ofSet (s : Set (ωSequence α)) : (ofSet s).toSet = s :=
```

## 48. Cslib.ωLanguage.omegaPow_def

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - FormalLanguage: Language
  - OmegaSequence: Cslib.ωSequence

```lean
theorem omegaPow_def [Inhabited α] (l : Language α) :
    l^ω = { s | ∃ xs : ωSequence (List α), xs.flatten = s ∧ ∀ k, xs k ∈ l - 1 }
  :=
```

## 49. Cslib.ωSequence.tail_drop'

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.tail, Cslib.ωSequence.drop

```lean
theorem tail_drop' {i : ℕ} {s : ωSequence α} : tail (drop i s) = s.drop (i + 1) :=
```

## 50. Cslib.ωSequence.drop_succ

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.drop, Cslib.ωSequence.tail

```lean
theorem drop_succ (n : ℕ) (s : ωSequence α) : drop (succ n) s = drop n (tail s) :=
```

## 51. Cslib.ωSequence.drop_map

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.drop, Cslib.ωSequence.map, Cslib.ωSequence.ext

```lean
theorem drop_map (n : ℕ) (s : ωSequence α) : drop n (map f s) = map f (drop n s) :=
```

## 52. Cslib.ωSequence.drop_zip

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.drop, Cslib.ωSequence.zip, Cslib.ωSequence.ext

```lean
theorem drop_zip (n : ℕ) (s₁ : ωSequence α) (s₂ : ωSequence β) :
    drop n (zip f s₁ s₂) = zip f (drop n s₁) (drop n s₂) :=
```

## 53. Cslib.ωSequence.zip_eq

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.zip, Cslib.ωSequence.head, Cslib.ωSequence.tail, Cslib.ωSequence.eta

```lean
theorem zip_eq (s₁ : ωSequence α) (s₂ : ωSequence β) :
    zip f s₁ s₂ = f (head s₁) (head s₂) ::ω zip f (tail s₁) (tail s₂) :=
```

## 54. Cslib.ωSequence.map_iterate

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence.iterate, Cslib.ωSequence.map, Cslib.ωSequence.get_map, Cslib.ωSequence.get_succ_iterate, Cslib.ωSequence.get_succ_iterate'

```lean
theorem map_iterate (f : α → α) (a : α) : iterate f (f a) = map f (iterate f a) :=
```

## 55. Cslib.ωSequence.take_succ'

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.take_succ, List.cons_append, Cslib.ωSequence.get_tail

```lean
theorem take_succ' {s : ωSequence α} : ∀ n, s.take (n+1) = s.take n ++ [s n]
```

## 56. Cslib.ωSequence.take_append_of_le_length

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence.take, List.getElem_take, Cslib.ωSequence.take_get, Cslib.ωSequence.get_append_left

```lean
theorem take_append_of_le_length (h : n ≤ x.length) :
    (x ++ω a).take n = x.take n :=
```

## 57. Cslib.ωSequence.drop_append_of_ge_length

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.drop, Cslib.ωSequence.get_drop, Cslib.ωSequence.get_append_right'

```lean
theorem drop_append_of_ge_length {xl : List α} {xs : ωSequence α} {n : ℕ} (h : xl.length ≤ n) :
    (xl ++ω xs).drop n = xs.drop (n - xl.length) :=
```

## 58. Cslib.ωSequence.extract_append_right_right

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.extract, Cslib.ωSequence.extract_eq_drop_take, Cslib.ωSequence.drop_append_of_ge_length

```lean
theorem extract_append_right_right {xl : List α} {xs : ωSequence α} {m n : ℕ} (h : xl.length ≤ m) :
    (xl ++ω xs).extract m n = xs.extract (m - xl.length) (n - xl.length) :=
```

## 59. Cslib.ωSequence.extract_append_zero_right

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.extract, Cslib.ωSequence.extract_eq_take, Cslib.ωSequence.append_take

```lean
theorem extract_append_zero_right {xl : List α} {xs : ωSequence α} {n : ℕ} (h : xl.length ≤ n) :
    (xl ++ω xs).extract 0 n = xl ++ (xs.extract 0 (n - xl.length)) :=
```

## 60. Cslib.ωSequence.drop_extract

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence, List.drop, Cslib.ωSequence.extract_lu_extract_lu, Cslib.ωSequence.length_extract, List.take_length

```lean
theorem drop_extract {xs : ωSequence α} {m n k : ℕ} (h : k ≤ n - m) :
    (xs.extract m n).drop k = xs.extract (m + k) n :=
```

## 61. Cslib.ωSequence.cumLen_strictMono

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.50`
- evidence:
  - OmegaSequence: Cslib.ωSequence

```lean
theorem cumLen_strictMono {ls : ωSequence (List α)} (h_ls : ∀ k, (ls k).length > 0) :
    StrictMono ls.cumLen :=
```

## 62. Cslib.LTS.toFLTS_mem_mtr

- split: `test`
- file: `Cslib/Foundations/Semantics/FLTS/LTSToFLTS.lean`
- primary_domain: `Semantics`
- domains: `Automata, Semantics`
- used_premise_domains: `Automata, Semantics`
- cross_domain_score: `3.50`
- evidence:
  - Automata: Cslib.FLTS.mtr
  - Semantics: Cslib.LTS, Cslib.LTS.toFLTS, Cslib.FLTS.mtr

```lean
theorem toFLTS_mem_mtr {lts : LTS State Label} {S : Set State} {s' : State} {μs : List Label} :
  s' ∈ lts.toFLTS.mtr S μs ↔ ∃ s ∈ S, lts.MTr s μs s' :=
```

## 63. Cslib.Automata.NA.hist_run_proj

- split: `test`
- file: `Cslib/Computability/Automata/NA/Hist.lean`
- primary_domain: `Automata`
- domains: `Automata, OmegaSequence`
- used_premise_domains: `Automata, OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - Automata: Cslib.Automata.NA.Run, Cslib.Automata.NA.addHist
  - OmegaSequence: Cslib.ωSequence

```lean
theorem hist_run_proj {xs : ωSequence Symbol} {ss : ωSequence (State × Hist)}
    (h_run : (na.addHist start' tr').Run xs ss) : na.Run xs (ss.map fst) :=
```

## 64. Cslib.ωLanguage.omegaLim_def

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - FormalLanguage: Language
  - OmegaSequence: Cslib.ωSequence

```lean
theorem omegaLim_def (l : Language α) :
    l↗ω = { s : ωSequence α | ∃ᶠ m in atTop, s.extract 0 m ∈ l } :=
```

## 65. Cslib.ωLanguage.map_def

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - FormalLanguage: Cslib.ωLanguage
  - OmegaSequence: Cslib.ωSequence.map

```lean
theorem map_def (f : α → β) (p : ωLanguage α) :
    p.map f = image (ωSequence.map f) p.toSet :=
```

## 66. Cslib.ωLanguage.mem_iSup

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - FormalLanguage: Cslib.ωLanguage, Cslib.ωLanguage.iSup_def
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_iSup {ι : Sort v} {p : ι → ωLanguage α} {s : ωSequence α} :
    (s ∈ ⨆ i, p i) ↔ ∃ i, s ∈ p i :=
```

## 67. Cslib.ωLanguage.mem_iInf

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - FormalLanguage: Cslib.ωLanguage, Cslib.ωLanguage.iInf_def
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_iInf {ι : Sort v} {p : ι → ωLanguage α} {s : ωSequence α} :
    (s ∈ ⨅ i, p i) ↔ ∀ i, s ∈ p i :=
```

## 68. Cslib.ωLanguage.mem_omegaPow

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_omegaPow [Inhabited α] :
    s ∈ l^ω ↔ ∃ xs : ωSequence (List α), xs.flatten = s ∧ ∀ k, xs k ∈ l - 1 :=
```

## 69. Cslib.ωLanguage.flatten_mem_omegaPow

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence

```lean
theorem flatten_mem_omegaPow [Inhabited α] {xs : ωSequence (List α)}
    (h_xs : ∀ k, xs k ∈ l - 1) : xs.flatten ∈ l^ω :=
```

## 70. Cslib.ωSequence.eta

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.head, Cslib.ωSequence.tail

```lean
theorem eta (s : ωSequence α) : head s ::ω tail s = s :=
```

## 71. Cslib.ωSequence.tail_eq_drop

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.tail, Cslib.ωSequence.drop

```lean
theorem tail_eq_drop (s : ωSequence α) : tail s = drop 1 s :=
```

## 72. Cslib.ωSequence.drop_tail'

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.drop, Cslib.ωSequence.tail

```lean
theorem drop_tail' {i : ℕ} {s : ωSequence α} : drop i (tail s) = s.drop (i + 1) :=
```

## 73. Cslib.ωSequence.get_succ

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.tail

```lean
theorem get_succ (n : ℕ) (s : ωSequence α) : s (succ n) = (tail s) n :=
```

## 74. Cslib.ωSequence.tail_map

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.tail, Cslib.ωSequence.map

```lean
theorem tail_map (s : ωSequence α) : tail (map f s) = map f (tail s) :=
```

## 75. Cslib.ωSequence.head_map

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.head, Cslib.ωSequence.map

```lean
theorem head_map (s : ωSequence α) : head (map f s) = f (head s) :=
```

## 76. Cslib.ωSequence.map_cons

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.map, Cslib.ωSequence.eta, Cslib.ωSequence.map_eq

```lean
theorem map_cons (a : α) (s : ωSequence α) : map f (a ::ω s) = f a ::ω map f s :=
```

## 77. Cslib.ωSequence.map_id

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.map

```lean
theorem map_id (s : ωSequence α) : map id s = s :=
```

## 78. Cslib.ωSequence.map_tail

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.map, Cslib.ωSequence.tail

```lean
theorem map_tail (s : ωSequence α) : map f (tail s) = tail (map f s) :=
```

## 79. Cslib.ωSequence.head_zip

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.head, Cslib.ωSequence.zip

```lean
theorem head_zip (s₁ : ωSequence α) (s₂ : ωSequence β) :
    head (zip f s₁ s₂) = f (head s₁) (head s₂) :=
```

## 80. Cslib.ωSequence.tail_zip

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.tail, Cslib.ωSequence.zip

```lean
theorem tail_zip (s₁ : ωSequence α) (s₂ : ωSequence β) :
    tail (zip f s₁ s₂) = zip f (tail s₁) (tail s₂) :=
```

## 81. Cslib.ωSequence.tail_const

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence.tail, Cslib.ωSequence.const, Cslib.ωSequence.const_eq

```lean
theorem tail_const (a : α) : tail (const a) = const a :=
```

## 82. Cslib.ωSequence.drop_const

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence.drop, Cslib.ωSequence.const, Cslib.ωSequence.ext

```lean
theorem drop_const (n : ℕ) (a : α) : drop n (const a) = const a :=
```

## 83. Cslib.ωSequence.get_succ_iterate

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence.iterate, Cslib.ωSequence.get_succ, Cslib.ωSequence.tail_iterate

```lean
theorem get_succ_iterate (n : ℕ) (f : α → α) (a : α) :
    iterate f a (succ n) = iterate f (f a) n :=
```

## 84. Cslib.ωSequence.iterate_id

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence.iterate, Cslib.ωSequence.const, Cslib.ωSequence.get_iterate

```lean
theorem iterate_id (a : α) : iterate id a = const a :=
```

## 85. Cslib.ωSequence.cons_append_ωSequence

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.appendωSequence

```lean
theorem cons_append_ωSequence (a : α) (l : List α) (s : ωSequence α) :
    appendωSequence (a :: l) s = a ::ω appendωSequence l s :=
```

## 86. Cslib.ωSequence.get_append_right'

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.get_append_right

```lean
theorem get_append_right' {xl : List α} {xs : ωSequence α} {k : ℕ} (h : xl.length ≤ k) :
    (xl ++ω xs) k = xs (k - xl.length) :=
```

## 87. Cslib.ωSequence.length_take

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.take, Cslib.ωSequence.take_succ

```lean
theorem length_take (n : ℕ) (s : ωSequence α) : (take n s).length = n :=
```

## 88. Cslib.ωSequence.take_add

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence.take, Cslib.ωSequence.append_left_injective, Cslib.ωSequence.drop, Cslib.ωSequence.drop_drop

```lean
lemma take_add : a.take (m + n) = a.take m ++ (a.drop m).take n :=
```

## 89. Cslib.ωSequence.extract_succ_right

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.append_extract_extract, Cslib.ωSequence.extract_eq_drop_take

```lean
theorem extract_succ_right {xs : ωSequence α} {m n : ℕ} (h_mn : m ≤ n) :
    xs.extract m (n + 1) = xs.extract m n ++ [xs n] :=
```

## 90. Cslib.ωSequence.extract_lu_extract_lu

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Init.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, List.extract, Cslib.ωSequence.extract_eq_ofFn

```lean
theorem extract_lu_extract_lu {xs : ωSequence α} {m n i j : ℕ} (h : j ≤ n - m) :
    (xs.extract m n).extract i j = xs.extract (m + i) (m + j) :=
```

## 91. Cslib.ωSequence.cumLen_succ

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence

```lean
theorem cumLen_succ (ls : ωSequence (List α)) (k : ℕ) :
    ls.cumLen (k + 1) = ls.cumLen k + (ls k).length :=
```

## 92. Cslib.ωSequence.cumLen_one_add_drop

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.cumLen

```lean
theorem cumLen_one_add_drop (ls : ωSequence (List α)) (k : ℕ) :
    ls.cumLen (1 + k) = (ls 0).length + (ls.drop 1).cumLen k :=
```

## 93. Cslib.ωSequence.segment_toSegs_cumLen

- split: `test`
- file: `Cslib/Foundations/Data/OmegaSequence/Flatten.lean`
- primary_domain: `DataStructure`
- domains: `DataStructure, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.40`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.cumLen, Cslib.ωSequence.toSegs_def

```lean
theorem segment_toSegs_cumLen {f : ℕ → ℕ}
    (hm : StrictMono f) (h0 : f 0 = 0) (s : ωSequence α) :
    (s.toSegs f).cumLen = f :=
```

## 94. Cslib.ωLanguage.mem_def

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.30`
- evidence:
  - FormalLanguage: Cslib.ωLanguage
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_def (p : ωLanguage α) (s : ωSequence α) : s ∈ p ↔ s ∈ p.toSet :=
```

## 95. Cslib.ωLanguage.mem_ext

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.30`
- evidence:
  - FormalLanguage: Cslib.ωLanguage.ext
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_ext (h : ∀ (s : ωSequence α), s ∈ p ↔ s ∈ q) : p = q :=
```

## 96. Cslib.ωLanguage.notMem_bot

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.30`
- evidence:
  - FormalLanguage: Cslib.ωLanguage
  - OmegaSequence: Cslib.ωSequence

```lean
theorem notMem_bot (s : ωSequence α) : s ∉ (⊥ : ωLanguage α) :=
```

## 97. Cslib.ωLanguage.mem_sup

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.30`
- evidence:
  - FormalLanguage: Cslib.ωLanguage
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_sup (p q : ωLanguage α) (s : ωSequence α) : s ∈ p ⊔ q ↔ s ∈ p ∨ s ∈ q :=
```

## 98. Cslib.ωLanguage.mem_inf

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.30`
- evidence:
  - FormalLanguage: Cslib.ωLanguage
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_inf (p q : ωLanguage α) (s : ωSequence α) : s ∈ p ⊓ q ↔ s ∈ p ∧ s ∈ q :=
```

## 99. Cslib.ωLanguage.mem_compl

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `FormalLanguage, OmegaSequence`
- cross_domain_score: `3.30`
- evidence:
  - FormalLanguage: Cslib.ωLanguage
  - OmegaSequence: Cslib.ωSequence

```lean
theorem mem_compl (p : ωLanguage α) (s : ωSequence α) : s ∈ pᶜ ↔ ¬ s ∈ p :=
```

## 100. Cslib.ωLanguage.hmul_seq_prop

- split: `test`
- file: `Cslib/Computability/Languages/OmegaLanguage.lean`
- primary_domain: `FormalLanguage`
- domains: `FormalLanguage, OmegaSequence`
- used_premise_domains: `OmegaSequence`
- cross_domain_score: `3.30`
- evidence:
  - OmegaSequence: Cslib.ωSequence, Cslib.ωSequence.take_append_of_le_length, Cslib.ωSequence.drop_append_ωSequence

```lean
theorem hmul_seq_prop : l * p = { s : ωSequence α | ∃ k, s.take k ∈ l ∧ s.drop k ∈ p } :=
```

