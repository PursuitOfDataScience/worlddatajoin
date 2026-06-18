#' worlddatajoin: join World Bank data, country codes and maps on the ISO spine
#'
#' `worlddatajoin` exists to kill one recurring source of pain: country names
#' never line up across data sources. The package makes ISO codes the universal
#' join key and hands you a ready-to-map tibble that stitches together map
#' geometry ([ggplot2::map_data()] or Natural Earth `sf`), World Bank indicators
#' ([WDI::WDI()]) and the [countrycode::countrycode()] crosswalk.
#'
#' The happy path stays one call: [world_data()]. Everything else is opt-in.
#'
#' @section Core data assembly:
#' [world_data()], [country_data()], [world_geometry()].
#'
#' @section The join engine:
#' [standardize_country()], [join_world()], [attach_geometry()], [country_join()].
#'
#' @section Diagnostics:
#' [check_country_match()], [wdj_overrides()], [audit_coverage()].
#'
#' @section Reference data:
#' [convert_country()], [country_codes()], [country_groups()], [in_group()],
#' [wdi_search()], and the datasets [country_meta], [common_indicators],
#' [country_groups_tbl], [world_snapshot], [world_tiles].
#'
#' @section Analysis helpers:
#' [per_capita()], [aggregate_regions()], [rank_countries()], [complete_years()].
#'
#' @section Visualization:
#' [world_map()], [bubble_map()], [bivariate_map()], [cartogram_map()],
#' [tile_map()], [flow_map()], [animate_world()], [interactive_map()],
#' [geom_country_labels()], [theme_world_map()].
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom rlang .data %||% :=
#' @importFrom dplyr %>%
## usethis namespace: end
NULL

# Quiet R CMD check for tidy-eval column references and bundled datasets
# referenced by name inside the package.
utils::globalVariables(c(
  ".", ".data", "region", "long", "lat", "group", "order", "subregion",
  "country", "iso2c", "iso3c", "income", "continent", "year",
  "NY.GDP.PCAP.KD", "gdp_per_capita_2015", "value", "name", "indicator",
  "rank", "percentile", "z_score", "geometry", "centroid_lon", "centroid_lat",
  "country_groups_tbl", "world_tiles"
))
