test_that("check_country_match reports matches and misses", {
  out <- check_country_match(c("USA", "Cote d'Ivoire", "Yugoslavia", "Wakanda"))
  expect_s3_class(out, "tbl_df")
  expect_equal(out$matched, c(TRUE, TRUE, FALSE, FALSE))
  expect_equal(out$iso3c[1:2], c("USA", "CIV"))
  expect_true(is.na(out$iso3c[4]))
})

test_that("check_country_match suggests near misses when stringdist available", {
  skip_if_not_installed("stringdist")
  out <- check_country_match("Germny")
  expect_false(out$matched)
  expect_equal(out$suggestion, "Germany")
})

test_that("audit_coverage summarises missingness", {
  cov <- audit_coverage(world_snapshot$countries)
  expect_s3_class(cov, "countryatlas_coverage")
  expect_true(all(c("unmatched", "na_rates", "by_group") %in% names(cov)))
  expect_true("gdp_per_capita" %in% cov$na_rates$indicator)
  expect_true(all(cov$na_rates$na_rate >= 0 & cov$na_rates$na_rate <= 1))
})
