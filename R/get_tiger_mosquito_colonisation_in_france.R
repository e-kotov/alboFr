#' Get latest tiger mosquito colonisation data in France from the online map
#'
#' @description
#' Get latest tiger mosquito colonisation data in France from the online map at [https://signalement-moustique.anses.fr/signalement_albopictus/colonisees](https://signalement-moustique.anses.fr/signalement_albopictus/colonisees).
#'
#' @return
#' An `sf` object with the tiger mosquito colonisation data in France. All polygons that exist on the map are covering the territories where the tiger mosquito (Aedes Albopictus) has alreadt been detected in France.
#'
#' @export
#'
#' @examples
#' \donttest{
#' # get the latest data
#' x <- get_tiger_mosquito_colonisation_in_france()
#'
#' # save the data to GeoPackage file with `sf`
#' library(sf)
#' if(interactive()) {
#' st_write(x, "tiger_mosquito_colonisation_in_france.gpkg")
#' }
#' }
#'
get_tiger_mosquito_colonisation_in_france <- function() {
  # set the URL page with source data
  x_url <- "https://signalement-moustique.anses.fr/signalement_albopictus/colonisees"

  # read the page source code
  x_page <- readLines(x_url)
  # isolate the line with the JSON data
  sp_data_line <- x_page[grep("var result_commune =", x_page)]

  # clean the variable name
  sp_data_json <- gsub(" *var result_commune =  ", "", sp_data_line)
  # parse as JSON
  sp_data_list <- RcppSimdJson::fparse(sp_data_json)

  # convert to a list of geometries
  coords_strings <- sp_data_list |> purrr::map_chr(~ .x[["coordonnees"]])
  # identify corrupt items
  corrupt_items <- which(coords_strings == "[]")
  # keep only valid items
  items_with_geometry <- sp_data_list[-corrupt_items]

  # convert all geometries to native R sf objects
  features_list <- items_with_geometry |>
    purrr::map(~ js_coords_to_geojson(.x), .progress = TRUE)

  geojson_full <- build_geojson_full(features_list)

  combined_sf_data <- sf::st_read(geojson_full, quiet = TRUE)

  return(combined_sf_data)
}
