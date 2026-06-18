# countryatlas: join World Bank data, country codes and maps on the ISO spine

`countryatlas` exists to kill one recurring source of pain: country
names never line up across data sources. The package makes ISO codes the
universal join key and hands you a ready-to-map tibble that stitches
together map geometry
([`ggplot2::map_data()`](https://ggplot2.tidyverse.org/reference/map_data.html)
or Natural Earth `sf`), World Bank indicators
([`WDI::WDI()`](https://rdrr.io/pkg/WDI/man/WDI.html)) and the
[`countrycode::countrycode()`](https://vincentarelbundock.github.io/countrycode/man/countrycode.html)
crosswalk.

## Details

The happy path stays one call:
[`world_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_data.md).
Everything else is opt-in.

## Core data assembly

[`world_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_data.md),
[`country_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_data.md),
[`world_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_geometry.md).

## The join engine

[`standardize_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/standardize_country.md),
[`join_world()`](https://pursuitofdatascience.github.io/countryatlas/reference/join_world.md),
[`attach_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/attach_geometry.md),
[`country_join()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_join.md).

## Diagnostics

[`check_country_match()`](https://pursuitofdatascience.github.io/countryatlas/reference/check_country_match.md),
[`wdj_overrides()`](https://pursuitofdatascience.github.io/countryatlas/reference/wdj_overrides.md),
[`audit_coverage()`](https://pursuitofdatascience.github.io/countryatlas/reference/audit_coverage.md).

## Reference data

[`convert_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/convert_country.md),
[`country_codes()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_codes.md),
[`country_groups()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_groups.md),
[`in_group()`](https://pursuitofdatascience.github.io/countryatlas/reference/in_group.md),
[`wdi_search()`](https://pursuitofdatascience.github.io/countryatlas/reference/wdi_search.md),
and the datasets
[country_meta](https://pursuitofdatascience.github.io/countryatlas/reference/country_meta.md),
[common_indicators](https://pursuitofdatascience.github.io/countryatlas/reference/common_indicators.md),
[country_groups_tbl](https://pursuitofdatascience.github.io/countryatlas/reference/country_groups_tbl.md),
[world_snapshot](https://pursuitofdatascience.github.io/countryatlas/reference/world_snapshot.md),
[world_tiles](https://pursuitofdatascience.github.io/countryatlas/reference/world_tiles.md).

## Analysis helpers

[`per_capita()`](https://pursuitofdatascience.github.io/countryatlas/reference/per_capita.md),
[`aggregate_regions()`](https://pursuitofdatascience.github.io/countryatlas/reference/aggregate_regions.md),
[`rank_countries()`](https://pursuitofdatascience.github.io/countryatlas/reference/rank_countries.md),
[`complete_years()`](https://pursuitofdatascience.github.io/countryatlas/reference/complete_years.md).

## Visualization

[`world_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_map.md),
[`bubble_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/bubble_map.md),
[`bivariate_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/bivariate_map.md),
[`cartogram_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/cartogram_map.md),
[`tile_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/tile_map.md),
[`flow_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/flow_map.md),
[`animate_world()`](https://pursuitofdatascience.github.io/countryatlas/reference/animate_world.md),
[`interactive_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/interactive_map.md),
[`geom_country_labels()`](https://pursuitofdatascience.github.io/countryatlas/reference/geom_country_labels.md),
[`theme_world_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/theme_world_map.md).

## See also

Useful links:

- <https://pursuitofdatascience.github.io/countryatlas/>

- <https://github.com/PursuitOfDataScience/countryatlas>

- Report bugs at
  <https://github.com/PursuitOfDataScience/countryatlas/issues>

## Author

**Maintainer**: Youzhi Yu <yuyouzhi666@icloud.com>
