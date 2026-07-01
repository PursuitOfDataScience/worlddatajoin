# Great-circle distance between two countries

Haversine distance (km) between two countries' centroids – the
lightweight companion to
[`country_borders()`](https://pursuitofdatascience.github.io/countryatlas/reference/country_borders.md)
for "how far apart" rather than "do they touch". Works from the bundled
[country_meta](https://pursuitofdatascience.github.io/countryatlas/reference/country_meta.md)
centroids, so unlike most of the spatial toolkit it needs neither `sf`
nor the network.

## Usage

``` r
distance_between(a, b, origin = "country.name")
```

## Arguments

- a, b:

  Vectors of country names or codes (recycled against each other).

- origin:

  How to read `a`/`b` (default `"country.name"`).

## Value

A numeric vector of great-circle distances in kilometres (`NA` for any
country that doesn't resolve to a known centroid).

## Examples

``` r
distance_between("France", "Germany")
#> [1] 802.3524
distance_between("USA", c("Canada", "Mexico"))
#> [1] 2184.930 1622.586
```
