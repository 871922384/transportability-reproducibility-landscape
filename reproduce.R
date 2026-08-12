#!/usr/bin/env Rscript

fail <- function(message) stop(message, call. = FALSE)
required <- c(
  "analysis_layer", "pair_id", "field_id", "primary_state",
  "rater_a_state", "rater_b_state", "final_state", "evidence_url",
  "checked_date", "selection_stratum", "stratum_frame_n", "stratum_sample_n"
)
field_order <- c(
  "target_definition", "effect_modifier", "harmonization", "overlap",
  "target_uncertainty", "threshold_provenance", "threshold_timing",
  "source_access", "target_access", "reuse_terms", "code_record",
  "fixed_version", "execution_path"
)
field_labels <- c(
  target_definition = "Target population definition",
  effect_modifier = "Effect-modifier/covariate set",
  harmonization = "Cross-source harmonization",
  overlap = "Overlap/positivity assessment",
  target_uncertainty = "Target-sample uncertainty",
  threshold_provenance = "Threshold provenance",
  threshold_timing = "Threshold timing",
  source_access = "Source-data access",
  target_access = "Target-data access",
  reuse_terms = "Reuse terms", code_record = "Code record",
  fixed_version = "Fixed public version", execution_path = "Execution path"
)
allowed <- list(
  target_definition = c("documented", "partial", "not_documented", "not_applicable", "unresolved"),
  effect_modifier = c("documented", "partial", "not_documented", "not_applicable", "unresolved"),
  harmonization = c("documented", "partial", "not_documented", "not_applicable", "unresolved"),
  overlap = c("documented", "partial", "not_documented", "not_applicable", "unresolved"),
  target_uncertainty = c("documented", "partial", "not_documented", "not_applicable", "unresolved"),
  threshold_provenance = c("documented", "partial", "not_documented", "no_threshold_used", "unresolved"),
  threshold_timing = c("documented", "partial", "not_documented", "not_applicable", "unresolved"),
  source_access = c("public", "controlled", "unavailable", "unclear", "not_applicable", "unresolved"),
  target_access = c("public", "controlled", "unavailable", "unclear", "not_applicable", "unresolved"),
  reuse_terms = c("documented", "partial", "not_documented", "not_applicable", "unresolved"),
  code_record = c("documented", "partial", "not_documented", "not_applicable", "unresolved"),
  fixed_version = c("verified", "not_verified", "not_applicable", "unresolved"),
  execution_path = c("verified", "not_self_contained", "not_attempted", "not_applicable", "unresolved")
)

data <- utils::read.csv("analysis-data.csv", stringsAsFactors = FALSE,
                        check.names = FALSE, na.strings = character())
if (!identical(names(data), required)) fail("Unexpected analysis-data.csv schema.")
expected_layers <- c(primary_83 = 1079L, registered_human_20 = 260L,
                     additional_human_24 = 312L)
counts <- table(factor(data$analysis_layer, levels = names(expected_layers)))
if (!identical(as.integer(counts), unname(expected_layers))) fail("Unexpected layer row counts.")
if (anyDuplicated(paste(data$analysis_layer, data$pair_id, data$field_id, sep = "\r"))) {
  fail("Duplicate analysis-layer/pair/field key.")
}
if (!setequal(unique(data$field_id), field_order)) fail("Unexpected field identifiers.")
for (field in field_order) {
  values <- unique(unlist(data[data$field_id == field,
                               c("primary_state", "rater_a_state", "rater_b_state", "final_state")]))
  values <- values[nzchar(values)]
  if (!all(values %in% allowed[[field]])) fail(paste("Invalid state for", field))
}
primary <- data[data$analysis_layer == "primary_83", , drop = FALSE]
if (length(unique(primary$pair_id)) != 83L ||
    any(table(primary$pair_id) != 13L) || any(primary$primary_state != primary$final_state)) {
  fail("Primary layer is not an exact 83 by 13 grid.")
}
pair_all_unresolved <- tapply(
  primary$final_state == "unresolved", primary$pair_id, all
)
full_text_pair_ids <- names(pair_all_unresolved)[!pair_all_unresolved]
if (length(full_text_pair_ids) != 62L) {
  fail("Expected 62 pairs with at least one resolved primary state.")
}
registered <- data[data$analysis_layer == "registered_human_20", , drop = FALSE]
additional <- data[data$analysis_layer == "additional_human_24", , drop = FALSE]
if (length(unique(registered$pair_id)) != 20L || any(table(registered$pair_id) != 13L)) {
  fail("Registered reliability layer is not an exact 20 by 13 grid.")
}
if (length(unique(additional$pair_id)) != 24L || any(table(additional$pair_id) != 13L)) {
  fail("Additional reliability layer is not an exact 24 by 13 grid.")
}
if (any(!nzchar(registered$rater_a_state) | !nzchar(registered$rater_b_state)) ||
    any(!nzchar(additional$rater_a_state) | !nzchar(additional$rater_b_state))) {
  fail("Human reliability ratings must be complete.")
}
if (any(!nzchar(additional$selection_stratum)) ||
    any(is.na(suppressWarnings(as.integer(additional$stratum_frame_n)))) ||
    any(is.na(suppressWarnings(as.integer(additional$stratum_sample_n))))) {
  fail("Additional reliability sampling metadata are incomplete.")
}

