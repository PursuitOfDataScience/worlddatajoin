# Analysis helpers --------------------------------------------------------------

#' Normalise an indicator by population
#'
#' Removes the "is this map just a population map?" footgun by dividing a value
#' column by population. If no population column is supplied, `SP.POP.TOTL` is
#' pulled automatically for the relevant countries and years.
#'
#' @param data A country-level (or panel) data frame with `iso3c`.
#' @param value The value column to normalise (unquoted).
#' @param pop Optional population column (unquoted). If absent, population is
#'   fetched from WDI.
#' @param suffix Suffix for the new column (default `"_per_capita"`).
#' @param cache Whether to use the WDI cache when fetching population.
#'
#' @return `data` with a new per-capita column.
#' @export
#' @examples
#' df <- data.frame(iso3c = c("USA", "CHN"), year = 2020L,
#'                  co2 = c(5e6, 1e7), pop = c(331e6, 1402e6))
#' per_capita(df, co2, pop)
per_capita <- function(data, value, pop = NULL, suffix = "_per_capita",
                       cache = TRUE) {
  val_name <- rlang::as_name(rlang::enquo(value))
  if (!val_name %in% names(data)) {
    wdj_abort("Column {.val {val_name}} not found in {.arg data}.")
  }
  pop_q <- rlang::enquo(pop)
  if (!rlang::quo_is_null(pop_q)) {
    pop_name <- rlang::as_name(pop_q)
    pop_vec <- data[[pop_name]]
  } else {
    if (!"iso3c" %in% names(data)) {
      wdj_abort("{.arg data} needs an {.field iso3c} column to fetch population.")
    }
    years <- if ("year" %in% names(data)) unique(stats::na.omit(data$year)) else {
      as.integer(format(Sys.Date(), "%Y")) - 1L
    }
    popdf <- fetch_wdi(c(.wdj_pop = "SP.POP.TOTL"),
                       start = min(years), end = max(years), cache = cache)
    if ("year" %in% names(data)) {
      data <- dplyr::left_join(data, popdf[, c("iso3c", "year", ".wdj_pop")],
                               by = c("iso3c", "year"))
    } else {
      popdf <- dplyr::distinct(popdf, .data$iso3c, .keep_all = TRUE)
      data <- dplyr::left_join(data, popdf[, c("iso3c", ".wdj_pop")], by = "iso3c")
    }
    pop_vec <- data[[".wdj_pop"]]
    data[[".wdj_pop"]] <- NULL
  }

  new_col <- paste0(val_name, suffix)
  data[[new_col]] <- data[[val_name]] / pop_vec
  tibble::as_tibble(data)
}

#' Roll countries up to region / income / continent
#'
#' Aggregate a country-level value to a coarser grouping, optionally with
#' population-weighted means.
#'
#' @param data A country-level data frame.
#' @param value The value column to aggregate (unquoted).
#' @param by Grouping column(s) (character), default `"region"`. Combine with
#'   `"year"` for panel roll-ups.
#' @param fun Aggregation: `"sum"` (default), `"mean"`, `"median"`, `"min"`,
#'   `"max"` or `"weighted_mean"`.
#' @param weight Optional weight column (unquoted) for `"weighted_mean"`.
#'
#' @return A tibble of `by` plus the aggregated value.
#' @export
#' @examples
#' df <- data.frame(iso3c = c("USA", "CAN", "BRA"),
#'                  region = c("North America", "North America", "Latin America"),
#'                  gdp = c(21, 1.7, 1.4))
#' aggregate_regions(df, gdp, fun = "sum")
aggregate_regions <- function(data, value, by = "region", fun = "sum",
                              weight = NULL) {
  val_name <- rlang::as_name(rlang::enquo(value))
  fun <- match.arg(fun, c("sum", "mean", "median", "min", "max", "weighted_mean"))
  missing_by <- setdiff(by, names(data))
  if (length(missing_by)) {
    wdj_abort("Grouping column{?s} {.val {missing_by}} not found in {.arg data}.")
  }
  w_q <- rlang::enquo(weight)
  has_w <- !rlang::quo_is_null(w_q)
  if (fun == "weighted_mean" && !has_w) {
    wdj_abort('{.arg weight} is required when {.code fun = "weighted_mean"}.')
  }

  grouped <- dplyr::group_by(data, dplyr::across(dplyr::all_of(by)))
  out <- if (fun == "weighted_mean") {
    w_name <- rlang::as_name(w_q)
    dplyr::summarise(
      grouped,
      "{val_name}" := stats::weighted.mean(.data[[val_name]], .data[[w_name]],
                                           na.rm = TRUE),
      .groups = "drop"
    )
  } else {
    f <- switch(fun, sum = sum, mean = mean, median = stats::median,
                min = min, max = max)
    dplyr::summarise(
      grouped,
      "{val_name}" := f(.data[[val_name]], na.rm = TRUE),
      .groups = "drop"
    )
  }
  out
}

