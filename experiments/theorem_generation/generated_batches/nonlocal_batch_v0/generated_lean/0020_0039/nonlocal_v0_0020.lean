import Cslib.Crypto.Protocols.PerfectSecrecy.Internal.PerfectSecrecy
import Cslib.Crypto.Protocols.PerfectSecrecy.Basic

lemma Cslib.Crypto.Protocols.PerfectSecrecy.EncScheme.perfectlySecret_iff_ciphertextIndist_internal
    (scheme : EncScheme M K C) :
    scheme.PerfectlySecret ↔ scheme.CiphertextIndist :=
by
  exact (EncScheme.perfectlySecret_iff_ciphertextIndist (M:=M) (K:=K) (C:=C) scheme)
