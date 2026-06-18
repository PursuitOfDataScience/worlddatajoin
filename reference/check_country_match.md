# Pre-flight country-match report

A report on what will and will not match before you trust the map: the
input, its `iso3c`, whether it `matched`, and a `suggestion` (the
closest known country name by string distance) for misses. Surfaced
automatically by
[`join_world()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/join_world.md).

## Usage

``` r
check_country_match(
  x,
  origin = "country.name",
  custom_match = wdj_overrides(),
  suggest = TRUE
)
```

## Arguments

- x:

  A vector of country names or codes.

- origin:

  How to read `x` (any countrycode origin scheme).

- custom_match:

  Overrides applied before matching (default
  [`wdj_overrides()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/wdj_overrides.md)).

- suggest:

  Whether to compute closest-name suggestions for misses (requires the
  optional `stringdist` package; default `TRUE`).

## Value

A tibble with columns `input`, `iso3c`, `matched`, `suggestion`.

## Examples

``` r
check_country_match(c("USA", "Cote d'Ivoire", "Yugoslavia", "Wakanda"))
#> # A tibble: 4 × 4
#>   input         iso3c matched suggestion
#>   <chr>         <chr> <lgl>   <chr>     
#> 1 USA           USA   TRUE    NA        
#> 2 Cote d'Ivoire CIV   TRUE    NA        
#> 3 Yugoslavia    NA    FALSE   Yugoslavia
#> 4 Wakanda       NA    FALSE   Canada    
```
