# Attach geometry to a country-level table

The bridge between a one-row-per-country table (e.g. from
[`country_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_data.md))
and plotting: bolts polygon or `sf` geometry onto your data, keyed on
`iso3c`.

## Usage

``` r
attach_geometry(
  data,
  by = "iso3c",
  geometry = c("polygon", "sf"),
  scale = "small",
  region = NULL,
  projection = "equal_earth",
  recenter = NULL
)
```

## Arguments

- data:

  A data frame with an `iso3c` (or `by`) column.

- by:

  The join key (default `"iso3c"`).

- geometry:

  `"polygon"` (default) or `"sf"`.

- scale:

  Natural Earth resolution for the `sf` backend.

- region:

  Optional region subset (see
  [`world_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_geometry.md)).

- projection, recenter:

  Projection options for the `sf` backend.

## Value

For `"polygon"`, a tibble with `long`/`lat`/`group` plus your columns.
For `"sf"`, an `sf` object.

## Examples

``` r
# \donttest{
df <- data.frame(iso3c = c("USA", "CAN"), value = c(1, 2))
if (requireNamespace("maps", quietly = TRUE)) {
  attach_geometry(df, geometry = "polygon")
}
#> ℹ `wdj_overrides()` is soft-deprecated; use `country_overrides()` instead.
#> This message is displayed once per session.
#> # A tibble: 99,338 × 9
#>     long   lat group order region subregion iso3c iso2c value
#>    <dbl> <dbl> <dbl> <int> <chr>  <chr>     <chr> <chr> <dbl>
#>  1 -69.9  12.5     1     1 Aruba  NA        ABW   AW       NA
#>  2 -69.9  12.4     1     2 Aruba  NA        ABW   AW       NA
#>  3 -69.9  12.4     1     3 Aruba  NA        ABW   AW       NA
#>  4 -70.0  12.5     1     4 Aruba  NA        ABW   AW       NA
#>  5 -70.1  12.5     1     5 Aruba  NA        ABW   AW       NA
#>  6 -70.1  12.6     1     6 Aruba  NA        ABW   AW       NA
#>  7 -70.0  12.6     1     7 Aruba  NA        ABW   AW       NA
#>  8 -70.0  12.6     1     8 Aruba  NA        ABW   AW       NA
#>  9 -69.9  12.5     1     9 Aruba  NA        ABW   AW       NA
#> 10 -69.9  12.5     1    10 Aruba  NA        ABW   AW       NA
#> # ℹ 99,328 more rows
# }
```
