# Simplify (thin) geometry for faster plotting

Reduce the vertex count of an `sf` object via the optional `rmapshaper`
package (falling back to
[`sf::st_simplify()`](https://r-spatial.github.io/sf/reference/geos_unary.html)),
for fast web/plotting.

## Usage

``` r
simplify_geometry(x, keep = 0.05, ...)
```

## Arguments

- x:

  An `sf` object.

- keep:

  Proportion of vertices to keep (0-1) for `rmapshaper`.

- ...:

  Passed to the underlying simplifier.

## Value

A simplified `sf` object.

## Examples

``` r
if (FALSE) { # \dontrun{
world_geometry(geometry = "sf") |> simplify_geometry(keep = 0.1)
} # }
```
