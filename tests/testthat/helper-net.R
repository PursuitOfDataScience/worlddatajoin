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
