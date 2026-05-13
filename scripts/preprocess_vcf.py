import sys
from cyvcf2 import VCF
import pandas as pd

input_vcf = sys.argv[1]
output_tsv = sys.argv[2]

rows = []

for variant in VCF(input_vcf):
    rows.append({
        "chrom": variant.CHROM,
        "pos": variant.POS,
        "ref": variant.REF,
        "alt": ",".join(variant.ALT),
        "qual": variant.QUAL
    })

df = pd.DataFrame(rows)
print(df)
df.to_csv(output_tsv, sep="\t", index=False)