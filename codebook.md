# Public coding codebook

This release uses codebook version 0.2. Coding concerns what was documented
in the searched public record, not whether an analysis was scientifically valid.
`unresolved` is retained when the fixed public search route could not support a
defensible classification. Absence alone is not coded as `not_applicable`.

## Shared state meanings

- `documented`: the operational criterion is explicitly recorded.
- `partial`: relevant information is present but operational detail is incomplete.
- `not_documented`: the field applies, the public route was complete, and the criterion was not found.
- `not_applicable`: positive evidence establishes that the field does not apply.
- `unresolved`: access or evidence was insufficient for a defensible classification.
- Access fields use `public`, `controlled`, `unavailable`, and `unclear`.
- Terminal code fields use the field-specific states listed below.

## Fields

### 1. Target population definition (`target_definition`)

- Layer: `analytic_prerequisite`.
- Allowed states: `documented|partial|not_documented|not_applicable|unresolved`.
- Applicability rule: Only a purely symbolic analysis with no applied target population.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 2. Effect-modifier/covariate set (`effect_modifier`)

- Layer: `analytic_prerequisite`.
- Allowed states: `documented|partial|not_documented|not_applicable|unresolved`.
- Applicability rule: Only an analysis whose structure contains no covariate or modifier set.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 3. Cross-source harmonization (`harmonization`)

- Layer: `analytic_prerequisite`.
- Allowed states: `documented|partial|not_documented|not_applicable|unresolved`.
- Applicability rule: Only one already-common analytic dataset with no cross-source alignment.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 4. Overlap/positivity assessment (`overlap`)

- Layer: `analytic_prerequisite`.
- Allowed states: `documented|partial|not_documented|not_applicable|unresolved`.
- Applicability rule: Only an analysis whose structure has no source-target support comparison.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 5. Target-sample uncertainty (`target_uncertainty`)

- Layer: `analytic_prerequisite`.
- Allowed states: `documented|partial|not_documented|not_applicable|unresolved`.
- Applicability rule: Only a fixed non-sampled target distribution with no target-sampling uncertainty concept.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 6. Threshold provenance (`threshold_provenance`)

- Layer: `analytic_prerequisite`.
- Allowed states: `documented|partial|not_documented|no_threshold_used|unresolved`.
- Applicability rule: Use no_threshold_used instead of not_applicable when positive evidence shows no threshold was used.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 7. Threshold timing (`threshold_timing`)

- Layer: `analytic_prerequisite`.
- Allowed states: `documented|partial|not_documented|not_applicable|unresolved`.
- Applicability rule: Only auto-assigned when threshold_provenance is no_threshold_used.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator
- Conditional rule: parent `threshold_provenance`; no_threshold_used -> not_applicable; unresolved -> unresolved.

### 8. Source-data access (`source_access`)

- Layer: `reproducibility_prerequisite`.
- Allowed states: `public|controlled|unavailable|unclear|not_applicable|unresolved`.
- Applicability rule: Only a structure with no source-data object; inaccessible data are not not_applicable.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 9. Target-data access (`target_access`)

- Layer: `reproducibility_prerequisite`.
- Allowed states: `public|controlled|unavailable|unclear|not_applicable|unresolved`.
- Applicability rule: Only a structure with no target-data object; inaccessible data are not not_applicable.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 10. Reuse terms (`reuse_terms`)

- Layer: `reproducibility_prerequisite`.
- Allowed states: `documented|partial|not_documented|not_applicable|unresolved`.
- Applicability rule: Only when no reusable data, code, supplement, or research object exists structurally.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 11. Code record (`code_record`)

- Layer: `reproducibility_prerequisite`.
- Allowed states: `documented|partial|not_documented|not_applicable|unresolved`.
- Applicability rule: Only a non-computational analysis with no analysis-code concept.
- Denominator rule: distribution denominator n=83; show not_applicable and unresolved separately; report applicable denominator

### 12. Fixed public version (`fixed_version`)

- Layer: `operational_audit`.
- Allowed states: `verified|not_verified|not_applicable|unresolved`.
- Applicability rule: Auto-assigned when code_record is not_documented or not_applicable.
- Denominator rule: report absolute count over n=83; show not_applicable and unresolved separately
- Conditional rule: parent `code_record`; code not_documented/not_applicable -> not_applicable; code unresolved -> unresolved.

### 13. Execution path (`execution_path`)

- Layer: `operational_audit`.
- Allowed states: `verified|not_self_contained|not_attempted|not_applicable|unresolved`.
- Applicability rule: Auto-assigned when code_record is not_documented or not_applicable.
- Denominator rule: report absolute count over n=83; show not_applicable and unresolved separately
- Conditional rule: parent `code_record`; code not_documented/not_applicable -> not_applicable; code unresolved -> unresolved.

## Reliability layers

The rater columns preserve pre-adjudication ratings. `final_state` records the
post-adjudication analysis value. Raw agreement is calculated from the two rater
columns and is never recalculated from adjudicated values. The additional sample
uses equal allocation across three prespecified strata; frame and sample sizes
are included for design-weighted estimation within the remaining 63-pair frame.
