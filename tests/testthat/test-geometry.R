test_that("distance_between computes great-circle distance (no sf needed)", {
  d <- distance_between("France", "Germany")
  expect_type(d, "double")
  expect_gt(d, 0)
  # Paris–Berlin ~ 878 km, centroids should be in that ballpark
  expect_gt(d, 500)
  expect_lt(d, 1500)
})

test_that("distance_between recycles vectors", {
  d <- distance_between("USA", c("Canada", "Mexico"))
  expect_length(d, 2)
  expect_true(all(d > 0))
})

test_that("distance_between resolves via iso3c", {
  d1 <- distance_between("France", "Germany")
  d2 <- distance_between("FRA", "DEU", origin = "iso3c")
  expect_equal(d1, d2)
})

test_that("distance_between returns NA for unknown countries", {
  d <- distance_between("France", "Atlantis")
  expect_true(is.na(d))
})

test_that("distance_between works on vectors of length 1 (no recycling)", {
  # Identical country -> zero distance
  d <- distance_between("France", "France")
  expect_true(abs(d) < 1e-9)
})

test_that("locate_country tags known capitals", {
  skip_if_not_installed("sf")
  skip_if_not_installed("rnaturalearth")
  out <- locate_country(lon = c(2.35, -74.0, 139.7), lat = c(48.85, 40.7, 35.7))
  # Paris, New York, Tokyo
  expect_equal(out$iso3c, c("FRA", "USA", "JPN"))
  expect_equal(out$country, c("France", "United States", "Japan"))
})

test_that("locate_country returns NA for open ocean", {
  skip_if_not_installed("sf")
  skip_if_not_installed("rnaturalearth")
  out <- locate_country(lon = -30, lat = -30)   # open Atlantic
  expect_true(is.na(out$iso3c))
})

test_that("locate_country supports extra attributes", {
  skip_if_not_installed("sf")
  skip_if_not_installed("rnaturalearth")
  out <- locate_country(lon = 2.35, lat = 48.85, add = c("country", "continent"))
  expect_equal(out$country, "France")
  expect_equal(out$continent, "Europe")
})

test_that("locate_country errors on mismatched lon/lat lengths", {
  skip_if_not_installed("sf")
  expect_error(locate_country(lon = 1:2, lat = 1), class = "countryatlas_error")
})

test_that("country_borders returns a tidy edge list", {
  skip_if_not_installed("sf")
  skip_if_not_installed("rnaturalearth")
  edges <- country_borders()
  expect_s3_class(edges, "tbl_df")
  expect_true(all(c("iso3c_a", "country_a", "iso3c_b", "country_b") %in% names(edges)))
  # France borders Germany
  fra_deu <- dplyr::filter(
    edges,
    (.data$iso3c_a == "FRA" & .data$iso3c_b == "DEU") |
    (.data$iso3c_a == "DEU" & .data$iso3c_b == "FRA")
  )
  expect_equal(nrow(fra_deu), 1)
})

test_that("country_borders never lists a country bordering itself", {
  skip_if_not_installed("sf")
  skip_if_not_installed("rnaturalearth")
  edges <- country_borders()
  expect_false(any(edges$iso3c_a == edges$iso3c_b))
})

test_that("neighbors lists a country's bordering countries", {
  skip_if_not_installed("sf")
  skip_if_not_installed("rnaturalearth")
  nbr <- neighbors("France")
  expect_s3_class(nbr, "tbl_df")
  expect_true("DEU" %in% nbr$neighbor)
  expect_true("ESP" %in% nbr$neighbor)
})

test_that("neighbors returns zero rows for islands", {
  skip_if_not_installed("sf")
  skip_if_not_installed("rnaturalearth")
  nbr <- neighbors("Japan")
  expect_equal(nrow(nbr), 0)
})

test_that("polygon_centroids returns one centroid per iso3c", {
  # Bug 3.3: PRT / ESP / BES must each produce ONE row, not multiple.
  skip_if_not_installed("maps")
  poly <- countryatlas:::world_polygons()
  cent <- countryatlas:::polygon_centroids(poly)
  # Every iso3c appears exactly once
  expect_equal(anyDuplicated(cent$iso3c), 0)
  # Known multi-piece countries must have exactly one centroid row
  expect_equal(nrow(dplyr::filter(cent, .data$iso3c == "PRT")), 1)
  expect_equal(nrow(dplyr::filter(cent, .data$iso3c == "ESP")), 1)
  expect_equal(nrow(dplyr::filter(cent, .data$iso3c == "BES")), 1)
})
