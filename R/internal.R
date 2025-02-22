#' Convert JavaScript encoded coordinates to `GeoJSON` comliant string
#' @keywords internal
#' @param item A `list` with the item data.
#' @return An `sf` spatial object.
#'
js_coords_to_geojson <- function(item) {
  # Extract and fix the coordinates
  coords_string <- item[["coordonnees"]]
  cleaned_coords <- fix_brackets_iterative(coords_string)

  # Build a GeoJSON feature that includes the geometry and properties
  feature <- build_geojson_feature(cleaned_coords, item)
  return(feature)
}

#' Build a single GeoJSON feature
#'
#' @description
#' This function creates a feature with the fixed coordinates and includes
#' the "toujours_signaler" field from the item as a property.
#'
#' @return A GeoJSON feature in a `character` vector of length 1.
#' @keywords internal
#' @param cleaned_coords A `character` vector of length 1 with the fixed coordinates.
#' @param item A `list` with the item data.
#'
build_geojson_feature <- function(
  cleaned_coords,
  item
) {
  # Get the property
  prop_value <- item[["toujours_signaler"]]
  # If prop_value is logical, convert to JSON lower-case boolean.
  if (is.logical(prop_value)) {
    prop_value <- tolower(as.character(prop_value))
  }
  # Manually build the JSON properties string.
  properties <- paste0('{"toujours_signaler":', prop_value, '}')

  # Build the feature string with the fixed geometry and properties.
  feature <- paste0(
    '{"type":"Feature","properties":',
    properties,
    ',"geometry":{"type":"Polygon","coordinates":',
    cleaned_coords,
    '}}'
  )
  return(feature)
}

#' Build a full GeoJSON FeatureCollection
#' @keywords internal
#' @param features A `character` vector with the `GeoJSON` features.
#' @keywords internal
#' @return A `character` vector of length 1 with the full GeoJSON FeatureCollection that can be read with \link[sf]{st_read}/\link[sf]{read_sf}.
#'
build_geojson_full <- function(features) {
  features_combined <- paste(features, collapse = ",")
  geojson_full <- paste0(
    '{"type":"FeatureCollection","features":[',
    features_combined,
    ']}'
  )
  return(geojson_full)
}

#' Function to adjust the bracket levels of the string
#' @param s a `character` vector of length 1 with the coordinates string to be fixed.
#' @return a `character` vector of length 1 with the fixed coordinates string.
#' @keywords internal
#'
fix_brackets_iterative <- function(s) {
  repeat {
    # 1. Count the consecutive opening and closing brackets at the very beginning and end.
    leading <- regmatches(s, regexpr("^\\[+", s))
    trailing <- regmatches(s, regexpr("\\]+$", s))

    n_leading <- ifelse(length(leading) == 0, 0, nchar(leading))
    n_trailing <- ifelse(length(trailing) == 0, 0, nchar(trailing))

    # 2. If both sides have more than 3 brackets, remove one bracket from each end
    if (n_leading > 3 && n_trailing > 3) {
      s <- sub("^\\[", "", s) # remove one opening bracket at start
      s <- sub("\\]$", "", s) # remove one closing bracket at end

      # 3. Adjust inner occurrences (reduce groups of 3 brackets to 2)
      s <- gsub("\\[\\[\\[", "[[", s)
      s <- gsub("\\]\\]\\]", "]]", s)
    } else {
      break
    }
  }

  # 4. Ensure the string is wrapped by exactly 3 brackets on each side.
  leading <- regmatches(s, regexpr("^\\[+", s))
  trailing <- regmatches(s, regexpr("\\]+$", s))
  n_leading <- ifelse(length(leading) == 0, 0, nchar(leading))
  n_trailing <- ifelse(length(trailing) == 0, 0, nchar(trailing))

  while (n_leading < 3) {
    s <- paste0("[", s)
    n_leading <- n_leading + 1
  }
  while (n_trailing < 3) {
    s <- paste0(s, "]")
    n_trailing <- n_trailing + 1
  }

  return(s)
}
