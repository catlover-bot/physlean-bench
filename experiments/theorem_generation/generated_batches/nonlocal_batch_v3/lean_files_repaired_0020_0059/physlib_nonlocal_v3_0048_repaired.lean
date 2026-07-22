import Physlib.Particles.StandardModel.AnomalyCancellation.Basic
import Physlib.Particles.StandardModel.AnomalyCancellation.Permutations

lemma SM.accCube_invariant
    {n} (f : PermGroup n) (S : (SMCharges n).Charges) :
    SM.accCube (SM.repCharges f S) = SM.accCube S :=
SM.accCube_invariant f S
