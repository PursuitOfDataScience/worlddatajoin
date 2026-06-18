# Web-ready interactive choropleth

An interactive choropleth with hover and zoom, for dashboards and R
Markdown / Quarto. Engines are all optional `Suggests`.

## Usage

``` r
interactive_map(
  data,
  fill,
  tooltip = NULL,
  engine = c("plotly", "ggiraph", "leaflet"),
  ...
)
```

## Arguments

- data:

  A map-ready frame.

- fill:

  The fill column (unquoted).

- tooltip:

  Optional tooltip column (unquoted).

- engine:

  `"plotly"` (default), `"ggiraph"` or `"leaflet"`.

- ...:

  Passed to
  [`world_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_map.md)
  for the plotly/ggiraph engines.

## Value

An interactive widget.

## Examples

``` r
if (FALSE) { # \dontrun{
world_data(2020) |> interactive_map(gdp_per_capita)
} # }
```
