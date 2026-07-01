# Lightweight one-row-per-country table

The analysis counterpart to
[`world_data()`](https://pursuitofdatascience.github.io/countryatlas/reference/world_data.md):
no polygons, one tidy row per country (`iso3c`, `iso2c`, `country`,
classifications and the requested indicators). This is what you actually
`join()` /
[`mutate()`](https://dplyr.tidyverse.org/reference/mutate.html) /
[`summarise()`](https://dplyr.tidyverse.org/reference/summarise.html) /
[`rank()`](https://rdrr.io/r/base/rank.html) on; attach geometry only at
draw time with
[`attach_geometry()`](https://pursuitofdatascience.github.io/countryatlas/reference/attach_geometry.md).

## Usage

``` r
country_data(
  year,
  indicator = NULL,
  latest = FALSE,
  panel = FALSE,
  classify = c("income", "continent", "region"),
  cache = TRUE,
  language = "en",
  parallel = TRUE
)
```

## Arguments

- year:

  A single year or a range (with `panel = TRUE`).

- indicator:

  A named character vector of WDI codes (or `NULL` for none).

- latest:

  Use the most recent non-`NA` value per country (single year).

- panel:

  Return a panel keyed on `iso3c` + `year` (implied when `year` spans
  multiple years).

- classify:

  Which classifications to add.

- cache:

  Whether to use the WDI cache.

- language:

  WDI language code.

- parallel:

  Whether to fetch indicators in parallel.

## Value

A tibble, one row per country (or per country-year for a panel).

## Examples

``` r
# \donttest{
country_data(2020, c(co2 = "EN.ATM.CO2E.KT"))
#> Warning: URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=2': Timeout of 60 seconds was reached
#> Warning: URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=3': Timeout of 60 seconds was reached
#> Warning: URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=4': Timeout of 60 seconds was reached
#> Warning: URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=5': Timeout of 60 seconds was reached
#> Warning: URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=6': Timeout of 60 seconds was reached
#> Warning: URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=7': Timeout of 60 seconds was reached
#> Warning: URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=8': Timeout of 60 seconds was reached
#> Warning: URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=9': Timeout of 60 seconds was reached
#> Warning: cannot open URL 'https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=2020:2020&per_page=32500&page=10': HTTP status was '502 Bad Gateway'
#> Warning: Could not fetch indicator "EN.ATM.CO2E.KT" from the World Bank API.
#> ✖ The following indicators could not be downloaded: EN.ATM.CO2E.KT.
#> 
#> Please make sure that you are running the latest version of the `WDI` package,
#>   and that the arguments you are using in the `WDI()` function are valid.
#> 
#> Sometimes, downloads will suddenly stop working, even if nothing has changed in
#>   the R code of the WDI package. ("The same WDI package version worked
#>   yesterday!") In those cases, the problem is almost certainly related to the
#>   World Bank servers or to your internet connection.
#> 
#> You can check if the World Bank web API is currently serving the indicator(s)
#>   of interest by typing a URL of this form in your web browser:
#> 
#> https://api.worldbank.org/v2/en/country/all/indicator/EN.ATM.CO2E.KT?format=json&date=:&per_page=32500&page=1
#> # A tibble: 249 × 6
#>    iso3c iso2c country           continent  region                        income
#>    <chr> <chr> <chr>             <chr>      <chr>                         <fct> 
#>  1 AFG   AF    Afghanistan       Asia       Middle East, North Africa, A… Low i…
#>  2 ALB   AL    Albania           Europe     Europe & Central Asia         Upper…
#>  3 DZA   DZ    Algeria           Africa     Middle East, North Africa, A… Upper…
#>  4 ASM   AS    American Samoa    Oceania    East Asia & Pacific           High …
#>  5 AND   AD    Andorra           Europe     Europe & Central Asia         High …
#>  6 AGO   AO    Angola            Africa     Sub-Saharan Africa            Lower…
#>  7 AIA   AI    Anguilla          Americas   NA                            NA    
#>  8 ATA   AQ    Antarctica        Antarctica NA                            NA    
#>  9 ATG   AG    Antigua & Barbuda Americas   Latin America & Caribbean     High …
#> 10 ARG   AR    Argentina         Americas   Latin America & Caribbean     Upper…
#> # ℹ 239 more rows
# }
```
