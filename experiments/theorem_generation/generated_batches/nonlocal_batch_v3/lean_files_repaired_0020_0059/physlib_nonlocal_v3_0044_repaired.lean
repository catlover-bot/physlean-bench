import Physlib.QFT.QED.AnomalyCancellation.LowDim.Three
import Physlib.QFT.QED.AnomalyCancellation.Basic
import Mathlib.Data.Fin.Tuple.Basic

lemma PureU1.pureU1_linear
  (n : ℕ) (S : (PureU1 n).LinSols) :
  (∑ i : Fin n, S.val i) = 0 :=
by
  -- This lemma is already part of the Physlib theory. We simply reuse it here
  -- by invoking the existing statement `PureU1.pureU1_linear` from Physlib.
  simpa using (PureU1.pureU1_linear (n := n) S)
