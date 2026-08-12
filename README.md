# Transportability reproducibility landscape

This minimal archive supports the study *Public-record documentation of
reproducibility prerequisites for transportability and generalizability
analyses: a landscape study of 83 source-target dataset pairs*.

## Contents

- `analysis-data.csv`: the 83-pair primary coding grid and two prespecified
  human reliability samples.
- `codebook.md`: field definitions, allowed states, and decision rules.
- `reproduce.R`: a base-R script that validates the data and regenerates the
  public result tables and main figure under `results/`.
- `SHA256SUMS`: SHA-256 checksums for all other release files.

The scientific coding and adjudication were performed manually by the research
team. Deterministic scripts were used only for validation, aggregation,
analysis, and figure generation. The two rater columns are anonymized role
labels; adjudicated values do not replace the frozen pre-adjudication ratings.

## Reproduce

Requirements: R 4.2 or later. No contributed R packages are required.

```sh
Rscript reproduce.R
```

The script validates the schema, row counts, keys, states, and sampling
metadata before writing five files to `results/`.

## Scope

This archive contains derived public-record coding, not copies of publications
or source datasets. Blank values are intentional where a variable is not
applicable to an analysis layer. The design-weighted reliability estimate
applies only to the 63-pair frame remaining after the registered 20-pair
sample; the combined 44-pair result is descriptive and is not an estimate for
all 83 pairs.

## Licenses

`reproduce.R` is available under the MIT License (`LICENSE-CODE`). The data and
documentation are available under CC BY 4.0 (`LICENSE-DATA`).
