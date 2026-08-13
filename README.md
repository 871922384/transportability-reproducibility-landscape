# Transportability reproducibility landscape

This minimal archive supports the study *Public-record documentation of
reproducibility prerequisites for transportability and generalizability
analyses: a landscape study of 83 source-target dataset pairs*.

## Contents

- `analysis-data.csv`: the 83-pair primary coding grid, the prespecified
  20-pair human reliability sample, and the post hoc 24-pair additional
  reliability sample.
- `codebook.md`: field definitions, allowed states, and decision rules.
- `reproduce.R`: a base-R script that validates the data and regenerates the
  public result tables and main figure under `results/`.
- `SHA256SUMS`: SHA-256 checksums for all other release files.

Research team members completed all scientific coding and adjudication. The
included script validates and aggregates the coded data, performs the analyses,
and generates the figure. The two rater columns are anonymized role labels;
adjudicated values do not replace the pre-adjudication ratings.

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
