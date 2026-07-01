# Bundled datasets --------------------------------------------------------------

#' Offline snapshot of world data
#'
#' A small, lazy-loaded snapshot of a curated indicator set for one recent year,
#' as both a country-level tibble and a low-resolution `sf` object. It lets every
#' example, test and vignette run offline and deterministically, without the
#' World Bank API.
#'
#' @format A list with two elements:
#' \describe{
#'   \item{countries}{A tibble, one row per country, with `iso3c`, `iso2c`,
#'     `country`, classifications and curated indicators
#'     (`gdp_per_capita`, `population`, `life_expectancy`, `co2_per_capita`).}
#'   \item{sf}{A low-resolution `sf` object with the same per-country columns and
#'     a `geometry` column (Natural Earth 110m). Present only if `sf` was
#'     available when the package was built.}
#'   \item{year}{The reference year.}
#' }
#' @source World Bank via \pkg{WDI}; geometry from Natural Earth via
#'   \pkg{rnaturalearth}. Snapshot year: 2024.
"world_snapshot"

#' Static per-country metadata
#'
#' One row per country with the facts people constantly need and currently
#' scrape together by hand.
#'
#' @format A tibble with one row per country and columns including `iso3c`,
#'   `iso2c`, `country`, `continent`, `region`, `un_region`, `capital`,
#'   `capital_lat`, `capital_lon`, `centroid_lat`, `centroid_lon`, `area_km2`,
#'   `currency`, `tld`, `landlocked`, `flag`.
#' @source Assembled from \pkg{countrycode}, \pkg{WDI} metadata and Natural
#'   Earth geometry.
"country_meta"

#' Curated indicator catalogue
#'
#' A friendly-name to WDI-code lookup so `indicator = common_indicators$population`
#' beats memorising `"SP.POP.TOTL"`.
#'
#' @format A tibble with columns `name` (friendly name), `code` (WDI indicator
#'   code) and `description`.
#' @source World Bank indicator catalogue.
"common_indicators"

#' Country-group membership (point-in-time)
#'
#' A curated, dated membership table for the common country groups.
#'
#' @format A tibble with columns `group`, `iso3c`, `country`.
#' @source Curated from official membership lists (point-in-time; see the
#'   package `NEWS` for the reference date).
"country_groups_tbl"

#' Equal-area world tile-grid layout
#'
#' A statebins-style equal-area tile layout: one square per country, positioned
#' on a `row`/`col` grid derived from country centroids. Used by [tile_map()].
#'
#' @format A tibble with columns `iso3c`, `country`, `row`, `col`.
#' @source Derived from Natural Earth country centroids.
"world_tiles"
