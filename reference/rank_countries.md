# Add rank, percentile and z-score

Adds `rank`, `percentile` and `z_score` for a value column, optionally
within a group (region, year, ...), for "top 10" tables and labelling.

## Usage

``` r
rank_countries(data, value, within = NULL, desc = TRUE)
```

## Arguments

- data:

  A data frame.

- value:

  The value column to rank (unquoted).

- within:

  Optional grouping column(s) (unquoted or character) to rank within.

- desc:

  Rank descending (largest = rank 1); default `TRUE`.

## Value

`data` with `rank`, `percentile` and `z_score` columns added.

## Examples

``` r
df <- data.frame(iso3c = c("USA", "CHN", "IND"), gdp = c(21, 17, 3))
rank_countries(df, gdp)
#>   iso3c gdp rank percentile    z_score
#> 1   USA  21    1        1.0  0.7758802
#> 2   CHN  17    2        0.5  0.3526728
#> 3   IND   3    3        0.0 -1.1285530
```
