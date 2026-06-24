# Curated country-name overrides (replaces the silent drop-list)

A documented `custom_match` table for entities that map backends
([`ggplot2::map_data()`](https://ggplot2.tidyverse.org/reference/map_data.html)
and Natural Earth) get wrong or leave without an ISO code. Earlier
versions of the package *deleted* these regions; now they are *matched*
instead, so they stop silently disappearing from maps.

`country_overrides()` is the preferred name as of the package's rename
to countryatlas; `wdj_overrides()` is kept as a backward-compatible
alias.

## Usage

``` r
wdj_overrides(extra = NULL)

country_overrides(extra = NULL)
```

## Arguments

- extra:

  An optional named character vector of additional overrides (names are
  country/region names, values are `iso3c` codes). Merged on top of the
  built-in table, so you can extend or override it, e.g.
  `wdj_overrides(c(Somaliland = "SOM"))`.

## Value

A named character vector suitable for `countrycode(custom_match=)`.

## Details

The table maps a country/region name (as spelled by the geometry
backends) to an ISO 3166-1 alpha-3 code. Pass the result as the
`custom_match` argument to
[`standardize_country()`](https://pursuitofdatascience.github.io/countryatlas/reference/standardize_country.md),
[`world_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_data.md)
and friends. Every downstream code (`iso2c`, continent, region, flag,
...) is derived from this `iso3c`, so a single override is enough.

## Examples

``` r
wdj_overrides()
#>               Ascension Island                         Azores 
#>                          "SHN"                          "PRT" 
#>                        Barbuda                        Bonaire 
#>                          "ATG"                          "BES" 
#>                 Canary Islands             Chagos Archipelago 
#>                          "ESP"                          "IOT" 
#>                     Grenadines                   Heard Island 
#>                          "VCT"                          "HMD" 
#>                         Kosovo                Madeira Islands 
#>                          "XKX"                          "PRT" 
#>                     Micronesia                           Saba 
#>                          "FSM"                          "BES" 
#>                   Saint Martin                Siachen Glacier 
#>                          "MAF"                          "IND" 
#>                 Sint Eustatius                 Virgin Islands 
#>                          "BES"                          "VIR" 
#>               Saint Barthelemy                        Curacao 
#>                          "BLM"                          "CUW" 
#>                        Madeira Federated States of Micronesia 
#>                          "PRT"                          "FSM" 
#>          Micronesia, Fed. Sts.           Virgin Islands, U.S. 
#>                          "FSM"                          "VIR" 
#>         British Virgin Islands                Channel Islands 
#>                          "VGB"                          "GBR" 
#>            Kosovo, Republic of 
#>                          "XKX" 
wdj_overrides(c(Somaliland = "SOM"))
#>               Ascension Island                         Azores 
#>                          "SHN"                          "PRT" 
#>                        Barbuda                        Bonaire 
#>                          "ATG"                          "BES" 
#>                 Canary Islands             Chagos Archipelago 
#>                          "ESP"                          "IOT" 
#>                     Grenadines                   Heard Island 
#>                          "VCT"                          "HMD" 
#>                         Kosovo                Madeira Islands 
#>                          "XKX"                          "PRT" 
#>                     Micronesia                           Saba 
#>                          "FSM"                          "BES" 
#>                   Saint Martin                Siachen Glacier 
#>                          "MAF"                          "IND" 
#>                 Sint Eustatius                 Virgin Islands 
#>                          "BES"                          "VIR" 
#>               Saint Barthelemy                        Curacao 
#>                          "BLM"                          "CUW" 
#>                        Madeira Federated States of Micronesia 
#>                          "PRT"                          "FSM" 
#>          Micronesia, Fed. Sts.           Virgin Islands, U.S. 
#>                          "FSM"                          "VIR" 
#>         British Virgin Islands                Channel Islands 
#>                          "VGB"                          "GBR" 
#>            Kosovo, Republic of                     Somaliland 
#>                          "XKX"                          "SOM" 
country_overrides()
#>               Ascension Island                         Azores 
#>                          "SHN"                          "PRT" 
#>                        Barbuda                        Bonaire 
#>                          "ATG"                          "BES" 
#>                 Canary Islands             Chagos Archipelago 
#>                          "ESP"                          "IOT" 
#>                     Grenadines                   Heard Island 
#>                          "VCT"                          "HMD" 
#>                         Kosovo                Madeira Islands 
#>                          "XKX"                          "PRT" 
#>                     Micronesia                           Saba 
#>                          "FSM"                          "BES" 
#>                   Saint Martin                Siachen Glacier 
#>                          "MAF"                          "IND" 
#>                 Sint Eustatius                 Virgin Islands 
#>                          "BES"                          "VIR" 
#>               Saint Barthelemy                        Curacao 
#>                          "BLM"                          "CUW" 
#>                        Madeira Federated States of Micronesia 
#>                          "PRT"                          "FSM" 
#>          Micronesia, Fed. Sts.           Virgin Islands, U.S. 
#>                          "FSM"                          "VIR" 
#>         British Virgin Islands                Channel Islands 
#>                          "VGB"                          "GBR" 
#>            Kosovo, Republic of 
#>                          "XKX" 
```