dir.create("results", showWarnings = FALSE)
old_results <- list.files("results", full.names = TRUE)
if (length(old_results)) unlink(old_results, recursive = TRUE, force = TRUE)

profile_rows <- list()
for (i in seq_along(field_order)) {
  field <- field_order[[i]]
  states <- allowed[[field]]
  values <- primary$final_state[primary$field_id == field]
  full_text_values <- primary$final_state[
    primary$field_id == field & primary$pair_id %in% full_text_pair_ids
  ]
  applicable <- !values %in% c("not_applicable", "unresolved")
  applicable_n <- sum(applicable)
  for (j in seq_along(states)) {
    state <- states[[j]]
    n <- sum(values == state)
    profile_rows[[length(profile_rows) + 1L]] <- data.frame(
      display_order = i, field_id = field, label = unname(field_labels[[field]]),
      state_order = j, state = state, n = n, total_n = length(values),
      total_pct = n / length(values), applicable_n = applicable_n,
      applicable_pct = if (state %in% c("not_applicable", "unresolved") || applicable_n == 0L) NA_real_ else n / applicable_n,
      full_text_n = sum(full_text_values == state),
      full_text_total_n = length(full_text_values),
      full_text_pct = mean(full_text_values == state),
      stringsAsFactors = FALSE, check.names = FALSE
    )
  }
}
field_profile <- do.call(rbind, profile_rows)
utils::write.csv(field_profile, "results/field-profile.csv", row.names = FALSE, na = "")

analytic <- field_order[1:7]
qualifying <- list(
  target_definition = c("documented", "not_applicable"),
  effect_modifier = c("documented", "not_applicable"),
  harmonization = c("documented", "not_applicable"),
  overlap = c("documented", "not_applicable"),
  target_uncertainty = c("documented", "not_applicable"),
  threshold_provenance = c("documented", "no_threshold_used"),
  threshold_timing = c("documented", "not_applicable")
)
wide <- reshape(primary[c("pair_id", "field_id", "final_state")], idvar = "pair_id",
                timevar = "field_id", direction = "wide")
names(wide) <- sub("^final_state\\.", "", names(wide))
survives <- rep(TRUE, nrow(wide))
cascade <- lapply(seq_along(analytic), function(i) {
  field <- analytic[[i]]
  checkpoint <- wide[[field]] %in% qualifying[[field]]
  survives <<- survives & checkpoint
  data.frame(display_order = i, field_id = field,
             label = unname(field_labels[[field]]),
             checkpoint_states = paste(qualifying[[field]], collapse = "|"),
             checkpoint_n = sum(checkpoint), cumulative_n = sum(survives),
             total_n = nrow(wide), cumulative_pct = mean(survives),
             stringsAsFactors = FALSE, check.names = FALSE)
})
cascade <- do.call(rbind, cascade)
utils::write.csv(cascade, "results/attrition-cascade.csv", row.names = FALSE)

