# worlddatajoin — Next Release Plan

> **Status:** design document for the next release **Current version:**
> 0.1.0 (experimental) **Next version:** 1.0.0 — a single, comprehensive
> release that takes the package from a one-function proof of concept to
> a complete toolkit for joining world data to maps.

------------------------------------------------------------------------

## 1. The spirit we are expanding

`worlddatajoin` exists to kill one specific, recurring source of pain:
**country names never line up across data sources.** `"US"`, `"U.S."`,
`"United States"`, `"United States of America"`, and `"America"` are the
same country, but a naïve `left_join()` treats them as five. The
package’s answer is to make **ISO codes the universal join key** and to
hand the user a single, ready-to-map tibble that already stitches
together three otherwise-disjoint worlds:

- **`ggplot2::map_data("world")`** — the geometry (where countries are),
- **`WDI`** — World Bank indicators (what is true about them),
- **`countrycode`** — the Rosetta Stone (ISO codes, continents, regions)
  that makes the join possible at all.

Today this is one function, `world_data(year)`. Everything below stays
faithful to that mission — **reduce join friction, enrich the map, keep
the happy path one call** — and pushes it as far as it can reasonably
go: any data source on the ISO spine, any kind of map, with the rough
edges (missing matches, bad projections, distorted areas, slow API
calls) handled *for* the user instead of *by* the user.

The design rule for every addition: *if it doesn’t make it easier to get
country data onto a map (or make that map honest), it doesn’t belong
here.*

------------------------------------------------------------------------

## 2. Where the package stands today (honest assessment)