#' Add rank, percentile and z-score
#'
#' Adds `rank`, `percentile` and `z_score` for a value column, optionally within
#' a group (region, year, ...), for "top 10" tables and labelling.
#'
#' @param data A data frame.
#' @param value The value column to rank (unquoted).
#' @param within Optional grouping column(s) (unquoted or character) to rank
#'   within.
#' @param desc Rank descending (largest = rank 1); default `TRUE`.
#'
#' @return `data` with `rank`, `percentile` and `z_score` columns added.
#' @export
#' @examples
#' df <- data.frame(iso3c = c("USA", "CHN", "IND"), gdp = c(21, 17, 3))
#' rank_countries(df, gdp)
rank_countries <- function(data, value, within = NULL, desc = TRUE) {
  val_name <- rlang::as_name(rlang::enquo(value))
  if (!val_name %in% names(data)) {
    wdj_abort("Column {.val {val_name}} not found in {.arg data}.")
  }
  within_q <- rlang::enquo(within)
  if (!rlang::quo_is_null(within_q)) {
    within_cols <- tryCatch(
      rlang::as_name(within_q),
      error = function(e) as.character(rlang::eval_tidy(within_q))
    )
    data <- dplyr::group_by(data, dplyr::across(dplyr::all_of(within_cols)))
  }
  ord <- if (isTRUE(desc)) function(x) dplyr::desc(x) else function(x) x
  out <- dplyr::mutate(
    data,
    rank = dplyr::min_rank(ord(.data[[val_name]])),
    percentile = dplyr::percent_rank(.data[[val_name]]),
    z_score = as.numeric(scale(.data[[val_name]]))
  )
  dplyr::ungroup(out)
}

#' Fill or interpolate panel gaps
#'
#' Completes a panel so every country has every year, optionally filling missing
#' values by carry-forward (`"locf"`) or linear interpolation (`"linear"`) so
#' animations do not flicker on missing years.
#'
#' @param data A panel with `iso3c` and `year`.
#' @param years The full set of years to complete to. Defaults to the observed
#'   min:max.
#' @param value Optional value column(s) (character) to fill. If `NULL`, all
#'   numeric columns except `year` are filled.
#' @param method `"none"` (default; just complete the grid), `"locf"` or
#'   `"linear"`.
#'
#' @return A completed (and optionally filled) panel tibble.
#' @export
#' @examples
#' df <- data.frame(iso3c = "USA", year = c(2000L, 2002L), gdp = c(1, 3))
#' complete_years(df, 2000:2002, method = "linear")
complete_years <- function(data, years = NULL, value = NULL,
                           method = c("none", "locf", "linear")) {
  method <- match.arg(method)
  if (!all(c("iso3c", "year") %in% names(data))) {
    wdj_abort("{.arg data} must have {.field iso3c} and {.field year} columns.")
  }
  if (is.null(years)) years <- seq(min(data$year), max(data$year))
  years <- as.integer(years)

  if (is.null(value)) {
    value <- names(data)[vapply(data, is.numeric, logical(1))]
    value <- setdiff(value, "year")
  }

  # Carry static (non-value) attributes along.
  static <- setdiff(names(data), c("year", value))

  out <- data %>%
    dplyr::group_by(.data$iso3c) %>%
    tidyr::complete(year = years) %>%
    tidyr::fill(dplyr::all_of(setdiff(static, "iso3c")),
                .direction = "downup")

  if (method == "locf") {
    out <- tidyr::fill(out, dplyr::all_of(value), .direction = "down")
  } else if (method == "linear") {
    out <- out %>%
      dplyr::arrange(.data$year, .by_group = TRUE) %>%
      dplyr::mutate(dplyr::across(
        dplyr::all_of(value),
        ~ wdj_interp_linear(.data$year, .x)
      ))
  }
  dplyr::ungroup(out)
}

# Linear interpolation of interior NAs (no extrapolation beyond observed range).
wdj_interp_linear <- function(x, y) {
  ok <- !is.na(y)
  if (sum(ok) < 2L) return(y)
  stats::approx(x[ok], y[ok], xout = x, rule = 1)$y
}

