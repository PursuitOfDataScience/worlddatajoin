# Offline snapshot of world data

A small, lazy-loaded snapshot of a curated indicator set for one recent
year, as both a country-level tibble and a low-resolution `sf` object.
It lets every example, test and vignette run offline and
deterministically, without the World Bank API.

## Usage

``` r
world_snapshot
```

## Format

A list with two elements:

- countries:

  A tibble, one row per country, with `iso3c`, `iso2c`, `country`,
  classifications and curated indicators (`gdp_per_capita`,
  `population`, `life_expectancy`, `co2_per_capita`).

- sf:

  A low-resolution `sf` object with the same per-country columns and a
  `geometry` column (Natural Earth 110m). Present only if `sf` was
  available when the package was built.

- year:

  The reference year.

## Source

World Bank via WDI; geometry from Natural Earth via rnaturalearth.
