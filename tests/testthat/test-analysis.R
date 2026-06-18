test_that("per_capita divides by a supplied population column", {
  df <- data.frame(iso3c = c("USA", "CHN"), year = 2020L,
                   co2 = c(5e6, 1e7), pop = c(331e6, 1402e6))
  out <- per_capita(df, co2, pop)
  expect_true("co2_per_capita" %in% names(out))
  expect_equal(out$co2_per_capita, df$co2 / df$pop)
})

test_that("aggregate_regions rolls up with sum and weighted mean", {
  df <- data.frame(
    iso3c = c("USA", "CAN", "BRA"),
    region = c("NA", "NA", "LAC"),
    gdp = c(21, 1.7, 1.4),
    pop = c(331, 38, 213)
  )
  s <- aggregate_regions(df, gdp, by = "region", fun = "sum")
  expect_equal(s$gdp[s$region == "NA"], 22.7)

  w <- aggregate_regions(df, gdp, by = "region", fun = "weighted_mean", weight = pop)
  expect_equal(
    w$gdp[w$region == "NA"],
    stats::weighted.mean(c(21, 1.7), c(331, 38))
  )
  expect_error(aggregate_regions(df, gdp, fun = "weighted_mean"),
               class = "worlddatajoin_error")
})

test_that("rank_countries adds rank, percentile, z-score", {
  df <- data.frame(iso3c = c("A", "B", "C"), v = c(3, 1, 2))
  out <- rank_countries(df, v)
  expect_equal(out$rank, c(1, 3, 2))
  expect_true(all(c("percentile", "z_score") %in% names(out)))
})

test_that("complete_years fills a panel by interpolation", {
  df <- data.frame(iso3c = "USA", year = c(2000L, 2002L), gdp = c(1, 3))
  out <- complete_years(df, 2000:2002, method = "linear")
  expect_equal(nrow(out), 3)
  expect_equal(out$gdp[out$year == 2001], 2)
})

test_that("complete_years locf carries forward", {
  df <- data.frame(iso3c = "USA", year = c(2000L, 2002L), gdp = c(1, NA))
  out <- complete_years(df, 2000:2002, method = "locf")
  expect_equal(out$gdp, c(1, 1, 1))
})
