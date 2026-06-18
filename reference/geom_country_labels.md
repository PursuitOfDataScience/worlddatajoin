# Centroid-anchored country labels

A `ggplot2` layer that places labels (names, ISO codes or flag emoji) at
country centroids, with optional `ggrepel` collision avoidance. Designed
for the polygon backend produced by
[`world_data()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_data.md)
/
[`join_world()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/join_world.md).

## Usage

``` r
geom_country_labels(mapping = NULL, repel = TRUE, flag = FALSE, size = 3, ...)
```

## Arguments

- mapping:

  Aesthetic mapping; defaults to `aes(label = iso3c)`.

- repel:

  Use `ggrepel` to avoid overlaps (default `TRUE`).

- flag:

  If `TRUE`, label with flag emoji instead of the mapped label.

- size:

  Label text size.

- ...:

  Passed to the underlying text geom.

## Value

A `ggplot2` layer.

## Examples

``` r
# \donttest{
library(ggplot2)
snap <- worlddatajoin::world_snapshot$countries
if (requireNamespace("maps", quietly = TRUE)) {
  mapdf <- attach_geometry(snap, geometry = "polygon")
  world_map(mapdf, gdp_per_capita) + geom_country_labels()
}

# }
```
