# Two-variable bivariate choropleth

A 2-D bivariate choropleth with a built-in 2-D legend (via the optional
`biscale` package), e.g. GDP per capita x life expectancy in one map.

## Usage

``` r
bivariate_map(
  data,
  fill_x,
  fill_y,
  palette = "GrPink",
  dim = 3,
  projection = "equal_earth"
)
```

## Arguments

- data:

  An `sf` map-ready frame (use `geometry = "sf"`).

- fill_x, fill_y:

  The two value columns (unquoted).

- palette:

  A `biscale` palette name (default `"GrPink"`).

- dim:

  Bivariate dimension (2 or 3, default 3).

- projection:

  Projection.

## Value

A `ggplot` object (the map; combine with
[`biscale::bi_legend()`](https://chris-prener.github.io/biscale/reference/bi_legend.html)
for a standalone legend).

## Examples

``` r
if (FALSE) { # \dontrun{
world_data(2020, c(gdp = "NY.GDP.PCAP.KD", life = "SP.DYN.LE00.IN"),
           geometry = "sf") |>
  bivariate_map(gdp, life)
} # }
```
