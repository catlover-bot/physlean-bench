import json
from pathlib import Path
from collections import Counter, defaultdict

OUT = Path("/project/nlp-work11/hirotaka-m/physlean_trace_rc13_week_8cpu")
XOUT = OUT / "cross_domain_physlib_v0"
XOUT.mkdir(parents=True, exist_ok=True)

SPLITS = {
    "train": OUT / "train.jsonl",
    "valid": OUT / "valid.jsonl",
    "test": OUT / "test.jsonl",
}

# Physlib top-level directory -> domain
def domain_from_file_path(file_path: str) -> str:
    parts = file_path.split("/")
    if len(parts) >= 2 and parts[0] == "Physlib":
        return parts[1]
    return "UNKNOWN"

# Heuristic mapping from declaration / premise name to domain.
# This is intentionally conservative: generic Mathlib names like Fin, Real, Matrix are not enough alone.
def domains_from_name(name: str):
    if not name:
        return set()

    s = name

    domains = set()

    # Units / dimensions / temperature
    if any(k in s for k in [
        "UnitChoices", "Dimensionful", "TemperatureUnit", "dimScale",
        "SI_length", "SI_time", "SI_mass", "SI_charge", "SI_temperature"
    ]):
        domains.add("Units")

    # Thermodynamics
    if any(k in s for k in [
        "Thermodynamics", "Temperature", "Entropy", "Heat", "Pressure", "Volume"
    ]):
        domains.add("Thermodynamics")

    # QFT / Wick / field algebra
    if any(k in s for k in [
        "WickContraction", "FieldSpecification", "WickAlgebra",
        "crAn", "timeOrder", "timeContract"
    ]):
        domains.add("QFT")

    # Particles / standard model / fermions / Higgs
    if any(k in s for k in [
        "Fermion", "TwoHiggsDoublet", "MSSMACC", "SMRHN",
        "PureU1", "PlusU1", "StandardModel", "Particle"
    ]):
        domains.add("Particles")

    # String theory / F-theory
    if any(k in s for k in [
        "FTheory", "SU5", "ChargeSpectrum", "Quanta", "TenQuanta", "Flux"
    ]):
        domains.add("StringTheory")

    # Relativity / Lorentz / Minkowski
    if any(k in s for k in [
        "minkowskiMatrix", "Lorentz", "LorentzGroup", "complexLorentzTensor",
        "Minkowski", "SL2C"
    ]):
        domains.add("Relativity")

    # Space and time / analysis-heavy space lemmas
    if any(k in s for k in [
        "Space.", "Space_", "radialAngularMeasure", "normPowerSeries",
        "IsDistBounded", "fderiv_cross", "lintegral_radialMeasure"
    ]):
        domains.add("SpaceAndTime")

    # Electromagnetism
    if any(k in s for k in [
        "Electromagnetism", "ElectromagneticPotential", "vectorPotential",
        "electric", "magnetic"
    ]):
        domains.add("Electromagnetism")

    # Quantum mechanics
    if any(k in s for k in [
        "QuantumMechanics", "momentumOperator", "positionOperator",
        "UnboundedOperator", "Schwartz"
    ]):
        domains.add("QuantumMechanics")

    # Physlib-specific math infrastructure, not generic Mathlib.
    if any(k in s for k in [
        "KroneckerDelta", "Physlib.PiTensorProduct", "PiTensorProduct",
        "TensorSpecies", "Tensor.", "dropPair", "contrPCoeff", "evalPCoeff"
    ]):
        domains.add("Mathematics")

    return domains

def is_generic_math_name(name: str) -> bool:
    # These appear everywhere; do not count as cross-domain evidence by themselves.
    generic = {
        "Fin", "Nat", "Int", "Real", "Complex", "Matrix", "List", "Finset",
        "Set", "Subtype", "Function", "And.intro", "Eq", "HEq",
        "rfl", "simp", "mul_one", "one_mul", "add_zero", "zero_add",
    }
    return name in generic or name.startswith("Real.") or name.startswith("Matrix.")

