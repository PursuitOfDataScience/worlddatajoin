# A country's neighbours

Which countries border a given country (or countries) – a vectorised
lookup built on
[`country_borders()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_borders.md).

## Usage

``` r
neighbors(x, origin = "country.name", scale = "small")
```

## Arguments

- x:

  A vector of country names or codes.

- origin:

  How to read `x` (default `"country.name"`).

- scale:

  Natural Earth resolution to compute adjacency from.

## Value

A tibble with one row per (`iso3c`, `neighbor`) pair: the queried
country's `iso3c`, and each bordering country's `iso3c` and `country`
name (`neighbor`, `neighbor_country`). Countries with no land border
(islands, e.g. Japan, Madagascar) return zero rows.

## Examples

``` r
if (FALSE) { # \dontrun{
neighbors("France")
neighbors(c("FRA", "JPN"), origin = "iso3c")
} # }
```
