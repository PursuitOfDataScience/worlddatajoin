# Clear the on-disk / in-memory WDI cache

Forget memoised World Bank fetches, both in-session and (optionally) on
disk.

## Usage

``` r
clear_wdi_cache(disk = FALSE)
```

## Arguments

- disk:

  Whether to also delete the persistent on-disk cache.

## Value

Invisibly `TRUE`.

## Examples

``` r
if (FALSE) { # \dontrun{
clear_wdi_cache()
} # }
```
