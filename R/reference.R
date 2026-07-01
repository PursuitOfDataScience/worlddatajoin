# Reference data & code translation ---------------------------------------------

# Friendly shortcut -> countrycode destination scheme.
convert_dest_map <- function() {
  c(
    iso3c        = "iso3c",
    iso2c        = "iso2c",
    iso3n        = "iso3n",
    country      = "country.name.en",
    country.name = "country.name.en",
    name         = "country.name.en",
    continent    = "continent",
    region       = "region",
    region23     = "region23",
    un_region    = "un.region.name",
    flag         = "unicode.symbol",
    currency     = "iso4217c",
    tld          = "cctld",
    calling_code = "genc3c",   # not ideal; documented as best-effort
    cown         = "cown",
    cowc         = "cowc",
    p4n          = "p4n",
    p5n          = "p5n",
    gwn          = "gwn",
    vdem         = "vdem",
    imf          = "imf",
    fao          = "fao",
    fips         = "fips",
    gaul         = "gaul",
    wb           = "wb",
    un           = "un"
  )
}

#' Friendly country-code conversion
#'
#' A discoverable wrapper around [countrycode::countrycode()] exposing the full
#' set of schemes with first-class shortcuts for the high-value ones: flag
#' emoji, currency, top-level domain, continent/region and research codes
#' (Correlates of War, Polity, Gleditsch-Ward, V-Dem, IMF, FAO, FIPS, GAUL).
#'
#' @param x A vector of country names or codes.
#' @param to Destination scheme. A shortcut (`"iso3c"`, `"flag"`, `"currency"`,
#'   `"tld"`, `"continent"`, `"region"`, `"cown"`, ...) or any raw countrycode
#'   destination.
#' @param from Origin scheme (default `"country.name"`).
#' @param custom_match Optional overrides (default [wdj_overrides()]).
#' @param warn Whether to warn about unmatched inputs.
#'
#' @return A vector of converted codes.
#' @export
#' @examples
#' convert_country(c("Japan", "Brazil"), to = "flag")
#' convert_country("Germany", to = "currency")
#' convert_country(c("USA", "France"), to = "continent")
convert_country <- function(x, to = "iso3c", from = "country.name",
                            custom_match = wdj_overrides(), warn = TRUE) {
  m <- convert_dest_map()
  dest <- if (to %in% names(m)) m[[to]] else to
  # When reading names or iso3c, resolve to the override-corrected iso3c first
  # and then convert iso3c -> destination, so curated entities (Kosovo, Canary
  # Islands, ...) resolve for EVERY destination, not just iso3c.
  if (from %in% c("country.name", "iso3c")) {
    iso <- wdj_to_iso3c(x, origin = from, custom_match = custom_match)
    if (identical(dest, "iso3c")) return(iso)
    out <- suppressWarnings(
      countrycode::countrycode(iso, origin = "iso3c", destination = dest, warn = warn)
    )
    # A handful of user-assigned codes (Kosovo's XKX) have NO row at all in
    # countrycode::codelist, so the iso3c round-trip above is NA for every
    # destination -- even ones (flag, name, region) that countrycode's own
    # country.name matching resolves directly. Recover those from the
    # original name rather than lose information the iso3c hop doesn't have.
    if (identical(from, "country.name")) {
      miss <- is.na(out)
      if (any(miss)) {
        out[miss] <- suppressWarnings(
          countrycode::countrycode(x[miss], origin = "country.name",
                                   destination = dest, warn = FALSE)
        )
      }
    }
    # Even direct name matching doesn't classify iso2c/continent/region for
    # XKX; apply the same fallback standardize_country() uses, so
    # convert_country() and locate_country() agree with it.
    if (dest %in% c("iso2c", "continent", "region")) {
      out <- apply_code_fallback(tibble::tibble(iso3c = iso, "{dest}" := out))[[dest]]
    }
    return(out)
  }
  suppressWarnings(
    countrycode::countrycode(x, origin = from, destination = dest, warn = warn)
  )
}

