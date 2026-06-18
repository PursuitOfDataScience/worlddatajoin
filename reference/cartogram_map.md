# Area-honest cartogram

Resizes countries by `weight` (population, GDP, ...) via the optional
`cartogram` package, defeating the "big empty countries dominate the
eye" bias of world choropleths.

## Usage

``` r
cartogram_map(
  data,
  weight,
  type = c("contiguous", "dorling", "noncontiguous"),
  fill = NULL,
  projection = "equal_earth"
)
```

## Arguments

- data:

  An `sf` map-ready frame.

- weight:

  The column to resize by (unquoted).

- type:

  `"contiguous"` (default), `"dorling"` or `"noncontiguous"`.

- fill:

  Optional fill column (unquoted); defaults to `weight`.

- projection:

  Projection (an equal-area CRS is recommended).

## Value

A `ggplot` object.

## Examples

``` r
if (FALSE) { # \dontrun{
world_data(2020, c(pop = "SP.POP.TOTL"), geometry = "sf") |>
  cartogram_map(pop, type = "dorling")
} # }
```
