import Physlib.QFT.QED.AnomalyCancellation.Odd.LineInCubic
import Physlib.QFT.QED.AnomalyCancellation.Even.LineInCubic

lemma PureU1.Even.lineInCubicPerm_last_perm
  {n : ℕ}
  {S : (PureU1 (2 * n.succ.succ)).LinSols}
  (h : PureU1.Even.LineInCubicPerm S) :
  PureU1.Even.lineInCubicPerm_last_perm (n := n) (S := S) :=
PureU1.Even.lineInCubicPerm_last_perm h
