# Emit a ggsql spatial query for a country map

Build a [ggsql](https://ggsql.org) query string that draws a choropleth
from a registered countryatlas source – the same idea as
[`world_map()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_map.md),
but the map is rendered **in the database** (DuckDB) and returned as a
web-ready Vega-Lite widget, so the geometry never has to come back into
R. Pure string builder with no dependencies; pair it with
[`as_ggsql_source()`](https://pursuitofdatascience.github.io/countryatlas/reference/as_ggsql_source.md) +
[`ggsql::ggsql_execute()`](https://r.ggsql.org/reference/ggsql_execute.html),
or drop the string into a `{ggsql}` chunk.

## Usage

``` r
world_query(
  fill,
  source = "countryatlas_world",
  projection = "equal_earth",
  palette = "viridis",
  transform = NULL,
  title = NULL,
  draw = "spatial"
)
```

## Arguments

- fill:

  The fill column (unquoted or a string).

- source:

  The table/source name registered with ggsql (default
  `"countryatlas_world"`).

- projection:

  A projection ggsql's `PROJECT TO` understands (e.g. `"equal_earth"`,
  `"orthographic"`), or `NULL` to omit the clause.

- palette:

  A scale ggsql's `SCALE ... TO` understands (default `"viridis"`), or
  `NULL` to omit.

- transform:

  Optional scale transform for `SCALE ... VIA` (e.g. `"log10"`).

- title:

  Optional plot title (`LABEL title => ...`).

- draw:

  The spatial layer (default `"spatial"`).

## Value

A `ggsql_query` string (prints as the formatted query).

## Examples

``` r
world_query(gdp_per_capita, projection = "equal_earth",
            palette = "magma", transform = "log10",
            title = "GDP per capita")
#> VISUALISE gdp_per_capita AS fill
#> FROM countryatlas_world
#> DRAW spatial
#> PROJECT TO equal_earth
#> SCALE fill TO magma VIA log10
#> LABEL title => 'GDP per capita'
```
