# Geometry backends & utilities -------------------------------------------------

# The projections countryatlas knows how to build a CRS for.
wdj_projections <- function() {
  c("equal_earth", "robinson", "mollweide", "natural_earth", "plate_carree",
    "mercator", "winkel_tripel", "eckert4", "gall_peters", "orthographic",
    "azimuthal_equal_area", "north_polar", "south_polar")
}

# Map projection -> a CRS usable by sf::st_transform / ggplot2::coord_sf.
# `recenter` shifts the central meridian (e.g. 150 for a Pacific-centred map);
# `lat0` sets the central latitude for the azimuthal projections (orthographic).
wdj_crs <- function(projection = "equal_earth", recenter = NULL, lat0 = NULL) {
  projection <- match.arg(projection, wdj_projections())
  lon0 <- recenter %||% 0
  proj4 <- switch(
    projection,
    equal_earth          = "+proj=eqearth",
    robinson             = "+proj=robin",
    mollweide            = "+proj=moll",
    natural_earth        = "+proj=natearth",
    # Plate carree is equirectangular (+proj=eqc), NOT geographic (+proj=longlat).
    plate_carree         = "+proj=eqc +lat_ts=0",
    mercator             = "+proj=merc",
    winkel_tripel        = "+proj=wintri",
    eckert4              = "+proj=eck4",
    gall_peters          = "+proj=cea +lat_ts=45",
    orthographic         = paste0("+proj=ortho +lat_0=", lat0 %||% 20),
    azimuthal_equal_area = paste0("+proj=laea +lat_0=", lat0 %||% 0),
    north_polar          = "+proj=laea +lat_0=90",
    south_polar          = "+proj=laea +lat_0=-90"
  )
  paste0(proj4, " +lon_0=", lon0, " +datum=WGS84 +units=m +no_defs")
}

# Map a Natural Earth scale word to the package code understood by rnaturalearth.
ne_scale <- function(scale = c("small", "medium", "large")) {
  scale <- match.arg(scale)
  switch(scale, small = 110, medium = 50, large = 10)
}

# Region presets: continents, common groups and bounding boxes resolve to a set
# of iso3c codes used to subset geometry. Returns NULL for "world".
resolve_region <- function(region) {
  if (is.null(region)) return(NULL)
  # A bounding box: c(xmin, ymin, xmax, ymax).
  if (is.numeric(region) && length(region) == 4L) {
    return(structure(region, class = "wdj_bbox"))
  }
  region <- as.character(region)
  continents <- c("Africa", "Americas", "Asia", "Europe", "Oceania")
  if (length(region) == 1L && region %in% continents) {
    cl <- countrycode::codelist
    return(cl$iso3c[!is.na(cl$continent) & cl$continent == region])
  }
  # A named group (EU, OECD, ...).
  groups <- unique(country_groups_tbl$group)
  if (length(region) == 1L && region %in% groups) {
    return(country_groups(region)$iso3c)
  }
  # Otherwise treat as a vector of iso3c codes (or names to be standardised).
  if (all(nchar(region) == 3L & toupper(region) == region)) {
    return(toupper(region))
  }
  wdj_to_iso3c(region)
}

# --- Polygon backend (maps / ggplot2::map_data) -------------------------------

# Build map_data("world") as a tibble with iso3c/iso2c attached via overrides.
# Memoised because map_data is deterministic and not free to rebuild.
build_world_polygons <- function() {
  need_pkg("maps", "for the polygon geometry backend")
  md <- ggplot2::map_data("world")
  md <- tibble::as_tibble(md)
  iso3c <- wdj_to_iso3c(md$region, origin = "country.name",
                        custom_match = wdj_overrides())
  md$iso3c <- iso3c
  md$iso2c <- suppressWarnings(
    countrycode::countrycode(iso3c, "iso3c", "iso2c", warn = FALSE)
  )
  md <- apply_code_fallback(md)
  md
}

world_polygons <- memoise::memoise(build_world_polygons)

get_world_polygons <- function(region = NULL) {
  md <- world_polygons()
  iso <- resolve_region(region)
  if (is.null(iso)) return(md)
  if (inherits(iso, "wdj_bbox")) {
    bb <- unclass(iso)
    return(dplyr::filter(md, long >= bb[1], lat >= bb[2],
                         long <= bb[3], lat <= bb[4]))
  }
  dplyr::filter(md, .data$iso3c %in% iso)
}

