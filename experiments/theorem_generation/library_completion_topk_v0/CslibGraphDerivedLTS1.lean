import Cslib.Foundations.Semantics.LTS.HasTau

namespace Cslib
namespace LTS

theorem graphDerived_tr_tau_to_τSTr [HasTau Label] (lts : LTS State Label) :
    lts.Tr s HasTau.τ s' → lts.τSTr s s' := by
  intro h
  exact (sTr_τSTr lts).mp (STr.single lts h)

end LTS
end Cslib
