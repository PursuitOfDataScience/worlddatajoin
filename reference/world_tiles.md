# Equal-area world tile-grid layout

A statebins-style equal-area tile layout: one square per country,
positioned on a `row`/`col` grid derived from country centroids. Used by
[`tile_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/tile_map.md).

## Usage

``` r
world_tiles
```

## Format

A tibble with columns `iso3c`, `country`, `row`, `col`.

## Source

Derived from Natural Earth country centroids.
