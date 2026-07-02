# Package index

## Core data assembly

One call to a map-ready table, the light analysis table, and bare
geometry.

- [`world_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_data.md)
  : Map-ready, enriched country tibble
- [`country_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_data.md)
  : Lightweight one-row-per-country table
- [`world_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_geometry.md)
  : Geometry without the data
- [`locate_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/locate_country.md)
  : Tag coordinates with the country that contains them
- [`country_borders()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_borders.md)
  : Country adjacency (shared land borders)
- [`neighbors()`](https://pursuitofdatascience.github.io/countryatlas/reference/neighbors.md)
  : A country's neighbours
- [`distance_between()`](https://pursuitofdatascience.github.io/countryatlas/reference/distance_between.md)
  : Great-circle distance between two countries

## The join engine

The package’s mission, exposed for your own data.

- [`standardize_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/standardize_country.md)
  : Add ISO codes and classifications to any data frame
- [`join_world()`](https://pursuitofdatascience.github.io/countryatlas/reference/join_world.md)
  : One call: your data, on a map
- [`attach_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/attach_geometry.md)
  : Attach geometry to a country-level table
- [`country_join()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_join.md)
  : Reconcile and join two messy country tables
- [`country_join_all()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_join_all.md)
  : Join many messy country tables on the ISO spine
- [`dissolve_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/dissolve_country.md)
  : Resolve dissolved entities to their successor states

## Diagnostics & data quality

Never lose a country silently.

- [`check_country_match()`](https://pursuitofdatascience.github.io/countryatlas/reference/check_country_match.md)
  : Pre-flight country-match report
- [`repair_country_names()`](https://pursuitofdatascience.github.io/countryatlas/reference/repair_country_names.md)
  : Auto-repair country names to their closest known match
- [`wdj_overrides()`](https://pursuitofdatascience.github.io/countryatlas/reference/wdj_overrides.md)
  [`country_overrides()`](https://pursuitofdatascience.github.io/countryatlas/reference/wdj_overrides.md)
  : Curated country-name overrides (replaces the silent drop-list)
- [`audit_coverage()`](https://pursuitofdatascience.github.io/countryatlas/reference/audit_coverage.md)
  : Coverage / missingness audit

## Reference data & code translation

- [`convert_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/convert_country.md)
  : Friendly country-code conversion
- [`country_codes()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_codes.md)
  : The countrycode codelist as a tidy tibble
- [`country_groups()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_groups.md)
  : Country-group membership
- [`in_group()`](https://pursuitofdatascience.github.io/countryatlas/reference/in_group.md)
  : Is a country in a group?
- [`wdi_search()`](https://pursuitofdatascience.github.io/countryatlas/reference/wdi_search.md)
  : Search World Bank indicators

## Analysis helpers

- [`per_capita()`](https://pursuitofdatascience.github.io/countryatlas/reference/per_capita.md)
  : Normalise an indicator by population
- [`aggregate_regions()`](https://pursuitofdatascience.github.io/countryatlas/reference/aggregate_regions.md)
  : Roll countries up to region / income / continent
- [`rank_countries()`](https://pursuitofdatascience.github.io/countryatlas/reference/rank_countries.md)
  : Add rank, percentile and z-score
- [`complete_years()`](https://pursuitofdatascience.github.io/countryatlas/reference/complete_years.md)
  : Fill or interpolate panel gaps
- [`growth_rate()`](https://pursuitofdatascience.github.io/countryatlas/reference/growth_rate.md)
  : Year-on-year (or compound) growth rate
- [`index_to()`](https://pursuitofdatascience.github.io/countryatlas/reference/index_to.md)
  : Rebase a series to an index (base year = 100)
- [`share_of_world()`](https://pursuitofdatascience.github.io/countryatlas/reference/share_of_world.md)
  : Each country's share of the world total
- [`lag_by_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/lag_by_country.md)
  [`diff_by_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/lag_by_country.md)
  : Panel lag / difference by country
- [`correlate_indicators()`](https://pursuitofdatascience.github.io/countryatlas/reference/correlate_indicators.md)
  : Pairwise correlation of indicators on the spine
- [`beta_convergence()`](https://pursuitofdatascience.github.io/countryatlas/reference/beta_convergence.md)
  : Beta convergence (growth regression)
- [`sigma_convergence()`](https://pursuitofdatascience.github.io/countryatlas/reference/sigma_convergence.md)
  : Sigma convergence (dispersion over time)
- [`gini()`](https://pursuitofdatascience.github.io/countryatlas/reference/gini.md)
  : Gini coefficient (population-weightable)
- [`theil()`](https://pursuitofdatascience.github.io/countryatlas/reference/theil.md)
  : Theil index, with between/within decomposition
- [`morans_i()`](https://pursuitofdatascience.github.io/countryatlas/reference/morans_i.md)
  : Global Moran's I (spatial autocorrelation)

## Visualization

A full vocabulary of projected, area-honest maps.

- [`world_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_map.md)
  : One-line choropleth, several honest styles
- [`globe_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/globe_map.md)
  : Orthographic globe choropleth
- [`spin_globe()`](https://pursuitofdatascience.github.io/countryatlas/reference/spin_globe.md)
  : Spin the globe
- [`facet_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/facet_map.md)
  : Small-multiple choropleths
- [`bubble_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/bubble_map.md)
  : Proportional-symbol (bubble) map
- [`spike_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/spike_map.md)
  : Spike map (heights at country centroids)
- [`bivariate_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/bivariate_map.md)
  : Two-variable bivariate choropleth
- [`cartogram_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/cartogram_map.md)
  : Area-honest cartogram
- [`dorling_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/dorling_map.md)
  : Dorling cartogram (first-class verb)
- [`tile_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/tile_map.md)
  : Equal-area world tile grid
- [`flow_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/flow_map.md)
  : Great-circle origin-destination flow map
- [`animate_world()`](https://pursuitofdatascience.github.io/countryatlas/reference/animate_world.md)
  : Animate a choropleth over time
- [`interactive_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/interactive_map.md)
  : Web-ready interactive choropleth
- [`geom_country_labels()`](https://pursuitofdatascience.github.io/countryatlas/reference/geom_country_labels.md)
  : Centroid-anchored country labels
- [`theme_world_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/theme_world_map.md)
  : A clean theme for world maps
- [`simplify_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/simplify_geometry.md)
  : Simplify (thin) geometry for faster plotting

## Database rendering (ggsql)

Hand curated tables to ggsql for database-side spatial rendering.

- [`as_ggsql_source()`](https://pursuitofdatascience.github.io/countryatlas/reference/as_ggsql_source.md)
  : Export a countryatlas table as a ggsql source
- [`world_query()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_query.md)
  : Emit a ggsql spatial query for a country map

## Performance & caching

- [`clear_wdi_cache()`](https://pursuitofdatascience.github.io/countryatlas/reference/clear_wdi_cache.md)
  : Clear the on-disk / in-memory WDI cache

## Bundled datasets

- [`world_snapshot`](https://pursuitofdatascience.github.io/countryatlas/reference/world_snapshot.md)
  : Offline snapshot of world data
- [`country_meta`](https://pursuitofdatascience.github.io/countryatlas/reference/country_meta.md)
  : Static per-country metadata
- [`common_indicators`](https://pursuitofdatascience.github.io/countryatlas/reference/common_indicators.md)
  : Curated indicator catalogue
- [`country_groups_tbl`](https://pursuitofdatascience.github.io/countryatlas/reference/country_groups_tbl.md)
  : Country-group membership (point-in-time)
- [`world_tiles`](https://pursuitofdatascience.github.io/countryatlas/reference/world_tiles.md)
  : Equal-area world tile-grid layout
- [`historical_codes`](https://pursuitofdatascience.github.io/countryatlas/reference/historical_codes.md)
  : Historical / dissolved entities and their successor states

## Package

- [`countryatlas`](https://pursuitofdatascience.github.io/countryatlas/reference/countryatlas-package.md)
  [`countryatlas-package`](https://pursuitofdatascience.github.io/countryatlas/reference/countryatlas-package.md)
  : countryatlas: join World Bank data, country codes and maps on the
  ISO spine