access <- primary[primary$field_id %in% c("source_access", "target_access"), ]
access_states <- c("public", "controlled", "unavailable", "unclear", "not_applicable", "unresolved")
access_rows <- list()
for (field in c("source_access", "target_access")) {
  values <- access$final_state[access$field_id == field]
  for (i in seq_along(access_states)) {
    state <- access_states[[i]]
    access_rows[[length(access_rows) + 1L]] <- data.frame(
      dataset_role = sub("_access$", "", field), state_order = i,
      access_state = state, n = sum(values == state), total_n = length(values),
      total_pct = mean(values == state), stringsAsFactors = FALSE,
      check.names = FALSE)
  }
}
access_distribution <- do.call(rbind, access_rows)
utils::write.csv(access_distribution, "results/access-distribution.csv", row.names = FALSE)

agreement <- function(x) sum(x$rater_a_state == x$rater_b_state)
stratum_pairs <- unique(additional[c("pair_id", "selection_stratum", "stratum_frame_n", "stratum_sample_n")])
strata <- unique(stratum_pairs$selection_stratum)
stratum_agreement <- vapply(strata, function(s) {
  rows <- additional[additional$selection_stratum == s, ]
  mean(rows$rater_a_state == rows$rater_b_state)
}, numeric(1L))
frame_n <- vapply(strata, function(s) unique(as.integer(stratum_pairs$stratum_frame_n[stratum_pairs$selection_stratum == s])), integer(1L))
remaining_weighted <- sum(frame_n * stratum_agreement) / sum(frame_n)
registered_agree <- agreement(registered)
additional_agree <- agreement(additional)
reliability <- data.frame(
  scope = c("registered_20_pre_adjudication", "additional_24_equal_allocation",
            "remaining_63_stratified_weighted", "combined_44_descriptive"),
  pair_n = c(20L, 24L, 63L, 44L),
  n_complete = c(260L, 312L, 63L * 13L, 572L),
  n_agree = c(registered_agree, additional_agree,
              remaining_weighted * 63L * 13L, registered_agree + additional_agree),
  raw_agreement = c(registered_agree / 260, additional_agree / 312,
                    remaining_weighted, (registered_agree + additional_agree) / 572),
  claim_boundary = c("registered_20_pair_subset_only",
                     "equal_allocation_stratified_sample_of_remaining_63_pairs",
                     "design_weighted_estimate_for_remaining_63_pairs_only",
                     "not_an_83_pair_probability_estimate"),
  stringsAsFactors = FALSE, check.names = FALSE
)
utils::write.csv(reliability, "results/reliability-summary.csv", row.names = FALSE)

grDevices::pdf("results/main-figure.pdf", width = 11, height = 7.5, useDingbats = FALSE)
graphics::layout(matrix(c(1, 2), nrow = 1), widths = c(1.25, 1))
graphics::par(mar = c(8, 4.2, 3, 1))
main_counts <- vapply(field_order, function(f) sum(primary$final_state[primary$field_id == f] %in% c("documented", "public", "verified")), integer(1L))
graphics::barplot(main_counts, names.arg = unname(field_labels[field_order]), las = 2,
                  col = "#317873", border = NA, ylab = "Pairs (n)",
                  main = "Public-record documentation")
graphics::par(mar = c(5, 4.2, 3, 1))
graphics::plot(seq_along(analytic), cascade$cumulative_n, type = "b", pch = 19,
               col = "#B04A3A", xaxt = "n", xlab = "Analytic checkpoint",
               ylab = "Pairs remaining (n)", ylim = c(0, 83),
               main = "Cumulative documentation cascade")
graphics::axis(1, at = seq_along(analytic), labels = seq_along(analytic))
graphics::text(seq_along(analytic), cascade$cumulative_n,
               labels = cascade$cumulative_n, pos = 3, cex = 0.9)
grDevices::dev.off()

cat(sprintf("primary_rows=%d\n", nrow(primary)))
cat(sprintf("full_text_pairs=%d\n", length(full_text_pair_ids)))
cat(sprintf("cascade=%s\n", paste(cascade$cumulative_n, collapse = ",")))
cat(sprintf("registered_agreement=%d/260\n", registered_agree))
cat(sprintf("additional_agreement=%d/312\n", additional_agree))
cat(sprintf("combined_agreement=%d/572\n", registered_agree + additional_agree))
cat(sprintf("remaining_63_weighted=%.1f%%\n", 100 * remaining_weighted))
