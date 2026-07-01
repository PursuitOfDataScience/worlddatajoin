test_that("country_join reconciles messy names on both sides", {
  a <- data.frame(country = c("Czechia", "South Korea"), gdp = c(1, 2))
  b <- data.frame(nation = c("Czech Republic", "Korea, Rep."), pop = c(10, 51))
  out <- country_join(a, b, country, nation)
  expect_equal(nrow(out), 2)
  expect_true(all(c("gdp", "pop", "iso3c") %in% names(out)))
  expect_equal(out$pop[out$iso3c == "CZE"], 10)
})

test_that("country_join supports inner and full joins", {
  a <- data.frame(c = c("France", "Germany"), x = 1:2)
  b <- data.frame(c = c("Germany", "Japan"), y = 1:2)
  expect_equal(nrow(country_join(a, b, c, c, type = "inner")), 1)
  expect_equal(nrow(country_join(a, b, c, c, type = "full")), 3)
})

test_that("join_world auto-detects the country column", {
  rates <- data.frame(country = c("United States", "Brazil", "Kenya"),
                      v = c(1, 2, 3))
  out <- join_world(rates, geometry = "none", warn = FALSE)
  expect_true("iso3c" %in% names(out))
  expect_equal(sort(out$iso3c), c("BRA", "KEN", "USA"))
})

test_that("attach_geometry bolts polygon geometry onto a country table", {
  skip_if_not_installed("maps")
  df <- data.frame(iso3c = c("USA", "CAN"), value = c(1, 2))
  out <- attach_geometry(df, geometry = "polygon")
  expect_true(all(c("long", "lat", "group", "value") %in% names(out)))
  expect_gt(nrow(out), 100)
  # Geometry is kept for the whole world (context), with values filled where
  # the table has them and NA elsewhere.
  expect_equal(out$value[out$iso3c == "USA"][1], 1)
  expect_true(any(is.na(out$value)))
})

test_that("country_join_all reduce-joins many messy tables on the ISO spine", {
  a <- data.frame(country = c("Czechia", "South Korea"), gdp = c(1, 2))
  b <- data.frame(country = c("Czech Republic", "Korea, Rep."), pop = c(10, 51))
  d <- data.frame(country = c("Czechia", "Korea"), area = c(79, 100))
  out <- country_join_all(list(a, b, d), by = "country")
  expect_equal(nrow(out), 2)
  expect_true(all(c("gdp", "pop", "area", "iso3c") %in% names(out)))
  expect_equal(out$pop[out$iso3c == "CZE"], 10)
  expect_equal(out$area[out$iso3c == "KOR"], 100)
})

test_that("country_join_all supports per-table origin specs", {
  a <- data.frame(code = c("CZE", "KOR"), gdp = c(1, 2))
  b <- data.frame(name = c("Czech Republic", "Korea, Rep."), pop = c(10, 51))
  out <- country_join_all(list(a, b), by = c("code", "name"),
                          origin = c("iso3c", "country.name"))
  expect_equal(nrow(out), 2)
  expect_true(all(c("gdp", "pop") %in% names(out)))
})

test_that("country_join_all supports inner and left joins", {
  a <- data.frame(c = c("France", "Germany"), x = 1:2)
  b <- data.frame(c = c("Germany", "Japan"), y = 1:2)
  expect_equal(nrow(country_join_all(list(a, b), by = "c", type = "inner")), 1)
  expect_equal(nrow(country_join_all(list(a, b), by = "c", type = "left")), 2)
})

test_that("country_join_all errors on bad input", {
  expect_error(country_join_all(list(), by = "x"), class = "countryatlas_error")
  expect_error(
    country_join_all(list(data.frame(a = "France")), by = "missing"),
    class = "countryatlas_error"
  )
})
