# Country adjacency (shared land borders)

Which countries share a land border with which, as a tidy edge list –
built from polygon topology
([`sf::st_touches()`](https://r-spatial.github.io/sf/reference/geos_binary_pred.html)),
so it reflects the same curated geometry as the rest of the package.
Powers
[`neighbors()`](https://pursuitofdatascience.github.io/countryatlas/reference/neighbors.md).
Convert to a graph with e.g.
`igraph::graph_from_data_frame(country_borders(), directed = FALSE)` if
you need one.

## Usage

``` r
country_borders(scale = "small", region = NULL)
```

## Arguments

- scale:

  Natural Earth resolution to compute adjacency from. Coarser scales
  simplify small slivers and may miss a handful of short borders.

- region:

  Optional region subset (see
  [`world_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_geometry.md));
  a pair is only reported when both countries remain in the subset.

## Value

A tibble, one row per bordering pair: `iso3c_a`, `country_a`, `iso3c_b`,
`country_b`. Each unordered pair appears once, with `iso3c_a <= iso3c_b`
alphabetically.

## Examples

``` r
if (FALSE) { # \dontrun{
country_borders()
country_borders(region = "Europe")
} # }
```
