import Cslib.Computability.Languages.OmegaRegularLanguage
import Cslib.Computability.Automata.DA.Buchi

open ωLanguage

/--
If the ω-language of a deterministic automaton with Büchi acceptance is not regular,
then the ω-limit of the language of the corresponding finite-acceptance automaton
is also not regular.

This combines the equality between the Büchi language and the ω-limit of the
finite-acceptance language with the basic fact that `IsRegular` and `¬ IsRegular`
are negations of each other, allowing transfer of non-regularity across that
equality.
-/
theorem cslib_nonlocal_candidate_v2_0019
  {State Symbol : Type}
  (da : DA State Symbol) (acc : Set State)
  (h : ¬ (ωLanguage.IsRegular (DA.Buchi.language da acc))) :
  ¬ (ωLanguage.IsRegular ((DA.FinAcc.language da acc) ↗ω)) := by
  intro hreg
  have hEq :
      DA.Buchi.language da acc =
        (DA.FinAcc.language da acc) ↗ω :=
    DA.buchi_eq_finAcc_omegaLim (da := da) (acc := acc)
  -- Transport regularity along the language equality
  have hreg' : ωLanguage.IsRegular (DA.Buchi.language da acc) := by
    simpa [hEq] using hreg
  exact h hreg'
