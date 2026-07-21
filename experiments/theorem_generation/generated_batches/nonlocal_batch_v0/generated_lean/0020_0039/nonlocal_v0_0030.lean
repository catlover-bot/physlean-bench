import Mathlib
import Cslib.Crypto.Protocols.PerfectSecrecy.Defs
import Cslib.Crypto.Protocols.PerfectSecrecy.Internal.PerfectSecrecy

open scoped BigOperators
open Classical

theorem Cslib.Crypto.Protocols.PerfectSecrecy.posteriorMsgDist_isProbability
    {M K C} (scheme : EncScheme M K C) (msgDist : PMF M) (c : C)
    (hc : c ∈ (scheme.marginalCiphertextDist msgDist).support) :
    ∑' m, scheme.posteriorMsgDist msgDist c hc m = 1 := by
  classical
  have h_pos : 0 < scheme.marginalCiphertextDist msgDist c := by
    have := (mem_support_iff).1 hc
    exact this
  have h_tsum_joint :
      ∑' m, scheme.jointDist msgDist (m, c) = scheme.marginalCiphertextDist msgDist c :=
    Cslib.Crypto.Protocols.PerfectSecrecy.jointDist_tsum_fst scheme msgDist c
  have h_tsum_eq :
      ∑' m, scheme.posteriorMsgDist msgDist c hc m
        = (∑' m, scheme.jointDist msgDist (m, c)) / scheme.marginalCiphertextDist msgDist c := by
    have h_series :
        (fun m => scheme.posteriorMsgDist msgDist c hc m)
          = fun m => scheme.jointDist msgDist (m, c) / scheme.marginalCiphertextDist msgDist c := by
      funext m
      exact scheme.posteriorMsgDist_apply msgDist c hc m
    simp [h_series, tsum_div, h_pos.ne']
  simp [h_tsum_joint, h_tsum_eq, div_self, h_pos.ne']
