import Mathlib
import Cslib.Crypto.Protocols.PerfectSecrecy.Internal.PerfectSecrecy
import Cslib.Crypto.Protocols.PerfectSecrecy.Basic

lemma EncScheme.perfectlySecret_keySpace_eq_shannonKeySpace
    [Finite K] (scheme : EncScheme M K C) (h : scheme.PerfectlySecret) :
    Cslib.Crypto.Protocols.PerfectSecrecy.shannonKeySpace (M := M) (K := K) (C := C) scheme h =
      Cslib.Crypto.Protocols.PerfectSecrecy.EncScheme.perfectlySecret_keySpace_ge (M := M) (K := K) (C := C) scheme h := by
  apply le_antisymm
  · exact Cslib.Crypto.Protocols.PerfectSecrecy.shannonKeySpace (M := M) (K := K) (C := C) scheme h
  · exact Cslib.Crypto.Protocols.PerfectSecrecy.EncScheme.perfectlySecret_keySpace_ge (M := M) (K := K) (C := C) scheme h
