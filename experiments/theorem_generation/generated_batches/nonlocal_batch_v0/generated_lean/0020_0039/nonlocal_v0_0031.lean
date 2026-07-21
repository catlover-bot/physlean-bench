import Cslib.Crypto.Protocols.PerfectSecrecy.Defs
import Cslib.Crypto.Protocols.PerfectSecrecy.Internal.PerfectSecrecy
import Mathlib.Probability.ConditionalProbability

open Real

lemma Cslib.Crypto.Protocols.PerfectSecrecy.posteriorMsgDist_tsum
  {M K C : Type _} [Fintype M] [DecidableEq M]
  (scheme : EncScheme M K C) (msgDist : PMF M)
  (c : C) (hc : c ∈ (scheme.marginalCiphertextDist msgDist).support) :
  ∑' m, scheme.posteriorMsgDist msgDist c hc m = 1 := by
  have hpos : 0 < scheme.marginalCiphertextDist msgDist c := by
    have := (scheme.marginalCiphertextDist msgDist).mem_support_iff.mp hc
    exact this
  have hsum_joint :
      ∑' m, scheme.jointDist msgDist (m, c) =
        scheme.marginalCiphertextDist msgDist c :=
    scheme.jointDist_tsum_fst msgDist c
  have h1 :
      ∑' m, scheme.jointDist msgDist (m, c) /
            scheme.marginalCiphertextDist msgDist c = 1 := by
    have hfinite : (scheme.marginalCiphertextDist msgDist c : ℝ) ≠ 0 := ne_of_gt hpos
    have := congrArg (fun x => x / scheme.marginalCiphertextDist msgDist c) hsum_joint
    simpa [div_eq_mul_inv, one_mul, mul_comm, mul_left_comm, mul_assoc,
      inv_mul_cancel hfinite] using this
  have hposterior :
      (fun m => scheme.posteriorMsgDist msgDist c hc m) =
        (fun m => scheme.jointDist msgDist (m, c) /
                  scheme.marginalCiphertextDist msgDist c) := by
    funext m
    exact scheme.posteriorMsgDist_apply msgDist c hc m
  simpa [hposterior] using h1
