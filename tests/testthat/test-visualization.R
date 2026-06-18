snap <- countryatlas::world_snapshot$countries

test_that("world_map builds a ggplot for several styles", {
  skip_if_not_installed("maps")
  mapdf <- attach_geometry(snap, geometry = "polygon")
  for (style in c("continuous", "binned", "quantile", "categorical")) {
    fill_col <- if (style == "categorical") "continent" else "gdp_per_capita"
    p <- world_map(mapdf, !!rlang::sym(fill_col), style = style)
    expect_s3_class(p, "ggplot")
    expect_silent(ggplot2::ggplot_build(p))
  }
})

test_that("bubble_map, tile_map and flow_map build", {
  skip_if_not_installed("maps")
  expect_s3_class(bubble_map(snap, population), "ggplot")
  expect_s3_class(tile_map(snap, gdp_per_capita), "ggplot")
  od <- data.frame(from = c("China", "Germany"),
                   to = c("United States", "France"), value = c(5, 2))
  expect_s3_class(flow_map(od, from, to, value), "ggplot")
})

test_that("geom_country_labels does not inherit the group aesthetic", {
  skip_if_not_installed("maps")
  mapdf <- attach_geometry(snap, geometry = "polygon")
  p <- world_map(mapdf, gdp_per_capita) + geom_country_labels(repel = FALSE)
  expect_silent(ggplot2::ggplot_build(p))
})

test_that("theme_world_map is a theme", {
  expect_s3_class(theme_world_map(), "theme")
})

test_that("sf-only plots error cleanly without sf", {
  skip_if(requireNamespace("sf", quietly = TRUE))
  expect_error(bivariate_map(snap, gdp_per_capita, life_expectancy))
})

test_that("great_circle returns the requested number of points", {
  gc <- countryatlas:::great_circle(0, 0, 90, 0, n = 25)
  expect_equal(nrow(gc), 25)
  expect_named(gc, c("lon", "lat"))
})
