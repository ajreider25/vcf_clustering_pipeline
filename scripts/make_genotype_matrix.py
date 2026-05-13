import sys
from pathlib import Path

import pandas as pd
from cyvcf2 import VCF

def genotype_to_dosage(gt):
    """
    Convert cyvcf2 genotype to alternate-allele dosage.

    Example:
    0/0 -> 0
    0/1 -> 1
    1/1 -> 2
    missing -> None
    """
    a1, a2, phased = gt

    if a1 == -1 or a2 ==-1:
        return None
    
    return int(a1 > 0) + int(a2 > 0)

def main(input_vcf, output_tsv):
    vcf = VCF(input_vcf)
    samples = vcf.samples

    rows = []
    
    for variant in vcf:
        alt = ",".join(variant.ALT)
        variant_id = f"{variant.CHROM}:{variant.POS}:{variant.REF}:{alt}"

        row = {"variant_id": variant_id}

        for sample, gt in zip(samples, variant.genotypes):
            row[sample] = genotype_to_dosage(gt)

        rows.append(row)

    df = pd.DataFrame(rows)

    Path(output_tsv).parent.mkdir(parents=True, exist_ok=True)
    df.to_csv(output_tsv, sep="\t", index=False)


if __name__ == "__main__":
    if len(sys.argv) != 3:
        raise SystemExit(
            "Usage: python scripts/make_genotype_matrix.py <input.vcf> <output.tsv>"
        )
    
    main(sys.argv[1], sys.argv[2])