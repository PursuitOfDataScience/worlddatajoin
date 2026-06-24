# Join many messy country tables on the ISO spine

The many-table generalisation of
[`country_join()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_join.md):
reduce-join a list of data frames that each key on country names or
codes, reconciling every one to `iso3c` first.

## Usage

``` r
country_join_all(
  tables,
  by,
  origin = "country.name",
  type = c("full", "left", "inner")
)
```

## Arguments

- tables:

  A list of data frames.

- by:

  A single country-column name present in every table, or a character
  vector giving the column for each table.

- origin:

  countrycode origin scheme(s) for the key column(s) (default
  `"country.name"`; length 1 or one per table).

- type:

  Join type: `"full"` (default), `"left"` or `"inner"`.

## Value

A single tibble joined on `iso3c` (clashing non-key columns get dplyr's
default `.x`/`.y` suffixes).

## Examples

``` r
a <- data.frame(country = c("Czechia", "South Korea"), gdp = c(1, 2))
b <- data.frame(country = c("Czech Republic", "Korea, Rep."), pop = c(10, 51))
d <- data.frame(country = c("Czechia", "Korea"), area = c(79, 100))
country_join_all(list(a, b, d), by = "country")
#> # A tibble: 2 × 7
#>   country.x     gdp iso3c country.y        pop country  area
#>   <chr>       <dbl> <chr> <chr>          <dbl> <chr>   <dbl>
#> 1 Czechia         1 CZE   Czech Republic    10 Czechia    79
#> 2 South Korea     2 KOR   Korea, Rep.       51 Korea     100
```
