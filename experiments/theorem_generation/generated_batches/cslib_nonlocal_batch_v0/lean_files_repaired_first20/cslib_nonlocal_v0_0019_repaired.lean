import Cslib.Computability.Languages.OmegaRegularLanguage
import Cslib.Computability.Automata.DA.Buchi

open ωLanguage

/--
The ω-language of a deterministic automaton with Büchi acceptance coincides
with the ω-limit of the language of the same automaton with finite acceptance.
This is a restatement of `DA.buchi_eq_finAcc_omegaLim` using the notation
`language` for the ω-language of an automaton.
-/
theorem cslib_nonlocal_candidate_0019
  {State Symbol : Type}
  (da : Cslib.Automata.DA.DA State Symbol) (acc : Set State) :
  ωLanguage.language (Cslib.Automata.DA.Buchi.mk da acc)
    =
  (ωLanguage.language (Cslib.Automata.DA.FinAcc.mk da acc))↗ω := by
  simpa using
    (Cslib.Automata.DA.buchi_eq_finAcc_omegaLim
      (da := da) (acc := acc))
