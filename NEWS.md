# worlddatajoin 1.0.0

A single, comprehensive release that takes the package from a one-function proof
of concept to a complete toolkit for joining world data to maps. The spirit is
unchanged — *ISO codes as the universal join key, one call to a map-ready
table* — but pushed to its full potential.

## Breaking-ish changes

* `world_data()` is generalised but backward-compatible: `world_data(2020)`
  still returns the classic polygon-backed, GDP-per-capita tibble. The only
  visible change is the column name `gdp_per_capita_2015` → `gdp_per_capita`.
  A one-cycle deprecation shim keeps `gdp_per_capita_2015` available as an alias
  (toggle with `options(worlddatajoin.gdp_compat = FALSE)`).
* The 16 regions the previous version silently dropped (Kosovo, Micronesia, the
  Virgin Islands, Saint Martin, Bonaire/Saba/Sint Eustatius, the Canary Islands,
  Madeira/Azores, …) are now **matched** via [`wdj_overrides()`] instead of
  deleted, so they appear on maps. Diffs of map output will show increased
  coverage.

## New: core data assembly

* `world_data()` gains `indicator` (one or many WDI codes; named vectors drive
  clean column names), multi-year **panels**, an `sf` backend
  (`geometry = "sf"`), `region` subsetting, `latest`, projections and caching.
* `country_data()` — the lightweight, one-row-per-country analysis table.
* `world_geometry()` — projected, region-subset geometry (countries, centroids,
  coastline, borders, graticule, ocean).

## New: the join engine (exposed for *your* data)

* `standardize_country()`, `join_world()`, `attach_geometry()`, `country_join()`.

## New: diagnostics

* `check_country_match()`, `wdj_overrides()`, `audit_coverage()` — never lose a
  country silently.

## New: reference data & translation

* `convert_country()` (flags, currency, tld, research codes), `country_codes()`,
  `country_groups()` / `in_group()`, `wdi_search()`.
* Bundled datasets: `world_snapshot`, `country_meta`, `common_indicators`,
  `country_groups_tbl`, `world_tiles`.

## New: analysis helpers

* `per_capita()`, `aggregate_regions()`, `rank_countries()`, `complete_years()`.

## New: visualization

* `world_map()` (continuous / binned / quantile / jenks / categorical),
  `bubble_map()`, `bivariate_map()`, `cartogram_map()`, `tile_map()`,
  `flow_map()`, `animate_world()`, `interactive_map()`, `geom_country_labels()`,
  `theme_world_map()`.

## Performance & offline

* WDI fetches are memoised with an optional on-disk cache; multiple indicators
  are fetched in parallel (`parallel::mclapply`) where supported.
  See `clear_wdi_cache()`.
* The bundled `world_snapshot` lets every example, test and vignette run offline
  and deterministically.

## Engineering

* Namespace hygiene (targeted `@importFrom` instead of blanket `@import`).
* Input validation with friendly `cli` / `rlang` errors.
* A `testthat` (3e) suite; network calls are skipped offline and on CRAN.
* Vignettes and a `pkgdown` site.
* Refreshed CI: R-CMD-check, test-coverage and pkgdown workflows.
* Heavy spatial dependencies (`sf`, `rnaturalearth`, `cartogram`, `biscale`,
  `geofacet`, `gganimate`, `leaflet`, …) are all in `Suggests` and gated by
  `rlang::check_installed()`, so the base install stays light.

Group memberships in `country_groups_tbl` are point-in-time as of 2024-01-01.

# worlddatajoin 0.1.0

* Initial experimental release with a single `world_data(year)` function.