def enrich_record(r, split):
    file_domain = domain_from_file_path(r.get("file_path", ""))
    decl_domains = domains_from_name(r.get("declaration_name", ""))

    used = r.get("used_premises") or []
    accessible = r.get("accessible_premises") or []

    used_domains = set()
    used_domain_evidence = defaultdict(list)

    for p in used:
        if is_generic_math_name(p):
            continue
        ds = domains_from_name(p)
        for d in ds:
            used_domains.add(d)
            if len(used_domain_evidence[d]) < 8:
                used_domain_evidence[d].append(p)

    accessible_domains = set()
    for p in accessible:
        if is_generic_math_name(p):
            continue
        accessible_domains |= domains_from_name(p)

    # Main domain is file-level domain.
    all_domains = {file_domain} | decl_domains | used_domains

    # Remove unknown unless it is the only thing.
    if len(all_domains) > 1:
        all_domains.discard("UNKNOWN")

    # Cross-domain means at least two non-UNKNOWN domains appear in file/decl/used-premise evidence.
    cross_domain = len(all_domains) >= 2

    # Score emphasizes actually used premise domains, not just accessible premises.
    cross_domain_score = (
        len(all_domains)
        + len(used_domains - {file_domain})
        + min(len(used), 10) / 10.0
    )

    out = dict(r)
    out["split"] = split
    out["source_library"] = "physlib"
    out["primary_domain"] = file_domain
    out["domains"] = sorted(all_domains)
    out["declaration_domains"] = sorted(decl_domains)
    out["used_premise_domains"] = sorted(used_domains)
    out["accessible_premise_domains"] = sorted(accessible_domains)
    out["used_domain_evidence"] = {k: v for k, v in sorted(used_domain_evidence.items())}
    out["requires_cross_domain_reasoning"] = cross_domain
    out["cross_domain_score"] = cross_domain_score
    out["cross_domain_type"] = "+".join(sorted(all_domains)) if cross_domain else file_domain
    return out

all_rows = []
by_split = {}

for split, path in SPLITS.items():
    rows = []
    with path.open() as f:
        for line in f:
            r = json.loads(line)
            rows.append(enrich_record(r, split))
    by_split[split] = rows
    all_rows.extend(rows)

cross_rows = [r for r in all_rows if r["requires_cross_domain_reasoning"]]
cross_by_split = {
    split: [r for r in rows if r["requires_cross_domain_reasoning"]]
    for split, rows in by_split.items()
}

# Write all enriched records and cross-domain candidates.
for split, rows in by_split.items():
    dst = XOUT / f"{split}.enriched.jsonl"
    with dst.open("w") as g:
        for r in rows:
            g.write(json.dumps(r, ensure_ascii=False) + "\n")

    cdst = XOUT / f"{split}.cross_domain.jsonl"
    with cdst.open("w") as g:
        for r in cross_by_split[split]:
            g.write(json.dumps(r, ensure_ascii=False) + "\n")

with (XOUT / "all.enriched.jsonl").open("w") as g:
    for r in all_rows:
        g.write(json.dumps(r, ensure_ascii=False) + "\n")

with (XOUT / "all.cross_domain.jsonl").open("w") as g:
    for r in cross_rows:
        g.write(json.dumps(r, ensure_ascii=False) + "\n")

# Summary.
summary = {
    "source": str(OUT),
    "n_total": len(all_rows),
    "n_cross_domain": len(cross_rows),
    "cross_domain_ratio": len(cross_rows) / len(all_rows) if all_rows else 0.0,
    "by_split": {
        split: {
            "n": len(by_split[split]),
            "cross_domain": len(cross_by_split[split]),
            "ratio": len(cross_by_split[split]) / len(by_split[split]) if by_split[split] else 0.0,
        }
        for split in SPLITS
    },
    "domain_counts_all": dict(Counter(r["primary_domain"] for r in all_rows)),
    "domain_counts_cross": dict(Counter(r["primary_domain"] for r in cross_rows)),
    "domain_pair_counts_cross": dict(Counter(r["cross_domain_type"] for r in cross_rows).most_common(50)),
}

(XOUT / "summary.json").write_text(json.dumps(summary, indent=2, ensure_ascii=False))

# Human-readable candidate examples.
top = sorted(cross_rows, key=lambda r: r["cross_domain_score"], reverse=True)[:100]
with (XOUT / "top_cross_domain_candidates.md").open("w") as f:
    f.write("# Top Physlib-internal cross-domain candidates\n\n")
    for i, r in enumerate(top, 1):
        f.write(f"## {i}. {r['declaration_name']}\n\n")
        f.write(f"- split: `{r['split']}`\n")
        f.write(f"- file: `{r['file_path']}`\n")
        f.write(f"- primary_domain: `{r['primary_domain']}`\n")
        f.write(f"- domains: `{', '.join(r['domains'])}`\n")
        f.write(f"- used_premise_domains: `{', '.join(r['used_premise_domains'])}`\n")
        f.write(f"- cross_domain_score: `{r['cross_domain_score']:.2f}`\n")
        if r.get("used_domain_evidence"):
            f.write("- evidence:\n")
            for d, ev in r["used_domain_evidence"].items():
                f.write(f"  - {d}: {', '.join(ev[:8])}\n")
        f.write("\n```lean\n")
        f.write((r.get("statement") or "").strip())
        f.write("\n```\n\n")

print(json.dumps(summary, indent=2, ensure_ascii=False))
print("wrote", XOUT)
