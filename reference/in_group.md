# Is a country in a group?

A vectorised membership predicate built on
[`country_groups()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_groups.md).

## Usage

``` r
in_group(x, group, origin = "country.name")
```

## Arguments

- x:

  A vector of country names or codes.

- group:

  A single group name (see
  [`country_groups()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_groups.md)).

- origin:

  How to read `x` (default `"country.name"`).

## Value

A logical vector the same length as `x`.

## Examples

``` r
in_group(c("France", "United States", "Japan"), "EU")
#> [1]  TRUE FALSE FALSE
```