# --- sf backend (rnaturalearth) -----------------------------------------------

build_world_sf <- function(scale = "small") {
  need_pkg(c("sf", "rnaturalearth", "rnaturalearthdata"),
           "for the sf geometry backend")
  ne <- rnaturalearth::ne_countries(scale = ne_scale(scale), returnclass = "sf")
  # iso_a3 is -99 / NA for France, Norway, Kosovo, ... so fall back to
  # countrycode on admin / sovereignt names. Guarded by a regression test.
  iso3c <- ne$iso_a3
  iso3c[iso3c %in% c("-99", "-099", "")] <- NA
  fallback_name <- ne$admin %||% ne$sovereignt %||% ne$name_long
  needs <- is.na(iso3c)
  if (any(needs)) {
    iso3c[needs] <- wdj_to_iso3c(fallback_name[needs], origin = "country.name",
                                 custom_match = wdj_overrides())
  }
  ne$iso3c <- iso3c
  ne$iso2c <- suppressWarnings(
    countrycode::countrycode(iso3c, "iso3c", "iso2c", warn = FALSE)
  )
  keep <- c("iso3c", "iso2c", "name_long", "geometry")
  keep <- intersect(keep, names(ne))
  ne <- ne[, keep]
  ne <- apply_code_fallback(ne)
  ne
}

# Memoise per-scale.
.world_sf_cache <- new.env(parent = emptyenv())

get_world_sf <- function(scale = "small", region = NULL,
                         projection = "equal_earth", recenter = NULL,
                         project = TRUE) {
  need_pkg("sf", "for the sf geometry backend")
  key <- paste0("scale_", scale)
  if (is.null(.world_sf_cache[[key]])) {
    .world_sf_cache[[key]] <- build_world_sf(scale)
  }
  ne <- .world_sf_cache[[key]]

  iso <- resolve_region(region)
  if (!is.null(iso)) {
    if (inherits(iso, "wdj_bbox")) {
      bb <- unclass(iso)
      bbox <- sf::st_bbox(c(xmin = bb[1], ymin = bb[2], xmax = bb[3], ymax = bb[4]),
                          crs = sf::st_crs(4326))
      ne <- suppressWarnings(sf::st_crop(ne, bbox))
    } else {
      ne <- ne[!is.na(ne$iso3c) & ne$iso3c %in% iso, ]
    }
  }

  # Antimeridian-safe before projecting so Russia/Fiji/NZ stop streaking.
  # (st_break_antimeridian's internal st_intersection notes that attributes are
  # assumed spatially constant -- expected and harmless here, so suppress it.)
  ne <- suppressWarnings(
    tryCatch(sf::st_break_antimeridian(ne, lon_0 = recenter %||% 0),
             error = function(e) ne)
  )
  if (isTRUE(project)) {
    ne <- sf::st_transform(ne, crs = wdj_crs(projection, recenter))
  }
  ne
}

