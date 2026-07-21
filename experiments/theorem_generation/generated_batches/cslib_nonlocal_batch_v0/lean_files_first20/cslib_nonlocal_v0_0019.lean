import Cslib.Computability.Languages.OmegaRegularLanguage
import Cslib.Computability.Automata.DA.Buchi

open ωLanguage

/--
If the ω-language of a deterministic automaton with Büchi acceptance is regular,
then the ω-limit of the corresponding finite-acceptance language is the same
regular ω-language.

This bridges `IsRegular` for ω-languages with the equality between Büchi
languages and ω-limits of finite-acceptance languages.
-/
theorem DA.Buchi.isRegular_of_finAcc_omegaLim
  {State Symbol : Type}
  (da : DA State Symbol) (acc : Set State)
  (hreg : (language (DA.Buchi.mk da acc)).IsRegular) :
  ((language (DA.FinAcc.mk da acc))↗ω).IsRegular := by
  -- Use the equality between Büchi language and ω-limit of the finite-acceptance language
  have h :=
    DA.buchi_eq_finAcc_omegaLim (da := da) (acc := acc)
  -- Rewrite the regularity hypothesis along this equality
  simpa [h] using hreg
