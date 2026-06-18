# Geometry without the data

Sometimes you just want the canvas: country polygons, label-ready
centroids, coastlines, internal borders, a graticule or an ocean
rectangle – already projected, region-subset and antimeridian-safe. This
is the building block the plotting functions sit on, exposed for power
users.

## Usage

``` r
world_geometry(
  what = c("countries", "centroids", "coastline", "borders", "graticule", "ocean"),
  geometry = c("polygon", "sf"),
  scale = "small",
  region = NULL,
  projection = "equal_earth",
  recenter = NULL
)
```

## Arguments

- what:

  What to return: `"countries"` (default), `"centroids"`, `"coastline"`,
  `"borders"`, `"graticule"` or `"ocean"`.

- geometry:

  `"polygon"` (a tibble of `long`/`lat`/`group`) or `"sf"`.

- scale:

  Natural Earth resolution for the `sf` backend: `"small"` (110m),
  `"medium"` (50m) or `"large"` (10m).

- region:

  Optional subset: a continent, a group name, a vector of `iso3c` codes,
  or a bounding box `c(xmin, ymin, xmax, ymax)`.

- projection:

  Projection for the `sf` backend (see
  [`world_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_map.md)).

- recenter:

  Optional central meridian for a recentred map (e.g. `150`).

## Value

A tibble (polygon backend) or `sf` object (sf backend).

## Examples

``` r
# \donttest{
if (requireNamespace("maps", quietly = TRUE)) {
  head(world_geometry("countries", geometry = "polygon"))
}
#> # A tibble: 6 × 8
#>    long   lat group order region subregion iso3c iso2c
#>   <dbl> <dbl> <dbl> <int> <chr>  <chr>     <chr> <chr>
#> 1 -69.9  12.5     1     1 Aruba  NA        ABW   AW   
#> 2 -69.9  12.4     1     2 Aruba  NA        ABW   AW   
#> 3 -69.9  12.4     1     3 Aruba  NA        ABW   AW   
#> 4 -70.0  12.5     1     4 Aruba  NA        ABW   AW   
#> 5 -70.1  12.5     1     5 Aruba  NA        ABW   AW   
#> 6 -70.1  12.6     1     6 Aruba  NA        ABW   AW   
# }
```
