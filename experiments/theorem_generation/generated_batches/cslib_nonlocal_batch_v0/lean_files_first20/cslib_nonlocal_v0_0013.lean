import Cslib.Foundations.Semantics.LTS.OmegaExecution
import Cslib.Foundations.Data.OmegaSequence.Flatten

open ωSequence

namespace Cslib.LTS

variable {State Label : Type _} [Inhabited Label]

/--
In an `OmegaExecution` built from the pointwise executions given by `hexec`, the `n`-th
intermediate state in the global state sequence `ss` lies in the concrete segment
corresponding to step `segment μls.cumLen n`, at the local index
`n - μls.cumLen (segment μls.cumLen n)`.
This expresses the position of `ss n` using the generic `flatten` indexing lemma
for `ωSequence (List State)`.
-/
theorem OmegaExecution.state_at_flatten_index
    {ts : ωSequence State} {μls : ωSequence (List Label)} {sls : ωSequence (List State)}
    (hexec : ∀ k, lts.Execution (ts k) (μls k) (ts (k + 1)) (sls k))
    (hpos : ∀ k, (μls k).length > 0) :
    ∀ n,
      ∃ ss,
        lts.OmegaExecution ss μls.flatten ∧
        ss n =
          (sls (segment μls.cumLen n))
            [n - μls.cumLen (segment μls.cumLen n)]! :=
by
  intro n
  -- obtain the global OmegaExecution and its blockwise characterization
  obtain ⟨ss, hOmega, hblocks⟩ :=
    OmegaExecution.flatten_execution (ts := ts) (μls := μls) (sls := sls) hexec hpos
  refine ⟨ss, hOmega, ?_⟩
  -- express `ss n` via the generic flatten index description
  have hflatten := flatten_def μls n
  -- unfold `Ω`-execution states through the blockwise description `hblocks`
  -- First, rewrite `μls.flatten n` using `flatten_def`
  -- and then use the segment-based extraction of the corresponding block of `ss`.
  -- We will transport along `hblocks` at the enclosing segment.
  -- Let `k` be the segment containing `n`.
  set k := segment μls.cumLen n with hk
  -- From `hblocks` at index `k`, describe the slice of `ss` for this block.
  have hslice :=
    congrArg (fun l => l[n - μls.cumLen k]!)
      (by
        have := hblocks k
        -- `extract` of a list, then index into it, gives the same element
        -- as indexing into the original list at the shifted position.
        -- We use `List.nthLe_of_eq`-style reasoning through equality of lists.
        simpa [hk] using this)
  -- Finally, rewrite using `flatten_def` and our abbreviation `k`.
  simpa [hk, hflatten] using hslice

end Cslib.LTS
