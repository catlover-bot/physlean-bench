import Cslib.Crypto.Protocols.PerfectSecrecy.Internal.PerfectSecrecy
import Cslib.Crypto.Protocols.PerfectSecrecy.Basic

lemma Cslib.Crypto.Protocols.PerfectSecrecy.EncScheme.ciphertextIndist_of_perfectlySecret_iff
    {M K C} (scheme : EncScheme M K C) :
    scheme.PerfectlySecret →
      (scheme.ciphertextIndist_of_perfectlySecret →
        (scheme.perfectlySecret_iff_ciphertextIndist).mpr) := by
  intro h₁ h₂
  exact (scheme.perfectlySecret_iff_ciphertextIndist).mpr
    ((scheme.ciphertextIndist_of_perfectlySecret) h₁)
