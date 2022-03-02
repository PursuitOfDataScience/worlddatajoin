#' Obtaining countries' information
#'
#' This function returns a tibble comprising geo coordinates of each country
#' with the iso2c and iso3c code, income and GDP per capita information, along
#' with which continent each country is classified with.
#'
#'
#' @param year Year. The minimum input year is 1960.
#' @import ggplot2
#' @import tibble
#' @import dplyr
#' @import countrycode
#' @import WDI
#' @return A tibble with country information around the world.
#' @export
#'
#' @examples
#' \dontrun{
#' world_data(2020)
#'}
world_data <- function(year){

  ggplot2::map_data("world") %>%
    tibble::tibble() %>%
    dplyr::filter(!region %in% c("Ascension Island",
                                 "Azores",
                                 "Barbuda",
                                 "Bonaire",
                                 "Canary Islands",
                                 "Chagos Archipelago",
                                 "Grenadines",
                                 "Heard Island",
                                 "Kosovo",
                                 "Madeira Islands",
                                 "Micronesia",
                                 "Saba",
                                 "Saint Martin",
                                 "Siachen Glacier",
                                 "Sint Eustatius",
                                 "Virgin Islands")) %>%
    dplyr::mutate(iso3c = countrycode::countrycode(region, origin = "country.name", destination = "iso3c"),
                  iso2c = countrycode::countrycode(region, origin = "country.name", destination = "iso2c")) %>%
    dplyr::left_join(WDI::WDI(start = year, end = year, extra = T) %>%
                       tibble::tibble() %>%
                       dplyr::rename(gdp_per_capita_2015 = NY.GDP.PCAP.KD) %>%
                       dplyr::select(country, gdp_per_capita_2015, iso2c, iso3c, income, year) %>%
                       dplyr::filter(income != "Aggregates") %>%
                       dplyr::mutate(income = factor(income, levels = c("Not Classified",
                                                                        "Low income",
                                                                        "Lower middle income",
                                                                        "Upper middle income",
                                                                        "High income"))),
                     by = c("iso2c", "iso3c")) %>%
    dplyr::mutate(continent = countrycode(iso3c, origin = "iso3c", destination = "continent"))

}
