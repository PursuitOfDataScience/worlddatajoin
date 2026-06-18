# Changelog

## countryatlas 1.0.0

A single, comprehensive release that takes the package from a
one-function proof of concept to a complete toolkit for joining world
data to maps. The spirit is unchanged — *ISO codes as the universal join
key, one call to a map-ready table* — but pushed to its full potential.

### Breaking-ish changes

- [`world_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_data.md)
  is generalised but backward-compatible: `world_data(2020)` still
  returns the classic polygon-backed, GDP-per-capita tibble. The only
  visible change is the column name `gdp_per_capita_2015` →
  `gdp_per_capita`. A one-cycle deprecation shim keeps
  `gdp_per_capita_2015` available as an alias (toggle with
  `options(countryatlas.gdp_compat = FALSE)`).
- The 16 regions the previous version silently dropped (Kosovo,
  Micronesia, the Virgin Islands, Saint Martin, Bonaire/Saba/Sint
  Eustatius, the Canary Islands, Madeira/Azores, …) are now **matched**
  via
  \[[`wdj_overrides()`](https://pursuitofdatascience.github.io/countryatlas/reference/wdj_overrides.md)\]
  instead of deleted, so they appear on maps. Diffs of map output will
  show increased coverage.

### New: core data assembly

- [`world_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_data.md)
  gains `indicator` (one or many WDI codes; named vectors drive clean
  column names), multi-year **panels**, an `sf` backend
  (`geometry = "sf"`), `region` subsetting, `latest`, projections and
  caching.
- [`country_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_data.md)
  — the lightweight, one-row-per-country analysis table.
- [`world_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_geometry.md)
  — projected, region-subset geometry (countries, centroids, coastline,
  borders, graticule, ocean).

### New: the join engine (exposed for *your* data)

- [`standardize_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/standardize_country.md),
  [`join_world()`](https://pursuitofdatascience.github.io/countryatlas/reference/join_world.md),
  [`attach_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/attach_geometry.md),
  [`country_join()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_join.md).

### New: diagnostics

- [`check_country_match()`](https://pursuitofdatascience.github.io/countryatlas/reference/check_country_match.md),
  [`wdj_overrides()`](https://pursuitofdatascience.github.io/countryatlas/reference/wdj_overrides.md),
  [`audit_coverage()`](https://pursuitofdatascience.github.io/countryatlas/reference/audit_coverage.md)
  — never lose a country silently.

### New: reference data & translation

- [`convert_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/convert_country.md)
  (flags, currency, tld, research codes),
  [`country_codes()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_codes.md),
  [`country_groups()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_groups.md)
  /
  [`in_group()`](https://pursuitofdatascience.github.io/countryatlas/reference/in_group.md),
  [`wdi_search()`](https://pursuitofdatascience.github.io/countryatlas/reference/wdi_search.md).
- Bundled datasets: `world_snapshot`, `country_meta`,
  `common_indicators`, `country_groups_tbl`, `world_tiles`.

### New: analysis helpers

- [`per_capita()`](https://pursuitofdatascience.github.io/countryatlas/reference/per_capita.md),
  [`aggregate_regions()`](https://pursuitofdatascience.github.io/countryatlas/reference/aggregate_regions.md),
  [`rank_countries()`](https://pursuitofdatascience.github.io/countryatlas/reference/rank_countries.md),
  [`complete_years()`](https://pursuitofdatascience.github.io/countryatlas/reference/complete_years.md).

### New: visualization

- [`world_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_map.md)
  (continuous / binned / quantile / jenks / categorical),
  [`bubble_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/bubble_map.md),
  [`bivariate_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/bivariate_map.md),
  [`cartogram_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/cartogram_map.md),
  [`tile_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/tile_map.md),
  [`flow_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/flow_map.md),
  [`animate_world()`](https://pursuitofdatascience.github.io/countryatlas/reference/animate_world.md),
  [`interactive_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/interactive_map.md),
  [`geom_country_labels()`](https://pursuitofdatascience.github.io/countryatlas/reference/geom_country_labels.md),
  [`theme_world_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/theme_world_map.md).

### Performance & offline

- WDI fetches are memoised with an optional on-disk cache; multiple
  indicators are fetched in parallel
  ([`parallel::mclapply`](https://rdrr.io/r/parallel/mclapply.html))
  where supported. See
  [`clear_wdi_cache()`](https://pursuitofdatascience.github.io/countryatlas/reference/clear_wdi_cache.md).
- The bundled `world_snapshot` lets every example, test and vignette run
  offline and deterministically.

### Engineering

- Namespace hygiene (targeted `@importFrom` instead of blanket
  `@import`).
- Input validation with friendly `cli` / `rlang` errors.
- A `testthat` (3e) suite; network calls are skipped offline and on
  CRAN.
- Vignettes and a `pkgdown` site.
- Refreshed CI: R-CMD-check, test-coverage and pkgdown workflows.
- Heavy spatial dependencies (`sf`, `rnaturalearth`, `cartogram`,
  `biscale`, `geofacet`, `gganimate`, `leaflet`, …) are all in
  `Suggests` and gated by
  [`rlang::check_installed()`](https://rlang.r-lib.org/reference/is_installed.html),
  so the base install stays light.

Group memberships in `country_groups_tbl` are point-in-time as of
2024-01-01.

## countryatlas 0.1.0

- Initial experimental release with a single `world_data(year)`
  function.
