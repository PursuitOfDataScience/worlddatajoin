#' \code{worlddatajoin} package
#'
#' Join 'WDI', 'countrycode', and the World Map Together
#'
#'
#'
#' @docType package
#' @name worlddatajoin
#' @import utils
NULL


if(getRversion() >= "2.15.1")  utils::globalVariables(c("region",
                                                        "NY.GDP.PCAP.KD",
                                                        "country",
                                                        "gdp_per_capita_2015",
                                                        "iso2c",
                                                        "iso3c",
                                                        "income"))
