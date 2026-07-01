# Standalone copy of the override mapping for the data-raw build, so the script
# does not depend on the package being installed. Keep in sync with
# R/overrides.R::wdj_overrides().

wdj_overrides_snapshot <- function() {
  c(
    "Ascension Island" = "SHN", "Azores" = "PRT", "Barbuda" = "ATG",
    "Bonaire" = "BES", "Canary Islands" = "ESP", "Chagos Archipelago" = "IOT",
    "Grenadines" = "VCT", "Heard Island" = "HMD", "Kosovo" = "XKX",
    "Madeira Islands" = "PRT", "Micronesia" = "FSM", "Saba" = "BES",
    "Saint Martin" = "MAF", "Siachen Glacier" = "IND", "Sint Eustatius" = "BES",
    "Virgin Islands" = "VIR", "Saint Barthelemy" = "BLM", "Curacao" = "CUW",
    "Madeira" = "PRT",
    "Federated States of Micronesia" = "FSM",
    "Micronesia, Fed. Sts." = "FSM",
    "Virgin Islands, U.S." = "VIR",
    "British Virgin Islands" = "VGB",
    "Channel Islands" = "GBR",
    "Kosovo, Republic of" = "XKX"
  )
}

# Vectorised name -> iso3c using countrycode + the overrides.
wdj_overrides_iso <- function(x) {
  cm <- wdj_overrides_snapshot()
  countrycode::countrycode(as.character(x), "country.name", "iso3c",
                           custom_match = cm, warn = FALSE)
}
