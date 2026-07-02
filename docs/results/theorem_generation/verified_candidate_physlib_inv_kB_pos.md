# Verified generated theorem candidate: Constants.inv_kB_pos

## Result

Lean verification: passed

## Candidate

```lean
import Physlib.StatisticalMechanics.BoltzmannConstant

lemma Constants.inv_kB_pos : 0 < (1 / kB) :=
by
  have hk : 0 < kB := Constants.kB_pos
  simpa [one_div] using inv_pos.mpr hk
cd /home/is/$USER/workspace/physlean-bench

mkdir -p docs/results/theorem_generation

cat > docs/results/theorem_generation/verified_candidate_physlib_inv_kB_pos.md <<'MD'
# Verified generated theorem candidate: Constants.inv_kB_pos

## Result

Lean verification: passed

## Candidate

```lean
import Physlib.StatisticalMechanics.BoltzmannConstant

lemma Constants.inv_kB_pos : 0 < (1 / kB) :=
by
  have hk : 0 < kB := Constants.kB_pos
  simpa [one_div] using inv_pos.mpr hk
