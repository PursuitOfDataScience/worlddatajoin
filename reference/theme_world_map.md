# A clean theme for world maps

Strips axes, panel grid and background so the map is the focus. Used by
all the package's plotting functions and exported for reuse.

## Usage

``` r
theme_world_map(base_size = 12, base_family = "")
```

## Arguments

- base_size:

  Base font size.

- base_family:

  Base font family.

## Value

A `ggplot2` theme object.

## Examples

``` r
library(ggplot2)
ggplot() + theme_world_map()
```
