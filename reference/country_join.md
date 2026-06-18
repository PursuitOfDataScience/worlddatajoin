# Reconcile and join two messy country tables

The generic two-table version of the package's whole reason for being:
join *any* two data frames that each key on country names or codes, by
reconciling both sides to `iso3c` first. Tables keyed on
`"Czech Republic"` vs `"Czechia"`, or `"South Korea"` vs
`"Korea, Rep."`, just work.

## Usage

``` r
country_join(
  x,
  y,
  by_x,
  by_y,
  origin_x = "country.name",
  origin_y = "country.name",
  type = c("left", "inner", "full"),
  suffix = c(".x", ".y")
)
```

## Arguments

- x, y:

  Data frames to join.

- by_x, by_y:

  The country columns in `x` and `y` (unquoted).

- origin_x, origin_y:

  How to read each key (countrycode origin schemes).

- type:

  Join type: `"left"` (default), `"inner"` or `"full"`.

- suffix:

  Suffix for clashing non-key columns (default `c(".x", ".y")`).

## Value

A tibble joined on a reconciled `iso3c` key.

## Examples

``` r
a <- data.frame(country = c("Czechia", "South Korea"), gdp = c(1, 2))
b <- data.frame(nation = c("Czech Republic", "Korea, Rep."), pop = c(10, 51))
country_join(a, b, country, nation)
#> # A tibble: 2 × 5
#>   country       gdp iso3c nation           pop
#>   <chr>       <dbl> <chr> <chr>          <dbl>
#> 1 Czechia         1 CZE   Czech Republic    10
#> 2 South Korea     2 KOR   Korea, Rep.       51
```
