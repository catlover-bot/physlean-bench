import Cslib.Foundations.Semantics.LTS.Basic

namespace Cslib
namespace LTS

theorem graphDerived_mtr_single_iff_tr
    (lts : LTS State Label) (s1 : State) (μ : Label) (s2 : State) :
    lts.MTr s1 [μ] s2 ↔ lts.Tr s1 μ s2 := by
  constructor
  · intro h
    exact MTr.single_invert lts s1 μ s2 h
  · intro h
    exact MTr.single lts h

end LTS
end Cslib