[`world_data()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_data.md)
does something genuinely useful, but it has hard limits and a few real
bugs. The release fixes these rather than building on top of them.

### 2.1 Functional limitations

| Limitation | Impact |
|----|----|
| **One hardcoded indicator** (`NY.GDP.PCAP.KD`) | Can’t pull population, life expectancy, CO₂, etc. without leaving the package and hand-joining — the exact pain it set out to remove. |
| **One year at a time** | No panel / time series, so no animation or faceting over time, though the data and [`countrycode::codelist_panel`](https://vincentarelbundock.github.io/countrycode/man/codelist_panel.html) make it natural. |
| **One geometry backend** (`map_data("world")`) | Legacy `maps` polygons: low resolution, dated borders, no native ISO codes, antimeridian split (Russia/Fiji/NZ wrap around the frame). No projection — raw `long`/`lat` is an unprojected plate carrée that badly distorts area. |
| **~99k polygon rows even for analysis** | WDI values duplicated across every polygon vertex; no lightweight one-row-per-country table to join, model, or rank on. |
| **Silently drops 16 regions** | Kosovo, Micronesia, the Virgin Islands, Saint Martin, Bonaire/Saba/Sint Eustatius, the Canary Islands, etc. are filtered out rather than matched — they vanish from maps with no warning, though most match with a one-line override. |
| **No join helper for the user’s own data** | The headline use case — “I have a frame keyed on messy names, get it on a map” — must still be done by hand. The standardization machinery exists internally but is never exposed. |
| **No diagnostics** | A failed match becomes a silent `NA` and an empty patch on the map, with no report of what failed or why. |
| **Repeated plotting boilerplate** | The README writes `ggplot(aes(long, lat, group, fill)) + geom_polygon() + theme_minimal()` three times. A choropleth helper is begging to exist. |

### 2.2 Bugs / smells to fix in passing

- **`gdp_per_capita_2015` is a misnomer.** It’s named for the
  indicator’s base year (constant 2015 US\$), but holds the *requested*
  year’s value — `world_data(1990)` returns a column called
  `gdp_per_capita_2015` containing 1990 figures.
- **`extra = TRUE`** triggers a large WDI download (region, capital,
  lat/long, lending) that is then mostly `select()`ed away.
- **No input validation** on `year`.
- **Blanket `@import` of five packages** pollutes the namespace;
  `@importFrom` is correct.
- **`LazyData: true` with no `data/`** → `R CMD check` NOTE.
- **`\dontrun{}` examples** never run, so they aren’t tested and can
  rot.
- **No tests, vignette, or pkgdown site.**
- **Stale CI** (`r-lib/actions/*@v1`, `actions/checkout@v2`) and old
  `RoxygenNote 7.1.2`.

------------------------------------------------------------------------

## 3. Design principles

1.  **The happy path stays one call.** `world_data(2020)` keeps working
    and keeps returning a map-ready tibble. New power is opt-in.
2.  **ISO code is the spine.** Every function speaks `iso3c`/`iso2c`
    internally and exposes it, so anything the package produces joins to
    anything else it produces — *and* to the user’s data.
3.  **Lose no country silently.** Dropping is replaced by
    matching-with-overrides plus an explicit, inspectable report of
    whatever truly can’t be matched.
4.  **Honest maps by default.** Sensible projection, equal-area options,
    binned scales, and area-bias remedies (cartograms) so the default
    map doesn’t mislead.
5.  **Lean core, rich optional.** Heavy deps (`sf`, `rnaturalearth*`,
    `cartogram`, `leaflet`, …) live in `Suggests`, gated by
    [`rlang::check_installed()`](https://rlang.r-lib.org/reference/is_installed.html).
    Base install stays as light as today.
6.  **Tidy in, tidy out.** Tibbles, pipeable verbs, predictable
    `snake_case` columns.
7.  **Offline-capable.** A bundled snapshot lets every example, test,
    and vignette run without the World Bank API.

------------------------------------------------------------------------

## 4. The release at a glance

A single 1.0.0 release organized into eight capability areas. Together
they turn “enrich one map with one indicator for one year” into “**get
any country data, from anywhere, onto any kind of honest map — in one or
two calls.**”

| Area | What it adds |
|----|----|
| **A. Core data assembly** | Generalized [`world_data()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_data.md); lightweight [`country_data()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_data.md); standalone [`world_geometry()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_geometry.md). |
| **B. The join engine** | [`standardize_country()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/standardize_country.md), [`join_world()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/join_world.md), [`attach_geometry()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/attach_geometry.md), [`country_join()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_join.md) — the package’s mission, exposed for *your* data. |
| **C. Diagnostics & quality** | [`check_country_match()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/check_country_match.md), [`wdj_overrides()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/wdj_overrides.md), [`audit_coverage()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/audit_coverage.md). |
| **D. Built-in reference data** | [`convert_country()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/convert_country.md), [`country_codes()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_codes.md), `country_meta`, [`country_groups()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_groups.md), `common_indicators`, [`wdi_search()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/wdi_search.md). |
| **E. Analysis helpers** | [`per_capita()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/per_capita.md), [`aggregate_regions()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/aggregate_regions.md), [`rank_countries()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/rank_countries.md), [`complete_years()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/complete_years.md). |
| **F. Visualization** | [`world_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_map.md) (continuous/binned/quantile/categorical), [`bubble_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/bubble_map.md), [`bivariate_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/bivariate_map.md), [`cartogram_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/cartogram_map.md), [`tile_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/tile_map.md), [`flow_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/flow_map.md), [`animate_world()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/animate_world.md), [`interactive_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/interactive_map.md), [`geom_country_labels()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/geom_country_labels.md), [`theme_world_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/theme_world_map.md). |
| **G. Geometry utilities** | Projections, region/bbox subsetting, recentering & antimeridian fix, centroids, simplification. |
| **H. Performance & offline** | Memoised + on-disk WDI cache; bundled `world_snapshot`. |

------------------------------------------------------------------------

## 5. Feature catalog

Each item: motivation, signature(s), a short example, and the dependency
capability it leans on.

### Area A — Core data assembly

#### `world_data()` — generalized, backward-compatible

``` r

world_data(
  year,
  indicator = c(gdp_per_capita = "NY.GDP.PCAP.KD"),  # named => clean column names
  geometry  = c("polygon", "sf", "none"),
  scale     = c("small", "medium", "large"),         # sf backend resolution
  region    = NULL,                                  # subset: "Africa", "EU", bbox, iso vector
  classify  = c("income", "continent", "region"),
  overrides = wdj_overrides(),
  latest    = FALSE,
  cache     = TRUE,
  language  = "en"
)
```

- **`indicator`** takes one or many WDI codes. A **named** vector drives
  column naming (WDI’s own auto-rename), retiring the
  `gdp_per_capita_2015` misnomer:
  `c(gdp = "NY.GDP.PCAP.KD", pop = "SP.POP.TOTL")` → columns `gdp`,
  `pop`.
- **`year`** may be scalar (`2020`) or a range (`2000:2020`) → a panel
  keyed on `iso3c` + `year`, reconciled against `codelist_panel` so
  codes survive border changes.
- **`geometry`**: `"polygon"` reproduces today’s output (default ⇒
  backward compatible); `"sf"` returns an `sf` object via
  [`rnaturalearth::ne_countries()`](https://docs.ropensci.org/rnaturalearth/reference/ne_countries.html)
  for `geom_sf()` + real projections; `"none"` skips geometry.
- **`region`** subsets to a continent/group/bounding box/ISO vector and
  picks a sensible default projection for it.
- **`latest`** uses WDI’s `latest` to grab the most recent non-`NA`
  value per country.

``` r

world_data(2020)                                   # unchanged old behavior
world_data(2020,
           indicator = c(life_exp = "SP.DYN.LE00.IN", co2 = "EN.ATM.CO2E.PC"),
           geometry  = "sf", region = "Africa")
```

#### `country_data()` — the lightweight, one-row-per-country table

``` r

country_data(year, indicator = NULL, latest = FALSE, panel = FALSE, cache = TRUE)
```

The analysis counterpart: **no polygons**, one tidy row per country
(`iso3c`, `iso2c`, `country`, `continent`, `region`, `income`, requested
indicators). What you actually want to
`join`/`mutate`/`summarise`/`rank` on. Geometry is attached only at draw
time
([`attach_geometry()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/attach_geometry.md)).

#### `world_geometry()` — geometry without the data

``` r

world_geometry(
  what       = c("countries", "centroids", "coastline", "borders", "graticule", "ocean"),
  geometry   = c("polygon", "sf"),
  scale      = "small",
  region     = NULL,
  projection = "equal_earth",
  recenter   = NULL          # central meridian, e.g. 150 for a Pacific-centered map
)
```

Sometimes you just want the canvas: country polygons, label-ready
**centroids**, coastlines, internal borders, a graticule, or an ocean
rectangle — already projected, region-subset, and antimeridian-safe. The
building block the plotting functions sit on, exposed for power users.

> *Leans on:* WDI multi/named indicators, `latest`, `codelist_panel`;
> [`rnaturalearth::ne_countries()`](https://docs.ropensci.org/rnaturalearth/reference/ne_countries.html)
> (scales 110m/50m/10m) + `sf`.

------------------------------------------------------------------------

### Area B — The join engine (the heart of the package)

The mission, finally exposed for the **user’s** data — not just the
package’s internals.

#### `standardize_country()` — add ISO codes & classifications to any data

``` r

standardize_country(
  data, country_col,
  origin       = "country.name",   # how to read country_col
  add          = c("iso3c", "iso2c", "continent", "region"),
  custom_match = NULL, warn = TRUE
)
```

``` r

my_df %>% standardize_country(nation)   # nation = "U.S.", "S. Korea", ... → joinable
```

#### `join_world()` — one call: “my data → on a map”

``` r

join_world(data, country_col = NULL, origin = "country.name",
           geometry = c("polygon", "sf", "none"), scale = "small", warn = TRUE)
```

Auto-detects the country column, standardizes it, attaches geometry,
returns a plot-ready frame. The function that fulfills the README’s
promise for the reader’s own data.

``` r

unicef_rates %>% join_world(country) %>% world_map(fill = vaccination_pct)
```

#### `attach_geometry()` — bolt geometry onto a country-level table

``` r

attach_geometry(data, by = "iso3c", geometry = c("polygon", "sf"), scale = "small")
```

The bridge between
[`country_data()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_data.md)
(light) and plotting.

#### `country_join()` — reconcile and join two messy country tables

``` r

country_join(x, y, by_x, by_y, type = c("left", "inner", "full"))
```

The generic two-table version of the package’s whole reason for being:
join *any* two data frames that each key on country names/codes, by
reconciling both sides to ISO first. (Two datasets with
`"Czech Republic"` vs `"Czechia"`, `"South Korea"` vs `"Korea, Rep."`
just work.)

> *Leans on:* `countrycode()` / `countryname()` matching, `custom_match`
> overrides; `rnaturalearth` / `map_data` geometry.

------------------------------------------------------------------------

### Area C — Diagnostics & data quality (never lose a country silently)

#### `check_country_match()`

``` r

check_country_match(x, origin = "country.name", suggest = TRUE)
```

A pre-flight report: `input`, `iso3c`, `matched` (lgl), and a
`suggestion` (closest known name by string distance) for misses.
Surfaced automatically by `join_world(warn = TRUE)`.

``` r

check_country_match(c("USA", "Cote d'Ivoire", "Yugoslavia", "Wakanda"))
#> input          iso3c matched suggestion
#> USA            USA   TRUE    NA
#> Cote d'Ivoire  CIV   TRUE    NA
#> Yugoslavia     NA    FALSE   "Serbia / use codelist_panel"
#> Wakanda        NA    FALSE   NA
```

#### `wdj_overrides()` — the curated override table (replaces the drop-list)

A shipped, documented `custom_match` for entities `map_data("world")`
and Natural Earth get wrong or leave codeless: **Kosovo → `XKX`**,
Micronesia → `FSM`, Virgin Islands, Saint Martin → `MAF`,
Bonaire/Saba/Sint Eustatius → `BES`, Canary Islands → `ESP`,
Madeira/Azores → `PRT`, Barbuda → `ATG`, Grenadines → `VCT`, Ascension →
`SHN`, … Instead of *deleting* the 16 regions the current code drops, we
**match** them. Extensible: `wdj_overrides(c(Somaliland = "SOM"))`.

> Also papers over a known Natural Earth gotcha: `ne_countries()`’s
> `iso_a3` is `-99`/`NA` for France, Norway, Kosovo, etc. The package
> falls back to `countrycode` on `admin`/`sovereignt` (or `iso_a3_eh`)
> so these never silently disappear.

#### `audit_coverage()` — what’s missing, before you trust the map

``` r

audit_coverage(data, indicator = NULL, by = c("region", "income", "continent"))
```

Reports unmatched countries, `NA` rates per indicator, and which World
Bank regions/income groups are under-covered — so a half-empty map is
caught before it’s published, not after.

> *Leans on:* `countrycode` matching internals +
> `codelist`/`codelist_panel`; base string distance.

------------------------------------------------------------------------

### Area D — Built-in reference data & code translation

So users never leave the package to find a code, a grouping, or a
metadata field.

#### `convert_country()` — friendly `countrycode` wrapper

``` r

convert_country(x, to = "iso3c", from = "country.name")
```

The full ~40 `countrycode` schemes with discoverable shortcuts,
including the high-value ones surfaced as first-class:

- `to = "flag"` → flag emoji (`unicode.symbol`) for labels/tables,
- `to = "continent" | "region" | "region23"`,
- `to = "currency"` / `iso4217c`, `to = "tld"` (`cctld`),
  `to = "calling_code"`,
- research schemes: `cown`/`cowc` (Correlates of War), `p4n`/`p5n`
  (Polity), `gwn` (Gleditsch-Ward), `vdem`, `imf`, `fao`, `fips`,
  `gaul`.

``` r

convert_country(c("Japan", "Brazil"), to = "flag")     #> "🇯🇵" "🇧🇷"
convert_country("Germany",           to = "currency")  #> "EUR"
```

#### `country_codes()` — the codelist as a tidy tibble

``` r

country_codes(codes = NULL)   # all schemes, or a chosen subset, one row per country
```

The whole
[`countrycode::codelist`](https://vincentarelbundock.github.io/countrycode/man/codelist.html)
reshaped tidy and pipeable — a lookup you can
[`filter()`](https://rdrr.io/r/stats/filter.html)/`join()` directly.

#### `country_meta` *(bundled dataset)* — static attributes in one place

One row per country with the facts people constantly need and currently
scrape together by hand: `iso3c`, `iso2c`, `country`, `continent`,
`region`, `un_region`, `capital`, `capital_lat`, `capital_lon`,
`centroid_lat`, `centroid_lon`, `area_km2`, `currency`, `tld`,
`calling_code`, `official_languages`, `landlocked`, `is_island`, `flag`
(emoji). Assembled from
[`countrycode::codelist`](https://vincentarelbundock.github.io/countrycode/man/codelist.html) +
WDI `extra` + Natural Earth geometry.

#### `country_groups()` — membership predicates / table

``` r

country_groups(group = c("EU", "OECD", "G7", "G20", "BRICS", "ASEAN",
                         "EFTA", "Commonwealth", "OPEC", "EuroZone", "NATO"))
in_group(x, "EU")   # logical
```

Answers the constant question “is this country in the EU / OECD / G20?”
— a curated, dated, documented membership table (point-in-time
membership is genuinely fiddly, so it’s shipped and maintained, not
guessed).

#### `common_indicators` *(bundled)* + `wdi_search()`

``` r

common_indicators            # curated tibble: friendly name <-> WDI code
wdi_search(pattern, cache = TRUE)   # tidy wrapper on WDIsearch()
```

So `indicator = common_indicators$population` beats memorizing
`SP.POP.TOTL`, and discovering a new code is one pipeable call. Curated
set covers population, GDP (constant & current, total & per-capita),
life expectancy, CO₂, internet/urban share, fertility, poverty, Gini,
unemployment, schooling, etc.

> *Leans on:* `countrycode` (`codelist`, `unicode.symbol`, currency,
> cctld); `WDI` (`WDIsearch`, `extra` capital/coords); Natural Earth
> (centroids/area).

------------------------------------------------------------------------

### Area E — Analysis helpers (make the *analysis* friction-free too)

Small, in-spirit transforms that otherwise force a detour out of the
package mid-pipeline.

| Function | What it does |
|----|----|
| `per_capita(data, value, pop = NULL)` | Normalize an indicator by population (auto-pulls `SP.POP.TOTL` if `pop` absent). Removes the “is this map just a population map?” footgun. |
| `aggregate_regions(data, value, by = "region", fun = "sum", weight = NULL)` | Roll countries up to region/continent/income/income×region/custom group, with population-weighted means when `weight` is given. |
| `rank_countries(data, value, within = NULL)` | Add `rank`, `percentile`, and `z_score`, optionally within region/year — for “top 10” tables and labeling. |
| `complete_years(data, years, method = c("none","locf","linear"))` | Fill gaps in a panel (carry-forward or linear interpolation) so animations don’t flicker on missing years. |

``` r

country_data(2020, c(co2 = "EN.ATM.CO2E.KT")) %>%
  per_capita(co2) %>%
  rank_countries(co2_per_capita, within = region)
```

------------------------------------------------------------------------

### Area F — Visualization (retire the boilerplate; make honest maps easy)

The README hand-draws three choropleths. Encapsulate that — and then go
well beyond a single map type, because “world data on a map” has many
honest forms.

#### `world_map()` — one-line choropleth, several styles

``` r

world_map(
  data, fill,
  style      = c("continuous", "binned", "quantile", "jenks", "categorical"),
  projection = c("equal_earth", "robinson", "mollweide", "natural_earth", "plate_carree"),
  palette    = NULL, n_bins = 5, borders = TRUE,
  title = NULL, legend = NULL, na_label = "No data"
)
```

Auto-detects polygon (`geom_polygon`) vs `sf` (`geom_sf`), applies a map
theme, and — for `sf` — a real projection via `coord_sf()`.
**Binned/quantile/jenks** styles (via `classInt`) are offered because a
continuous fill on a skewed indicator hides almost all the variation;
binning is the honest default for choropleths.

``` r

world_data(2020, c(gdp = "NY.GDP.PCAP.KD"), geometry = "sf") %>%
  world_map(gdp, style = "quantile", projection = "equal_earth",
            title = "GDP per capita, 2020")
```

#### `bubble_map()` — proportional-symbol map

``` r

bubble_map(data, size, color = NULL, projection = "equal_earth")
```

Plots sized circles at country **centroids** — the right idiom for
*totals* (population, total emissions, total GDP), which a choropleth
misrepresents because big values hide in small countries and vice-versa.

#### `bivariate_map()` — two variables at once

``` r

bivariate_map(data, fill_x, fill_y, palette = "GrPink", projection = "equal_earth")
```

A 2-D bivariate choropleth (via `biscale`) with a built-in 2-D legend —
e.g., GDP per capita × life expectancy in one map.

#### `cartogram_map()` — area-honest choropleth

``` r

cartogram_map(data, weight, type = c("contiguous", "dorling", "noncontiguous"), fill = NULL)
```

Resizes countries by `weight` (population, GDP, …) via `cartogram`,
defeating the “big empty countries dominate the eye” bias that plagues
world choropleths. Dorling (circles) and contiguous variants both
supported.

#### `tile_map()` — equal-area tile grid

``` r

tile_map(data, fill, grid = "world_countries_grid1")
```

A statebins-style equal-area **tile grid** of the world (one square per
country) so tiny states are actually visible — built on `geofacet`’s
`world_countries_grid1` (and `facet_geo()` for small multiples).

#### `flow_map()` — origin–destination connections

``` r

flow_map(data, from, to, weight = NULL, projection = "equal_earth")
```

Draws great-circle arcs between country pairs from an OD table (trade,
migration, flights, remittances) — resolving both endpoints to centroids
automatically. A distinctive, squarely in-spirit “join world data to a
map” capability that nothing in the base stack offers cheaply.

#### `animate_world()` — choropleth over time

``` r

animate_world(data, fill, time = year, projection = "equal_earth")
```

Given a panel from `world_data(2000:2020, …)`, animate the choropleth
over `year` via `gganimate` (or fall back to a faceted small-multiple
when it isn’t installed). The natural payoff of panel support and a
great README centerpiece.

#### `interactive_map()` — hover/zoom

``` r

interactive_map(data, fill, tooltip = NULL, engine = c("leaflet", "ggiraph", "plotly"))
```

A web-ready interactive choropleth with flag-emoji tooltips and zoom,
for dashboards and R Markdown / Quarto. Optional engines, all
`Suggests`.

#### `geom_country_labels()` & `theme_world_map()`

``` r

geom_country_labels(aes(label = iso3c), repel = TRUE, flag = FALSE)  # centroid labels, optional flags
theme_world_map()                                                    # the exported standalone theme
```

Centroid-anchored labels (names, ISO codes, or flag emoji) with
`ggrepel` collision avoidance — using
[`sf::st_point_on_surface()`](https://r-spatial.github.io/sf/reference/geos_unary.html)
so labels land *inside* their country — plus the map theme as a reusable
export.

> **Antimeridian:** the `sf`/projected path runs
> [`sf::st_break_antimeridian()`](https://r-spatial.github.io/sf/reference/st_break_antimeridian.html)
> before projecting, so Russia/Fiji/NZ stop streaking across the frame.
>
> *Leans on:* `ggplot2` + `sf`/`coord_sf`; `classInt` (bins), `biscale`
> (bivariate), `cartogram`, `geofacet`, `ggrepel`, `gganimate`,
> `leaflet`/`ggiraph`/`plotly` — all `Suggests`.

------------------------------------------------------------------------

### Area G — Geometry utilities

Shared plumbing under the plotting layer, exposed so power users can
compose their own maps:

- **Projections** — Equal Earth (default; equal-area and good-looking),
  Robinson, Mollweide, Natural Earth, plate carrée, via
  `coord_sf(crs = …)`.
- **Region & bbox subsetting** —
  `region = "Africa" | "EU" | c("USA","CAN","MEX") | bbox`, with a
  default projection chosen to suit the region.
- **Recentering / antimeridian** — `recenter = 150` for a
  Pacific-centered world; `st_break_antimeridian()` so nothing wraps.
- **Centroids** — label-safe via `st_point_on_surface()`; surfaced for
  [`bubble_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/bubble_map.md)/labels
  and on `country_meta`.
- **Simplification** — optional
  [`rmapshaper::ms_simplify()`](http://andyteucher.ca/rmapshaper/reference/ms_simplify.md)
  to thin high-resolution geometry for fast plotting/web.

------------------------------------------------------------------------

### Area H — Performance & offline

- **Memoised + on-disk WDI cache.** Wrap WDI fetches in `memoise` keyed
  on indicator/year/args, with an optional persistent cache under
  `tools::R_user_dir("worlddatajoin", "cache")`, so re-runs and re-knits
  hit the network once (or never). `cache = FALSE` opts out.
- **Bundled `world_snapshot`.** A small lazy-loaded dataset — a curated
  indicator set for one recent year, as both a country-level tibble and
  low-res `sf` — so examples **actually run** (drop the blanket
  `\dontrun{}`), and tests/vignettes work **offline** and
  deterministically. Also fixes the dangling `LazyData: true`.

------------------------------------------------------------------------

## 6. Bundled datasets

| Dataset | Contents | Purpose |
|----|----|----|
| `world_snapshot` | One recent year, curated indicators, country-level + low-res `sf` | Offline examples/tests/vignette; instant first run. |
| `country_meta` | Static per-country attributes (capital, centroid, area, currency, tld, calling code, languages, landlocked/island, flag) | The “everything about a country” lookup. |
| `common_indicators` | Friendly-name ↔︎ WDI-code catalog | Discoverable indicators. |
| `country_groups_tbl` | Point-in-time membership (EU/OECD/G7/G20/BRICS/…) | Membership predicates. |
| `world_tiles` | Equal-area tile-grid layout | [`tile_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/tile_map.md). |

------------------------------------------------------------------------

## 7. Engineering & infrastructure

- **Namespace hygiene** — replace blanket `@import` with targeted
  `@importFrom`.
- **Fix `gdp_per_capita_2015`** — names come from the `indicator`
  vector; a deprecation shim warns if the old name is referenced.
- **Input validation** — friendly `cli` /
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html)
  errors for bad years, unknown codes, missing country columns, absent
  `Suggests` packages.
- **Tests** — a `testthat` (3e) suite: matching incl. the override
  table, column-name correctness, panel shape, polygon↔︎sf parity,
  graceful behavior when `Suggests` are absent. Network calls mocked
  (`httptest`/`vcr`) or routed through `world_snapshot` so tests are
  offline and deterministic.
- **Vignettes** — *Getting started*; *Joining your own data*; *Modern
  maps with sf & projections*; *Beyond the choropleth* (bubble /
  bivariate / cartogram / tile / flow).
- **pkgdown site** with reference + vignettes, deployed to GitHub Pages.
- **CI refresh** — `r-lib/actions/*@v2`, `actions/checkout@v4`; add
  `test-coverage` (covr/Codecov) and a `pkgdown` deploy workflow
  alongside `R-CMD-check`.
- **`NEWS.md`** documenting every change from 0.1.0.
- **Lifecycle** — graduate the badge from *experimental* → *stable*.
- **CRAN readiness** — offline tests + check-clean namespace + bundled
  data make a CRAN submission realistic (today it can’t even be checked
  without network).
- **Housekeeping** — regenerate docs with current roxygen2; keep
  `.Rbuildignore` covering `next_release.md`, `pkgdown/`, etc.; leave no
  build/cache artifacts.

------------------------------------------------------------------------

## 8. Dependencies (tiered)

| Package | Tier | Why |
|----|----|----|
| `WDI`, `countrycode`, `dplyr`, `tibble`, `ggplot2` | **Imports** (existing) | Core engine. |
| `rlang` | **Imports** (new) | Tidy-eval for `fill`/`country_col`, `check_installed()` gates, structured errors. |
| `tidyr` | **Imports** (new) | Panel reshape, [`complete_years()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/complete_years.md). |
| `memoise` | **Imports** (new, tiny) | WDI caching. |
| `cli` | **Imports** (new, light) | Friendly messages / diagnostics. |
| `sf`, `rnaturalearth` (+ `rnaturalearthdata`) | **Suggests** (new) | `sf` backend, projections, centroids, antimeridian. |
| `classInt` | **Suggests** | Binned/quantile/jenks choropleth breaks. |
| `cartogram` | **Suggests** | [`cartogram_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/cartogram_map.md). |
| `biscale` | **Suggests** | [`bivariate_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/bivariate_map.md). |
| `geofacet` | **Suggests** | [`tile_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/tile_map.md) / `facet_geo()`. |
| `ggrepel` | **Suggests** | [`geom_country_labels()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/geom_country_labels.md). |
| `gganimate` | **Suggests** | [`animate_world()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/animate_world.md). |
| `leaflet` / `ggiraph` / `plotly` | **Suggests** | [`interactive_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/interactive_map.md) engines. |
| `rmapshaper`, `scales`, `stringdist` | **Suggests** | Geometry simplification; legend formatting; match suggestions. |

Everything heavy/modern is **Suggested and gated** — the base install
stays as light as it is today (principle \#5).

------------------------------------------------------------------------

## 9. Backward compatibility

- `world_data(year)` keeps its exact current default output (polygon
  backend, GDP-per-capita column). The only visible change is the column
  *name* (`gdp_per_capita_2015` → `gdp_per_capita`), shipped with a
  one-cycle deprecation shim.
- All new behavior is additive: new arguments with backward-compatible
  defaults, plus new exported functions.
- The 16 currently-dropped regions will start **appearing** on maps now
  that they’re matched — a deliberate, `NEWS.md`-documented improvement
  so anyone diffing map output understands why coverage grew.

------------------------------------------------------------------------

## 10. Risks & scope discipline

- **World Bank API reliability / rate limits** — mitigated by caching +
  the bundled snapshot; the package degrades gracefully offline.
- **`sf` install friction** (GDAL/GEOS/PROJ) — kept in `Suggests` with
  `check_installed()`, so non-spatial users never pay it.
- **Natural Earth ISO gaps** (`iso_a3 == -99`) — handled by the override
  table + countrycode fallback, guarded by a regression test so a
  Natural Earth update can’t silently re-break France/Norway.
- **Panel code stability** (Yugoslavia, USSR, Sudan/South Sudan,
  Czechoslovakia) — lean on `codelist_panel`; document the genuinely
  ambiguous cases rather than paper over them.
- **Group-membership drift** — EU/OECD/etc. membership changes over
  time; the shipped table is point-in-time and dated, with a documented
  maintenance policy.
- **Scope discipline** — to keep the package’s spirit intact, the
  following stay explicitly **out of scope**: subnational/admin-1
  geometry (states/provinces), non-country geographies, and becoming a
  general GIS or general charting library. The line is “country data →
  map.” `tile_map`/`bubble_map`/`flow_map`/`cartogram_map` all stay on
  the country side of that line.

------------------------------------------------------------------------

## 11. Full inventory (at a glance)

**Functions**

| Function | Area | Purpose |
|----|----|----|
| [`world_data()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_data.md) *(generalized)* | A | Map-ready enriched tibble; multi-indicator, panel, polygon/sf/none, region subset. |
| [`country_data()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_data.md) | A | Lightweight one-row-per-country attribute table. |
| [`world_geometry()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_geometry.md) | A | Projected, region-subset geometry (countries/centroids/coastline/borders/graticule/ocean). |
| [`standardize_country()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/standardize_country.md) | B | Add ISO codes + classifications to any data frame. |
| [`join_world()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/join_world.md) | B | One call: user data → standardized → on a map. |
| [`attach_geometry()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/attach_geometry.md) | B | Bolt polygon/sf geometry onto a country-level table. |
| [`country_join()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_join.md) | B | Reconcile and join two messy country tables by ISO. |
| [`check_country_match()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/check_country_match.md) | C | Pre-flight matched/unmatched report + suggestions. |
| [`wdj_overrides()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/wdj_overrides.md) | C | Curated `custom_match` table (replaces the drop-list). |
| [`audit_coverage()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/audit_coverage.md) | C | Missingness / coverage report before you trust the map. |
| [`convert_country()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/convert_country.md) | D | Friendly `countrycode` wrapper (ISO, flags, currency, tld, research codes). |
| [`country_codes()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_codes.md) | D | Tidy `codelist` lookup. |
| [`country_groups()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_groups.md) / [`in_group()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/in_group.md) | D | EU/OECD/G7/G20/BRICS/… membership. |
| [`wdi_search()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/wdi_search.md) | D | Tidy WDI indicator search. |
| [`per_capita()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/per_capita.md) | E | Population-normalize an indicator. |
| [`aggregate_regions()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/aggregate_regions.md) | E | Roll up to region/income/continent (weighted). |
| [`rank_countries()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/rank_countries.md) | E | Add rank / percentile / z-score. |
| [`complete_years()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/complete_years.md) | E | Fill/interpolate panel gaps. |
| [`world_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/world_map.md) | F | Choropleth — continuous/binned/quantile/jenks/categorical, projected. |
| [`bubble_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/bubble_map.md) | F | Proportional-symbol map at centroids. |
| [`bivariate_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/bivariate_map.md) | F | Two-variable bivariate choropleth + 2-D legend. |
| [`cartogram_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/cartogram_map.md) | F | Area-honest cartogram (contiguous/Dorling/non-contiguous). |
| [`tile_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/tile_map.md) | F | Equal-area world tile grid. |
| [`flow_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/flow_map.md) | F | Great-circle origin–destination arcs. |
| [`animate_world()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/animate_world.md) | F | Choropleth animated over a year panel. |
| [`interactive_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/interactive_map.md) | F | Leaflet/ggiraph/plotly interactive choropleth. |
| [`geom_country_labels()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/geom_country_labels.md) | F | Centroid labels (names/ISO/flags) with repel. |
| [`theme_world_map()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/theme_world_map.md) | F | Standalone map theme. |

**Bundled data:** `world_snapshot`, `country_meta`, `common_indicators`,
`country_groups_tbl`, `world_tiles`.

------------------------------------------------------------------------

### One-paragraph summary

The 1.0.0 release keeps `worlddatajoin`’s soul — *ISO codes as the
universal join key, one call to a map-ready table* — and pushes it to
its full potential in a single release. It generalizes the core to **any
indicator, any year span, and a modern `sf` backend**; it finally
**exposes the join machinery for the user’s own data**
([`join_world()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/join_world.md),
[`standardize_country()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/standardize_country.md),
[`country_join()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/country_join.md))
with **honest diagnostics**
([`check_country_match()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/check_country_match.md),
[`audit_coverage()`](https://pursuitofdatascience.github.io/worlddatajoin/reference/audit_coverage.md))
instead of silent drops; it ships the **reference data** people
repeatedly hand-assemble (metadata, group memberships, an indicator
catalog, flags & currencies); it adds **analysis helpers** (per-capita,
regional roll-ups, ranking) so the pipeline never has to leave the
package; and it turns one hand-drawn choropleth into a **full map
vocabulary** — binned/quantile choropleths, proportional-symbol,
bivariate, cartogram, tile-grid, flow, animated, and interactive — all
projected and area-honest by default. Same spirit, an order of magnitude
more useful.
