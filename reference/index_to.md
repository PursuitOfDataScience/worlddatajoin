# Rebase a series to an index (base year = 100)

Rescales a value column so the chosen base year equals `to` (100 by
default), per country – the standard way to compare trajectories that
start at very different levels.

## Usage

``` r
index_to(data, value, base_year, to = 100, suffix = "_index")
```

## Arguments

- data:

  A panel with `iso3c` and `year`.

- value:

  The value column (unquoted).

- base_year:

  The year set equal to `to`.

- to:

  The index value the base year maps to (default `100`).

- suffix:

  Suffix for the new column (default `"_index"`).

## Value

`data` with an index column added.

## Examples

``` r
df <- data.frame(iso3c = "USA", year = 2000:2002, gdp = c(50, 55, 60))
index_to(df, gdp, base_year = 2000)
#> # A tibble: 3 × 4
#>   iso3c  year   gdp gdp_index
#>   <chr> <int> <dbl>     <dbl>
#> 1 USA    2000    50       100
#> 2 USA    2001    55       110
#> 3 USA    2002    60       120
```