#' Geometry without the data
#'
#' Sometimes you just want the canvas: country polygons, label-ready centroids,
#' coastlines, internal borders, a graticule or an ocean rectangle -- already
#' projected, region-subset and antimeridian-safe. This is the building block
#' the plotting functions sit on, exposed for power users.
#'
#' @param what What to return: `"countries"` (default), `"centroids"`,
#'   `"coastline"`, `"borders"`, `"graticule"` or `"ocean"`.
#' @param geometry `"polygon"` (a tibble of `long`/`lat`/`group`) or `"sf"`.
#' @param scale Natural Earth resolution for the `sf` backend:
#'   `"small"` (110m), `"medium"` (50m) or `"large"` (10m).
#' @param region Optional subset: a continent, a group name, a vector of `iso3c`
#'   codes, or a bounding box `c(xmin, ymin, xmax, ymax)`.
#' @param projection Projection for the `sf` backend (see [world_map()]).
#' @param recenter Optional central meridian for a recentred map (e.g. `150`).
#'
#' @return A tibble (polygon backend) or `sf` object (sf backend).
#' @export
#' @examples
#' \donttest{
#' if (requireNamespace("maps", quietly = TRUE)) {
#'   head(world_geometry("countries", geometry = "polygon"))
#' }
#' }
world_geometry <- function(what = c("countries", "centroids", "coastline",
                                    "borders", "graticule", "ocean"),
                           geometry = c("polygon", "sf"),
                           scale = "small",
                           region = NULL,
                           projection = "equal_earth",
                           recenter = NULL) {
  what <- match.arg(what)
  geometry <- match.arg(geometry)

  if (geometry == "polygon") {
    if (!what %in% c("countries", "centroids")) {
      wdj_abort(c(
        "{.val {what}} is only available with {.code geometry = \"sf\"}.",
        "i" = "The polygon backend supports {.val countries} and {.val centroids}."
      ))
    }
    poly <- get_world_polygons(region)
    if (what == "countries") return(poly)
    return(polygon_centroids(poly))
  }

  # sf backend.
  need_pkg("sf", "for the sf geometry backend")
  countries <- get_world_sf(scale, region, projection, recenter)
  switch(
    what,
    countries = countries,
    centroids = sf_centroids(countries),
    coastline = sf::st_cast(sf::st_union(countries), "MULTILINESTRING"),
    borders   = sf::st_cast(countries, "MULTILINESTRING", warn = FALSE),
    graticule = sf::st_transform(
      sf::st_graticule(),
      crs = wdj_crs(projection, recenter)
    ),
    ocean = {
      box <- sf::st_as_sfc(sf::st_bbox(c(xmin = -180, ymin = -90, xmax = 180, ymax = 90),
                                       crs = sf::st_crs(4326)))
      box <- suppressWarnings(
        tryCatch(sf::st_break_antimeridian(box, lon_0 = recenter %||% 0),
                 error = function(e) box)
      )
      sf::st_transform(box, crs = wdj_crs(projection, recenter))
    }
  )
}

# Spherical polygon area (km^2) of one lon/lat ring. Used to pick a country's
# largest piece so the centroid is stable and antimeridian-safe (a bounding-box
# midpoint over *all* pieces lands the US/Fiji/NZ label in the wrong ocean).
ring_area_km2 <- function(lon, lat) {
  ok <- is.finite(lon) & is.finite(lat)
  lon <- lon[ok]; lat <- lat[ok]
  n <- length(lon)
  if (n < 3L) return(0)
  R <- 6371.0088; d2r <- pi / 180
  lon <- lon * d2r; lat <- lat * d2r
  i <- seq_len(n); j <- c(2:n, 1L)
  abs(sum((lon[j] - lon[i]) * (2 + sin(lat[i]) + sin(lat[j]))) * R^2 / 2)
}

# One centroid per iso3c from polygon rows: the bounding-box midpoint of the
# country's *largest* piece. One row per country (overrides map several map_data
# names -- Azores/Madeira -> PRT -- to one iso3c, so grouping must collapse them,
# or downstream joins in bubble_map()/flow_map() fan out).
polygon_centroids <- function(poly) {
  poly %>%
    dplyr::filter(!is.na(.data$iso3c)) %>%
    dplyr::group_by(.data$iso3c, .data$group) %>%
    dplyr::summarise(
      g_lon = mean(range(.data$long, na.rm = TRUE)),
      g_lat = mean(range(.data$lat, na.rm = TRUE)),
      g_area = ring_area_km2(.data$long, .data$lat),
      .groups = "drop_last"
    ) %>%
    dplyr::summarise(
      centroid_lon = .data$g_lon[which.max(.data$g_area)],
      centroid_lat = .data$g_lat[which.max(.data$g_area)],
      .groups = "drop"
    )
}

# Label-safe centroids for the sf backend: st_point_on_surface keeps the point
# *inside* the country.
sf_centroids <- function(x) {
  need_pkg("sf", "for centroid computation")
  pts <- suppressWarnings(sf::st_point_on_surface(sf::st_geometry(x)))
  coords <- sf::st_coordinates(pts)
  out <- sf::st_drop_geometry(x)
  out$centroid_lon <- coords[, 1]
  out$centroid_lat <- coords[, 2]
  out$geometry <- pts
  sf::st_as_sf(out)
}

