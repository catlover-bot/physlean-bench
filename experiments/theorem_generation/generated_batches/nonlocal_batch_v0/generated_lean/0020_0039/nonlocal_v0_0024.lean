import Cslib.Languages.CCS.Basic
import Cslib.Languages.CCS.BehaviouralTheory

open Cslib.CCS

lemma context_fill_preserves_bisimilarity
  (defs : Name → Process Name Constant)
  (c : Context Name Constant)
  (p q : Process Name Constant)
  (h : p ~[lts (defs := defs)] q) :
  c<[p] ~[lts (defs := defs)] c<[q] :=
by
  simpa [context_fill_def] using bisimilarity_is_congruence (defs := defs) p q c h
