# Skip a test when the World Bank API is unreachable (and always on CRAN), so
# the suite is deterministic and offline-safe.
skip_if_offline_wb <- function() {
  testthat::skip_on_cran()
  ok <- tryCatch({
    con <- url("https://api.worldbank.org/v2/country?format=json&per_page=1")
    on.exit(close(con))
    length(readLines(con, n = 1, warn = FALSE)) > 0
  }, error = function(e) FALSE)
  if (!isTRUE(ok)) testthat::skip("World Bank API not reachable")
}

# Skip (rather than fail) when a World Bank fetch came back empty despite the
# reachability probe passing. The live multi-indicator fetch can still flake
# transiently (timeouts, rate limits, a forked worker dying), which must
# degrade to a skip, not a red suite -- consistent with CRAN's policy that
# tests do not fail on unavailable internet resources.
skip_if_wdi_empty <- function(data, cols) {
  ok <- all(cols %in% names(data)) &&
    all(vapply(cols, function(cl) any(!is.na(data[[cl]])), logical(1)))
  if (!isTRUE(ok)) testthat::skip("World Bank fetch returned no data")
}
