# Normalise an indicator by population

Removes the "is this map just a population map?" footgun by dividing a
value column by population. If no population column is supplied,
`SP.POP.TOTL` is pulled automatically for the relevant countries and
years.

## Usage

``` r
per_capita(data, value, pop = NULL, suffix = "_per_capita", cache = TRUE)
```

## Arguments

- data:

  A country-level (or panel) data frame with `iso3c`.

- value:

  The value column to normalise (unquoted).

- pop:

  Optional population column (unquoted). If absent, population is
  fetched from WDI.

- suffix:

  Suffix for the new column (default `"_per_capita"`).

- cache:

  Whether to use the WDI cache when fetching population.

## Value

`data` with a new per-capita column.

## Examples

``` r
df <- data.frame(iso3c = c("USA", "CHN"), year = 2020L,
                 co2 = c(5e6, 1e7), pop = c(331e6, 1402e6))
per_capita(df, co2, pop)
#> # A tibble: 2 × 5
#>   iso3c  year      co2        pop co2_per_capita
#>   <chr> <int>    <dbl>      <dbl>          <dbl>
#> 1 USA    2020  5000000  331000000        0.0151 
#> 2 CHN    2020 10000000 1402000000        0.00713
```
