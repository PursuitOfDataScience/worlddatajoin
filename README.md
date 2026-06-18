
<!-- README.md is generated from README.Rmd. Please edit that file -->

# countryatlas <img src="man/figures/logo.png" align="right" height="120" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/PursuitOfDataScience/countryatlas/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/PursuitOfDataScience/countryatlas/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/PursuitOfDataScience/countryatlas/branch/main/graph/badge.svg)](https://app.codecov.io/gh/PursuitOfDataScience/countryatlas)
[![Lifecycle:
stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)
<!-- badges: end -->

Country names never line up across data sources. `"US"`, `"U.S."`,
`"United States"`, `"United States of America"` and `"America"` are the
same country, but a naïve `left_join()` treats them as five.
**countryatlas** kills that pain by making **ISO codes the universal
join key** and handing you a single, ready-to-map tibble that already
stitches together three otherwise disjoint worlds:

- **`ggplot2::map_data("world")`** (or Natural Earth `sf`) — *where*
  countries are,
- **[WDI](https://github.com/vincentarelbundock/WDI)** — *what* is true
  about them (World Bank indicators),
- **[countrycode](https://github.com/vincentarelbundock/countrycode)** —
  the Rosetta stone (ISO codes, continents, regions) that makes the join
  possible.

The happy path is one call: `world_data(2020)`. Everything else is
opt-in.

## Installation

``` r
# install.packages("devtools")
devtools::install_github("PursuitOfDataScience/countryatlas")
```

The base install is light. Heavy spatial extras (`sf`, `rnaturalearth`,
`cartogram`, `biscale`, `geofacet`, `gganimate`, `leaflet`, …) live in
`Suggests` and are only needed for the features that use them.

``` r
library(countryatlas)
library(ggplot2)
library(dplyr)
```

## One call to a map-ready tibble

``` r
data_2020 <- world_data(2020)
data_2020
#> # A tibble: 99,338 × 13
#>     long   lat group order subregion iso3c iso2c country continent region income
#>    <dbl> <dbl> <dbl> <int> <chr>     <chr> <chr> <chr>   <chr>     <chr>  <fct> 
#>  1 -69.9  12.5     1     1 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#>  2 -69.9  12.4     1     2 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#>  3 -69.9  12.4     1     3 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#>  4 -70.0  12.5     1     4 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#>  5 -70.1  12.5     1     5 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#>  6 -70.1  12.6     1     6 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#>  7 -70.0  12.6     1     7 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#>  8 -70.0  12.6     1     8 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#>  9 -69.9  12.5     1     9 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#> 10 -69.9  12.5     1    10 <NA>      ABW   AW    Aruba   Americas  Latin… High …
#> # ℹ 99,328 more rows
#> # ℹ 2 more variables: gdp_per_capita <dbl>, gdp_per_capita_2015 <dbl>
```

`world_data()` returns the map geometry, the requested World Bank
indicator(s), income and continent — already keyed on `iso3c`/`iso2c`.
Draw a choropleth with the built-in `world_map()` helper (no more
hand-rolled `geom_polygon()` boilerplate):

``` r
world_map(data_2020, gdp_per_capita, style = "quantile",
          title = "GDP per capita, 2020")
```

<img src="man/figures/README-readme-choropleth-1.png" width="100%" />

``` r
world_map(data_2020, income, style = "categorical")
```

<img src="man/figures/README-readme-income-1.png" width="100%" />

## Any indicator, any year span

Pass one or many WDI codes with friendly names, or a year range to get a
panel:

``` r
country_data(2020, c(life_exp = "SP.DYN.LE00.IN", co2 = "EN.GHG.CO2.PC.CE.AR5")) |>
  head()
#> # A tibble: 6 × 8
#>   iso3c iso2c country        continent region           income life_exp      co2
#>   <chr> <chr> <chr>          <chr>     <chr>            <fct>     <dbl>    <dbl>
#> 1 AFG   AF    Afghanistan    Asia      Middle East, No… Low i…     61.5  0.311  
#> 2 ALB   AL    Albania        Europe    Europe & Centra… Upper…     77.8  1.81   
#> 3 DZA   DZ    Algeria        Africa    Middle East, No… Upper…     73.3  3.90   
#> 4 ASM   AS    American Samoa Oceania   East Asia & Pac… High …     72.7  0.00201
#> 5 AND   AD    Andorra        Europe    Europe & Centra… High …     79.4 NA      
#> 6 AGO   AO    Angola         Africa    Sub-Saharan Afr… Lower…     63.1  0.614
```

Use the bundled `common_indicators` catalogue so you never memorise a
code:

``` r
head(common_indicators)
#> # A tibble: 6 × 3
#>   name                   code           description                       
#>   <chr>                  <chr>          <chr>                             
#> 1 population             SP.POP.TOTL    Population, total                 
#> 2 gdp                    NY.GDP.MKTP.CD GDP (current US$)                 
#> 3 gdp_constant           NY.GDP.MKTP.KD GDP (constant 2015 US$)           
#> 4 gdp_per_capita         NY.GDP.PCAP.KD GDP per capita (constant 2015 US$)
#> 5 gdp_per_capita_current NY.GDP.PCAP.CD GDP per capita (current US$)      
#> 6 gni_per_capita         NY.GNP.PCAP.CD GNI per capita (current US$)
```

## Get *your own* data onto a map

This is the headline use case. You have a frame keyed on messy country
names — `join_world()` standardises it and attaches geometry in one
call:

``` r
my_data <- data.frame(
  nation = c("U.S.", "S. Korea", "Czechia", "Kosovo", "Cote d'Ivoire"),
  score  = c(10, 8, 6, 4, 7)
)

my_data |>
  join_world(nation, warn = FALSE) |>
  world_map(score, title = "My data, joined on the ISO spine")
```

<img src="man/figures/README-readme-join-1.png" width="100%" />

Or reconcile two messy tables directly — `"Czech Republic"` vs
`"Czechia"`, `"South Korea"` vs `"Korea, Rep."` just work:

``` r
a <- data.frame(country = c("Czechia", "South Korea"), gdp = c(1, 2))
b <- data.frame(nation  = c("Czech Republic", "Korea, Rep."), pop = c(10, 51))
country_join(a, b, country, nation)
#> # A tibble: 2 × 5
#>   country       gdp iso3c nation           pop
#>   <chr>       <dbl> <chr> <chr>          <dbl>
#> 1 Czechia         1 CZE   Czech Republic    10
#> 2 South Korea     2 KOR   Korea, Rep.       51
```

## Never lose a country silently

``` r
check_country_match(c("USA", "Cote d'Ivoire", "Yugoslavia", "Wakanda"))
#> # A tibble: 4 × 4
#>   input         iso3c matched suggestion
#>   <chr>         <chr> <lgl>   <chr>     
#> 1 USA           USA   TRUE    <NA>      
#> 2 Cote d'Ivoire CIV   TRUE    <NA>      
#> 3 Yugoslavia    <NA>  FALSE   Yugoslavia
#> 4 Wakanda       <NA>  FALSE   Canada
```

## Reference data at your fingertips

``` r
convert_country(c("Japan", "Brazil", "Germany"), to = "flag")
#> [1] "🇯🇵" "🇧🇷" "🇩🇪"
convert_country(c("Japan", "Brazil", "Germany"), to = "currency")
#> [1] "JPY" "BRL" "EUR"
in_group(c("France", "United States", "Japan"), "EU")
#> [1]  TRUE FALSE FALSE
```

## A whole vocabulary of honest maps

Beyond the choropleth: proportional-symbol (`bubble_map()`), bivariate
(`bivariate_map()`), area-honest cartograms (`cartogram_map()`),
equal-area tile grids (`tile_map()`), great-circle flows (`flow_map()`),
animation (`animate_world()`) and interactivity (`interactive_map()`).

``` r
bubble_map(world_snapshot$countries, population)
```

<img src="man/figures/README-readme-bubble-1.png" width="100%" />

## Offline by default

The bundled `world_snapshot` (a curated indicator set for one recent
year, plus metadata) means examples, tests and vignettes all run without
the World Bank API.

## Learn more

See the vignettes — *Getting started*, *Joining your own data*, *Modern
maps with sf & projections*, and *Beyond the choropleth* — and the
[reference site](https://pursuitofdatascience.github.io/countryatlas/).
