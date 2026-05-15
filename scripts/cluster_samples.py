import logging
import sys
from pathlib import Path

import pandas as pd
from sklearn.cluster import KMeans

def main(input_tsv, output_tsv, n_clusters, random_seed):
    df = pd.read_csv(input_tsv, sep="\t")

    # variant_id becomes index
    df = df.set_index("variant_id")

    # transpose:
    # rows = samples
    # cols = variants
    X = df.T
    X = X.astype(float)
    X = X.fillna(X.mean())
    
    model = KMeans(
        n_clusters=n_clusters,
        random_state=random_seed,
        n_init="auto"
    )

    clusters = model.fit_predict(X)

    result = pd.DataFrame({
        "sample": X.index,
        "cluster": clusters
    })

    Path(output_tsv).parent.mkdir(
        parents=True,
        exist_ok=True
    )

    result.to_csv(output_tsv, sep="\t", index=False)

if __name__ == "__main__":
    input_tsv = sys.argv[1]
    output_tsv = sys.argv[2]
    n_clusters = int(sys.argv[3])
    random_seed = int(sys.argv[4])

    main(input_tsv, output_tsv, n_clusters, random_seed)