#' The countrycode codelist as a tidy tibble
#'
#' The whole [countrycode::codelist] reshaped into a tidy, pipeable lookup you
#' can `filter()` / `join()` directly -- one row per country.
#'
#' @param codes Optional character vector of column names to keep (in addition
#'   to `iso3c`). If `NULL`, a useful default subset is returned.
#'
#' @return A tibble, one row per country.
#' @export
#' @examples
#' country_codes()
#' country_codes(c("iso2c", "continent", "currency"))
country_codes <- function(codes = NULL) {
  cl <- tibble::as_tibble(countrycode::codelist)
  # Friendly name -> raw codelist column, with the inverse for renaming output.
  raw_of <- c(country = "country.name.en", iso3c = "iso3c", iso2c = "iso2c",
              iso3n = "iso3n", continent = "continent", region = "region",
              region23 = "region23", un_region = "un.region.name",
              currency = "iso4217c", tld = "cctld", flag = "unicode.symbol")
  default <- c("country", "iso3c", "iso2c", "iso3n", "continent", "region",
               "region23", "currency", "tld", "flag")
  friendly <- if (is.null(codes)) default else unique(c("country", "iso3c", codes))
  # Allow either friendly names or raw codelist column names.
  raw <- vapply(friendly, function(f) {
    if (f %in% names(raw_of)) raw_of[[f]] else f
  }, character(1))
  inv <- stats::setNames(names(raw_of), raw_of)
  keep <- raw[raw %in% names(cl)]
  out <- cl[, unname(keep), drop = FALSE]
  # Rename raw columns back to friendly names where we know them.
  names(out) <- vapply(names(out), function(nm) {
    if (nm %in% names(inv)) inv[[nm]] else nm
  }, character(1))
  dplyr::filter(out, !is.na(.data$iso3c))
}

#' Country-group membership
#'
#' Answers the constant question "is this country in the EU / OECD / G7 / G20 /
#' BRICS / ...?" from a curated, dated membership table (point-in-time
#' membership is genuinely fiddly, so it is shipped and maintained, not
#' guessed). See [country_groups_tbl].
#'
#' @param group One or more group names: any of `"EU"`, `"OECD"`, `"G7"`,
#'   `"G20"`, `"BRICS"`, `"ASEAN"`, `"EFTA"`, `"Commonwealth"`, `"OPEC"`,
#'   `"EuroZone"`, `"NATO"`, `"Mercosur"`, `"GCC"`, `"Nordic"`, `"Visegrad"`.
#'   If `NULL`, the whole table is returned.
#'
#' @return A tibble of `group`, `iso3c`, `country`.
#' @export
#' @examples
#' country_groups("EU")
#' country_groups(c("G7", "BRICS"))
country_groups <- function(group = NULL) {
  tbl <- country_groups_tbl
  if (is.null(group)) return(tbl)
  valid <- unique(tbl$group)
  bad <- setdiff(group, valid)
  if (length(bad)) {
    wdj_abort(c(
      "Unknown group{?s}: {.val {bad}}.",
      "i" = "Available groups: {.val {valid}}."
    ))
  }
  grp <- group
  dplyr::filter(tbl, .data$group %in% grp)
}

#' Is a country in a group?
#'
#' A vectorised membership predicate built on [country_groups()].
#'
#' @param x A vector of country names or codes.
#' @param group A single group name (see [country_groups()]).
#' @param origin How to read `x` (default `"country.name"`).
#'
#' @return A logical vector the same length as `x`.
#' @export
#' @examples
#' in_group(c("France", "United States", "Japan"), "EU")
in_group <- function(x, group, origin = "country.name") {
  if (length(group) != 1L) wdj_abort("{.arg group} must be a single group name.")
  iso <- wdj_to_iso3c(x, origin = origin)
  members <- country_groups(group)$iso3c
  iso %in% members
}

#' Search World Bank indicators
#'
#' A tidy, pipeable wrapper on [WDI::WDIsearch()] for discovering indicator
#' codes.
#'
#' @param pattern A regular expression to search indicator names/codes for.
#' @param field Which field to search: `"name"` (default) or `"indicator"`.
#' @param cache Optional cached `WDIcache()` object; if `NULL`, WDI's bundled
#'   cache is used (no network).
#'
#' @return A tibble of matching `indicator` codes and `name`s.
#' @export
#' @examples
#' \donttest{
#' wdi_search("CO2 emissions")
#' }
wdi_search <- function(pattern, field = c("name", "indicator"), cache = NULL) {
  field <- match.arg(field)
  res <- WDI::WDIsearch(string = pattern, field = field, short = TRUE,
                        cache = cache)
  if (is.null(dim(res))) {
    res <- matrix(res, ncol = 2, dimnames = list(NULL, c("indicator", "name")))
  }
  tibble::as_tibble(res)
}
