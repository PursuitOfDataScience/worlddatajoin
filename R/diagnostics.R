# Diagnostics & data quality ----------------------------------------------------

#' Pre-flight country-match report
#'
#' A report on what will and will not match before you trust the map: the
#' input, its `iso3c`, whether it `matched`, and a `suggestion` (the closest
#' known country name by string distance) for misses. Surfaced automatically by
#' [join_world()].
#'
#' @param x A vector of country names or codes.
#' @param origin How to read `x` (any countrycode origin scheme).
#' @param custom_match Overrides applied before matching (default
#'   [wdj_overrides()]).
#' @param suggest Whether to compute closest-name suggestions for misses
#'   (requires the optional `stringdist` package; default `TRUE`).
#'
#' @return A tibble with columns `input`, `iso3c`, `matched`, `suggestion`.
#' @export
#' @examples
#' check_country_match(c("USA", "Cote d'Ivoire", "Yugoslavia", "Wakanda"))
check_country_match <- function(x,
                                origin = "country.name",
                                custom_match = wdj_overrides(),
                                suggest = TRUE) {
  x <- as.character(x)
  iso3c <- wdj_to_iso3c(x, origin = origin, custom_match = custom_match)
  matched <- !is.na(iso3c)

  suggestion <- rep(NA_character_, length(x))
  if (isTRUE(suggest) && any(!matched)) {
    known <- unique(stats::na.omit(countrycode::codelist$country.name.en))
    miss_idx <- which(!matched)
    if (has_pkg("stringdist")) {
      for (i in miss_idx) {
        if (is.na(x[i]) || !nzchar(x[i])) next
        d <- stringdist::stringdist(tolower(x[i]), tolower(known), method = "jw")
        best <- which.min(d)
        if (length(best) && d[best] < 0.35) suggestion[i] <- known[best]
      }
    } else {
      for (i in miss_idx) {
        if (is.na(x[i]) || !nzchar(x[i])) next
        d <- utils::adist(tolower(x[i]), tolower(known))[1, ]
        best <- which.min(d)
        if (length(best) && d[best] <= 3) suggestion[i] <- known[best]
      }
    }
  }

  tibble::tibble(
    input = x,
    iso3c = iso3c,
    matched = matched,
    suggestion = suggestion
  )
}

#' Coverage / missingness audit
#'
#' What is missing, before you trust the map: which countries are unmatched,
#' the `NA` rate per indicator, and which World Bank regions / income groups are
#' under-covered -- so a half-empty map is caught before it is published.
#'
#' @param data A country-level (or map-ready) data frame.
#' @param indicator Optional character vector of value columns to report `NA`
#'   rates for. If `NULL`, all numeric columns are used.
#' @param by Grouping for the coverage breakdown: `"region"` (default),
#'   `"income"` or `"continent"`.
#'
#' @return A list with elements `unmatched`, `na_rates` and `by_group`.
#' @export
#' @examples
#' audit_coverage(worlddatajoin::world_snapshot$countries)
audit_coverage <- function(data,
                           indicator = NULL,
                           by = c("region", "income", "continent")) {
  by <- match.arg(by)
  data <- tibble::as_tibble(data)
  # Reduce to one row per country if a polygon frame was passed in.
  if (all(c("iso3c", "group") %in% names(data))) {
    data <- dplyr::distinct(data, .data$iso3c, .keep_all = TRUE)
  }

  unmatched <- if ("iso3c" %in% names(data)) {
    key <- if ("country" %in% names(data)) "country" else "iso3c"
    miss <- data[is.na(data$iso3c), , drop = FALSE]
    tibble::tibble(country = as.character(miss[[key]]))
  } else {
    tibble::tibble(country = character(0))
  }

  if (is.null(indicator)) {
    num <- names(data)[vapply(data, is.numeric, logical(1))]
    indicator <- setdiff(num, c("year", "long", "lat", "group", "order",
                                "centroid_lon", "centroid_lat"))
  }
  na_rates <- tibble::tibble(
    indicator = indicator,
    n = nrow(data),
    n_missing = vapply(indicator, function(i) sum(is.na(data[[i]])), integer(1)),
    na_rate = vapply(indicator, function(i) mean(is.na(data[[i]])), numeric(1))
  )

  by_group <- if (by %in% names(data) && length(indicator)) {
    data %>%
      dplyr::group_by(.data[[by]]) %>%
      dplyr::summarise(
        n_countries = dplyr::n(),
        na_rate = mean(is.na(.data[[indicator[1]]])),
        .groups = "drop"
      ) %>%
      dplyr::arrange(dplyr::desc(.data$na_rate))
  } else {
    tibble::tibble()
  }

  structure(
    list(unmatched = unmatched, na_rates = na_rates, by_group = by_group),
    class = "wdj_coverage"
  )
}

#' @export
print.wdj_coverage <- function(x, ...) {
  cli::cli_h1("Coverage audit")
  n_un <- nrow(x$unmatched)
  if (n_un > 0L) {
    cli::cli_alert_warning("{n_un} unmatched countr{?y/ies}: {.val {x$unmatched$country}}")
  } else {
    cli::cli_alert_success("All countries matched to an ISO code.")
  }
  if (nrow(x$na_rates)) {
    cli::cli_h2("Missingness by indicator")
    print(x$na_rates)
  }
  if (nrow(x$by_group)) {
    cli::cli_h2("Coverage by group")
    print(x$by_group)
  }
  invisible(x)
}