#' Year-on-year (or compound) growth rate
#'
#' Adds a growth-rate column to a panel: either the period-over-period change
#' (`"yoy"`) or the compound annual growth rate from the first observed year
#' (`"cagr"`), computed per country.
#'
#' @param data A panel with `iso3c` and `year`.
#' @param value The value column (unquoted).
#' @param type `"yoy"` (default, period-over-period) or `"cagr"` (compound
#'   annual growth rate vs. the first non-`NA` year).
#' @param suffix Suffix for the new column (default `"_growth"`).
#'
#' @return `data` with a growth-rate column added (a proportion, so 0.03 = 3%).
#' @export
#' @examples
#' df <- data.frame(iso3c = "USA", year = 2000:2002, gdp = c(100, 110, 121))
#' growth_rate(df, gdp)
growth_rate <- function(data, value, type = c("yoy", "cagr"),
                        suffix = "_growth") {
  type <- match.arg(type)
  val_name <- rlang::as_name(rlang::enquo(value))
  if (!all(c("iso3c", "year") %in% names(data))) {
    wdj_abort("{.arg data} must have {.field iso3c} and {.field year} columns.")
  }
  if (!val_name %in% names(data)) {
    wdj_abort("Column {.val {val_name}} not found in {.arg data}.")
  }
  new_col <- paste0(val_name, suffix)
  out <- data %>%
    dplyr::group_by(.data$iso3c) %>%
    dplyr::arrange(.data$year, .by_group = TRUE)
  out <- if (type == "yoy") {
    dplyr::mutate(
      out,
      "{new_col}" := .data[[val_name]] / dplyr::lag(.data[[val_name]]) - 1
    )
  } else {
    dplyr::mutate(
      out,
      "{new_col}" := {
        base_i <- which(!is.na(.data[[val_name]]))[1]
        v0 <- .data[[val_name]][base_i]; y0 <- .data$year[base_i]
        n <- .data$year - y0
        ifelse(n > 0 & !is.na(v0) & v0 > 0,
               (.data[[val_name]] / v0)^(1 / n) - 1, NA_real_)
      }
    )
  }
  dplyr::ungroup(out)
}

#' Rebase a series to an index (base year = 100)
#'
#' Rescales a value column so the chosen base year equals `to` (100 by default),
#' per country -- the standard way to compare trajectories that start at very
#' different levels.
#'
#' @param data A panel with `iso3c` and `year`.
#' @param value The value column (unquoted).
#' @param base_year The year set equal to `to`.
#' @param to The index value the base year maps to (default `100`).
#' @param suffix Suffix for the new column (default `"_index"`).
#'
#' @return `data` with an index column added.
#' @export
#' @examples
#' df <- data.frame(iso3c = "USA", year = 2000:2002, gdp = c(50, 55, 60))
#' index_to(df, gdp, base_year = 2000)
index_to <- function(data, value, base_year, to = 100, suffix = "_index") {
  val_name <- rlang::as_name(rlang::enquo(value))
  if (!all(c("iso3c", "year") %in% names(data))) {
    wdj_abort("{.arg data} must have {.field iso3c} and {.field year} columns.")
  }
  new_col <- paste0(val_name, suffix)
  out <- data %>%
    dplyr::group_by(.data$iso3c) %>%
    dplyr::mutate(
      "{new_col}" := {
        base <- .data[[val_name]][.data$year == base_year][1]
        if (length(base) == 0L || is.na(base) || base == 0) NA_real_
        else .data[[val_name]] / base * to
      }
    )
  dplyr::ungroup(out)
}

#' Each country's share of the world total
#'
#' Adds a column giving each country's value as a share of the (year's) world
#' total -- e.g. share of global emissions or GDP. Operates within `year` when a
#' panel is supplied.
#'
#' @param data A country-level (or panel) data frame.
#' @param value The value column (unquoted).
#' @param suffix Suffix for the new column (default `"_share"`).
#'
#' @return `data` with a share column added (a proportion in `[0, 1]`).
#' @export
#' @examples
#' df <- data.frame(iso3c = c("USA", "CHN"), co2 = c(5, 10))
#' share_of_world(df, co2)
share_of_world <- function(data, value, suffix = "_share") {
  val_name <- rlang::as_name(rlang::enquo(value))
  if (!val_name %in% names(data)) {
    wdj_abort("Column {.val {val_name}} not found in {.arg data}.")
  }
  new_col <- paste0(val_name, suffix)
  out <- if ("year" %in% names(data)) {
    dplyr::group_by(data, .data$year)
  } else {
    data
  }
  out <- dplyr::mutate(
    out,
    "{new_col}" := .data[[val_name]] / sum(.data[[val_name]], na.rm = TRUE)
  )
  dplyr::ungroup(tibble::as_tibble(out))
}
