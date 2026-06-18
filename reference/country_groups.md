# Country-group membership

Answers the constant question "is this country in the EU / OECD / G7 /
G20 / BRICS / ...?" from a curated, dated membership table
(point-in-time membership is genuinely fiddly, so it is shipped and
maintained, not guessed). See
[country_groups_tbl](https://pursuitofdatascience.github.io/countryatlas/reference/country_groups_tbl.md).

## Usage

``` r
country_groups(group = NULL)
```

## Arguments

- group:

  One or more group names: any of `"EU"`, `"OECD"`, `"G7"`, `"G20"`,
  `"BRICS"`, `"ASEAN"`, `"EFTA"`, `"Commonwealth"`, `"OPEC"`,
  `"EuroZone"`, `"NATO"`. If `NULL`, the whole table is returned.

## Value

A tibble of `group`, `iso3c`, `country`.

## Examples

``` r
country_groups("EU")
#> # A tibble: 27 × 3
#>    group iso3c country 
#>    <chr> <chr> <chr>   
#>  1 EU    AUT   Austria 
#>  2 EU    BEL   Belgium 
#>  3 EU    BGR   Bulgaria
#>  4 EU    HRV   Croatia 
#>  5 EU    CYP   Cyprus  
#>  6 EU    CZE   Czechia 
#>  7 EU    DNK   Denmark 
#>  8 EU    EST   Estonia 
#>  9 EU    FIN   Finland 
#> 10 EU    FRA   France  
#> # ℹ 17 more rows
country_groups(c("G7", "BRICS"))
#> # A tibble: 12 × 3
#>    group iso3c country       
#>    <chr> <chr> <chr>         
#>  1 BRICS BRA   Brazil        
#>  2 BRICS CHN   China         
#>  3 BRICS IND   India         
#>  4 BRICS RUS   Russia        
#>  5 BRICS ZAF   South Africa  
#>  6 G7    CAN   Canada        
#>  7 G7    FRA   France        
#>  8 G7    DEU   Germany       
#>  9 G7    ITA   Italy         
#> 10 G7    JPN   Japan         
#> 11 G7    GBR   United Kingdom
#> 12 G7    USA   United States 
```
