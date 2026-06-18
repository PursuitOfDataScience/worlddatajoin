# Static per-country metadata

One row per country with the facts people constantly need and currently
scrape together by hand.

## Usage

``` r
country_meta
```

## Format

A tibble with one row per country and columns including `iso3c`,
`iso2c`, `country`, `continent`, `region`, `un_region`, `capital`,
`capital_lat`, `capital_lon`, `centroid_lat`, `centroid_lon`,
`area_km2`, `currency`, `tld`, `landlocked`, `flag`.

## Source

Assembled from countrycode, WDI metadata and Natural Earth geometry.
