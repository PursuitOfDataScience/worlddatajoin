# Spin the globe

An animated GIF of the world rotating on its axis: a sequence of
orthographic
[`globe_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/globe_map.md)
frames at evenly spaced central longitudes, assembled into a looping
animation with the optional `gifski` (preferred) or `magick` package.
Embeds directly in R Markdown / Quarto / a README.

## Usage

``` r
spin_globe(
  data,
  fill,
  lat = 20,
  n_frames = 60,
  fps = 15,
  backend = c("polygon", "sf"),
  width = 480,
  height = 480,
  file = NULL,
  ...
)
```

## Arguments

- data:

  A map-ready frame (see
  [`globe_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/globe_map.md)):
  a country-level frame with `iso3c` for the `"polygon"` backend, or an
  `sf` frame for `"sf"`.

- fill:

  The fill column (unquoted).

- lat:

  The latitude the globe is tilted toward (the viewer's eye line).

- n_frames:

  Number of frames in one full 360 degrees rotation.

- fps:

  Frames per second of the output animation.

- backend:

  `"polygon"` (default; needs `maps` + `mapproj`, no `sf`) or `"sf"`.

- width, height:

  Pixel dimensions of the animation.

- file:

  Optional output path (`.gif`); a temporary file is used if `NULL`.

- ...:

  Passed to
  [`globe_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/globe_map.md)
  (e.g. `fill` `style`, `palette`).

## Value

The path to the written GIF, invisibly.

## Examples

``` r
if (FALSE) { # \dontrun{
# No sf required:
spin_globe(world_snapshot$countries, continent, backend = "polygon",
           style = "categorical")
} # }
```
