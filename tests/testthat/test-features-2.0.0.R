# Tests for functionality added in 2.0.0.

test_that("growth_rate computes yoy and cagr per country", {
  df <- data.frame(iso3c = "USA", year = 2000:2002, gdp = c(100, 110, 121))
  g <- growth_rate(df, gdp)
  expect_equal(g$gdp_growth, c(NA, 0.1, 0.1))
  cg <- growth_rate(df, gdp, type = "cagr")
  expect_equal(round(cg$gdp_growth[3], 4), 0.1)
})

test_that("index_to rebases each country to the base year", {
  df <- data.frame(iso3c = "USA", year = 2000:2002, gdp = c(50, 55, 60))
  out <- index_to(df, gdp, base_year = 2000)
  expect_equal(out$gdp_index, c(100, 110, 120))
})

test_that("share_of_world sums to one within a year", {
  df <- data.frame(iso3c = c("USA", "CHN"), co2 = c(5, 15))
  out <- share_of_world(df, co2)
  expect_equal(out$co2_share, c(0.25, 0.75))
})

test_that("country_join_all reduce-joins many messy tables", {
  a <- data.frame(country = c("Czechia", "South Korea"), gdp = c(1, 2))
  b <- data.frame(country = c("Czech Republic", "Korea, Rep."), pop = c(10, 51))
  d <- data.frame(country = c("Czechia", "Korea"), area = c(79, 100))
  out <- country_join_all(list(a, b, d), by = "country")
  expect_true(all(c("gdp", "pop", "area", "iso3c") %in% names(out)))
  expect_equal(nrow(out), 2)
  expect_equal(out$area[out$iso3c == "CZE"], 79)
})

test_that("repair_country_names fixes confident misses", {
  # Threshold loosened so the test holds with either stringdist or the
  # base-R adist fallback.
  out <- repair_country_names(c("United States", "Brzil", "Germny"),
                              threshold = 0.3, verbose = FALSE)
  expect_equal(as.character(out), c("United States", "Brazil", "Germany"))
  expect_s3_class(attr(out, "repairs"), "tbl_df")
  expect_equal(nrow(attr(out, "repairs")), 2L)
})

test_that("convert_country routes overrides through iso3c for all destinations", {
  expect_equal(convert_country("Canary Islands", to = "iso3c"), "ESP")
  expect_equal(convert_country("Canary Islands", to = "continent"), "Europe")
  expect_equal(convert_country(c("Japan", "Brazil"), to = "flag"),
               c("\U0001F1EF\U0001F1F5", "\U0001F1E7\U0001F1F7"))
})

test_that("new country groups are present and correctly sized", {
  expect_equal(nrow(country_groups("GCC")), 6)
  expect_equal(nrow(country_groups("Nordic")), 5)
  expect_equal(nrow(country_groups("Visegrad")), 4)
  expect_true("BRA" %in% country_groups("Mercosur")$iso3c)
  # Existing groups unchanged.
  expect_equal(nrow(country_groups("EU")), 27)
})

test_that("country_overrides is an alias of wdj_overrides", {
  expect_identical(country_overrides(), wdj_overrides())
  expect_equal(unname(country_overrides(c(Somaliland = "SOM"))[["Somaliland"]]),
               "SOM")
})

test_that("plate_carree is equirectangular and new projections build", {
  expect_match(countryatlas:::wdj_crs("plate_carree"), "proj=eqc")
  expect_false(grepl("proj=longlat", countryatlas:::wdj_crs("plate_carree")))
  expect_match(countryatlas:::wdj_crs("winkel_tripel"), "proj=wintri")
  expect_match(countryatlas:::wdj_crs("orthographic", lat0 = 30), "lat_0=30")
})

test_that("polygon centroids are one antimeridian-safe row per iso3c", {
  skip_if_not_installed("maps")
  cent <- world_geometry("centroids", geometry = "polygon")
  expect_equal(anyDuplicated(cent$iso3c), 0L)
  # USA centroid sits on the contiguous landmass, not pulled to ~0 by Alaska.
  usa_lon <- cent$centroid_lon[cent$iso3c == "USA"]
  expect_lt(usa_lon, -60)
})
