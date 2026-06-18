test_that("standardize_country adds ISO codes and classifications", {
  df <- data.frame(nation = c("U.S.", "S. Korea", "Czechia"), value = 1:3)
  out <- standardize_country(df, nation, warn = FALSE)
  expect_s3_class(out, "tbl_df")
  expect_equal(out$iso3c, c("USA", "KOR", "CZE"))
  expect_equal(out$iso2c, c("US", "KR", "CZ"))
  expect_true(all(c("continent", "region") %in% names(out)))
  expect_equal(out$value, 1:3)
})

test_that("overrides match entities the legacy code dropped", {
  df <- data.frame(region = c("Kosovo", "Micronesia", "Virgin Islands",
                              "Canary Islands", "Saint Martin"))
  out <- standardize_country(df, region, warn = FALSE)
  expect_equal(out$iso3c, c("XKX", "FSM", "VIR", "ESP", "MAF"))
  # Kosovo's continent/region come from the fallback table.
  expect_equal(out$continent[out$iso3c == "XKX"], "Europe")
  expect_false(is.na(out$region[out$iso3c == "XKX"]))
})

test_that("wdj_overrides is extensible", {
  ov <- wdj_overrides(c(Somaliland = "SOM"))
  expect_equal(unname(ov[["Somaliland"]]), "SOM")
  expect_equal(unname(ov[["Kosovo"]]), "XKX")
})

test_that("standardize_country errors on missing column", {
  expect_error(standardize_country(data.frame(a = 1), nope, warn = FALSE),
               class = "countryatlas_error")
})

test_that("standardize_country warns on unmatched", {
  df <- data.frame(x = c("United States", "Wakanda"))
  expect_warning(standardize_country(df, x), class = "countryatlas_warning")
})
