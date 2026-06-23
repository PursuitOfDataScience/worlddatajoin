# countryatlas 1.1.0

A feature release that wires countryatlas into the database-rendering world via
'ggsql', widens the map vocabulary, and fixes several correctness issues found
by auditing 1.0.0.

## New: database-side rendering with ggsql

* `as_ggsql_source()` exports a curated, ISO-reconciled, WDI-joined table (with
  `sf` geometry WKB-encoded) as a [ggsql](https://ggsql.org) source — a DuckDB
  connection, a Parquet file, or a nanoarrow stream. countryatlas does the
  reconciliation ggsql's static bundled world can't; ggsql does the database
  push-down and Vega-Lite output countryatlas doesn't.
* `world_query()` emits a `ggsql` spatial query (`VISUALISE … DRAW spatial
  PROJECT TO … SCALE … LABEL …`) — a dependency-free string builder.
* `interactive_map(engine = "ggsql")` registers the data and renders the map in
  DuckDB, returning a Vega-Lite widget.
* `ggsql`, `duckdb`, `DBI` and `nanoarrow` are optional `Suggests`. See the new
  *countryatlas and ggsql* vignette.

## New: maps, projections and helpers

* `globe_map()` — an orthographic globe choropleth.
* `facet_map()` — small-multiple choropleths (the static counterpart to
  `animate_world()`).
* `wdj_crs()` gains eight projections (`mercator`, `winkel_tripel`, `eckert4`,
  `gall_peters`, `orthographic`, `azimuthal_equal_area`, `north_polar`,
  `south_polar`); `world_map()` / `world_geometry()` accept them all.
* `locate_country()` — point-in-polygon lookup tagging `lon`/`lat` with `iso3c`.
* `repair_country_names()` — the "act on it" companion to
  `check_country_match()`: auto-applies confident string-distance fixes.
* `country_join_all()` — reduce-join many messy country tables on the ISO spine.
* `growth_rate()`, `index_to()`, `share_of_world()` — panel analysis helpers.
* `country_overrides()` — preferred name for `wdj_overrides()` (kept as an
  alias) after the rename to countryatlas.
* `country_groups_tbl` gains `Mercosur`, `GCC`, `Nordic` and `Visegrad`.

## Bug fixes

* `world_map(style = "quantile"/"jenks")` computed breaks over polygon
  **vertices**, so a country's geometric complexity biased the quantiles and the
  bins held unequal numbers of countries. Breaks are now computed on one value
  per country.
* `bubble_map(backend = "sf")` placed bubbles in projected metres on a degrees
  base map (off the map). The base map and bubbles now share one projected CRS
  via `coord_sf()`.
* Polygon centroids returned more than one row for ten `iso3c` codes (overrides
  map several names — Azores/Madeira → PRT — to one code), fanning out joins in
  `bubble_map()` / `flow_map()`. Centroids are now one antimeridian-safe row per
  country (the largest piece).
* `geom_country_labels()` placed labels at the bounding-box midpoint over all of
  a country's pieces, so the US / Fiji / NZ labels drifted into the wrong ocean.
  Labels now sit on each country's largest piece.
* `projection = "plate_carree"` built an incoherent PROJ string
  (`+proj=longlat … +units=m`); it is now true equirectangular (`+proj=eqc`).
* `convert_country()` only applied `wdj_overrides()` for `to = "iso3c"`, so
  override-only entities (e.g. "Canary Islands") returned `NA` for derived
  destinations. It now routes through the corrected `iso3c` first.

# countryatlas 1.0.0

A single, comprehensive release that takes the package from a one-function proof
of concept to a complete toolkit for joining world data to maps. The spirit is
unchanged — *ISO codes as the universal join key, one call to a map-ready
table* — but pushed to its full potential.

## Breaking-ish changes

* `world_data()` is generalised but backward-compatible: `world_data(2020)`
  still returns the classic polygon-backed, GDP-per-capita tibble. The only
  visible change is the column name `gdp_per_capita_2015` → `gdp_per_capita`.
  A one-cycle deprecation shim keeps `gdp_per_capita_2015` available as an alias
  (toggle with `options(countryatlas.gdp_compat = FALSE)`).
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

# countryatlas 0.1.0

* Initial experimental release with a single `world_data(year)` function.
