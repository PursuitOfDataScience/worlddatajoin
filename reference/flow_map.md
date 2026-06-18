# Great-circle origin-destination flow map

Draws great-circle arcs between country pairs from an origin-destination
table (trade, migration, flights, remittances), resolving both endpoints
to centroids automatically.

## Usage

``` r
flow_map(data, from, to, weight = NULL, origin = "country.name", n = 50)
```

## Arguments

- data:

  An OD table.

- from, to:

  The origin and destination country columns (unquoted; names or
  `iso3c`).

- weight:

  Optional column controlling arc width/alpha (unquoted).

- origin:

  How to read `from`/`to` (countrycode origin scheme).

- n:

  Points per arc (smoothness).

## Value

A `ggplot` object.

## Examples

``` r
# \donttest{
od <- data.frame(from = c("China", "Germany"),
                 to = c("United States", "France"),
                 value = c(500, 200))
if (requireNamespace("maps", quietly = TRUE)) {
  flow_map(od, from, to, value)
}

# }
```