#' Attach geometry to a country-level table
#'
#' The bridge between a one-row-per-country table (e.g. from [country_data()])
#' and plotting: bolts polygon or `sf` geometry onto your data, keyed on
#' `iso3c`.
#'
#' @param data A data frame with an `iso3c` (or `by`) column.
#' @param by The join key (default `"iso3c"`).
#' @param geometry `"polygon"` (default) or `"sf"`.
#' @param scale Natural Earth resolution for the `sf` backend.
#' @param region Optional region subset (see [world_geometry()]).
#' @param projection,recenter Projection options for the `sf` backend.
#'
#' @return For `"polygon"`, a tibble with `long`/`lat`/`group` plus your
#'   columns. For `"sf"`, an `sf` object.
#' @export
#' @examples
#' \donttest{
#' df <- data.frame(iso3c = c("USA", "CAN"), value = c(1, 2))
#' if (requireNamespace("maps", quietly = TRUE)) {
#'   attach_geometry(df, geometry = "polygon")
#' }
#' }
attach_geometry <- function(data,
                            by = "iso3c",
                            geometry = c("polygon", "sf"),
                            scale = "small",
                            region = NULL,
                            projection = "equal_earth",
                            recenter = NULL) {
  geometry <- match.arg(geometry)
  if (!by %in% names(data)) {
    wdj_abort("{.arg data} must contain the join column {.val {by}}.")
  }
  data <- tibble::as_tibble(data)

  if (geometry == "polygon") {
    poly <- get_world_polygons(region)
    # geometry on the left preserves all polygon rows; values fill in.
    drop <- setdiff(intersect(names(poly), names(data)), by)
    poly <- poly[, setdiff(names(poly), drop), drop = FALSE]
    out <- dplyr::left_join(poly, data, by = by)
    return(out)
  }

  geom <- get_world_sf(scale, region, projection, recenter)
  drop <- setdiff(intersect(names(geom), names(data)), by)
  geom <- geom[, setdiff(names(geom), drop), drop = FALSE]
  dplyr::left_join(geom, data, by = by)
}

#' Tag coordinates with the country that contains them
#'
#' Point-in-polygon lookup: given longitude / latitude vectors (or an `sf` POINT
#' object), return the `iso3c` of the country each point falls in -- the bridge
#' for getting point data (events, stations, observations) onto the country
#' spine so it can be joined, aggregated and mapped like everything else.
#'
#' @param lon,lat Numeric vectors of longitude / latitude (recycled together;
#'   ignored if `points` is supplied).
#' @param points Optional `sf` POINT object to use instead of `lon`/`lat`.
#' @param scale Natural Earth resolution for the lookup geometry.
#' @param add Extra attributes to return alongside `iso3c` (any
#'   [convert_country()] destination, e.g. `"country"`, `"continent"`).
#'
#' @return A tibble with one row per point: `iso3c` plus any `add` columns
#'   (`NA` for points that fall in no country, e.g. open ocean).
#' @export
#' @examples
#' \dontrun{
#' locate_country(lon = c(2.35, -74.0), lat = c(48.85, 40.7))  # Paris, NYC
#' }
locate_country <- function(lon = NULL, lat = NULL, points = NULL,
                           scale = "small", add = "country") {
  need_pkg("sf", "for locate_country()")
  geom <- get_world_sf(scale = scale, project = FALSE)        # lon/lat (EPSG:4326)
  if (is.null(points)) {
    if (is.null(lon) || is.null(lat) || length(lon) != length(lat)) {
      wdj_abort("Supply equal-length {.arg lon} and {.arg lat}, or an {.arg points} sf object.")
    }
    points <- sf::st_as_sf(data.frame(lon = lon, lat = lat),
                           coords = c("lon", "lat"), crs = 4326)
  } else {
    points <- sf::st_transform(points, 4326)
  }
  hit <- suppressMessages(sf::st_intersects(points, geom))
  idx <- vapply(hit, function(h) if (length(h)) h[[1]] else NA_integer_, integer(1))
  iso3c <- geom$iso3c[idx]
  out <- tibble::tibble(iso3c = iso3c)
  for (a in setdiff(add, "iso3c")) {
    out[[a]] <- convert_country(iso3c, to = a, from = "iso3c", warn = FALSE)
  }
  out
}
