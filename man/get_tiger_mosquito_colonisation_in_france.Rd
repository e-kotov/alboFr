% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_tiger_mosquito_colonisation_in_france.R
\name{get_tiger_mosquito_colonisation_in_france}
\alias{get_tiger_mosquito_colonisation_in_france}
\title{Get latest tiger mosquito colonisation data in France from the online map}
\usage{
get_tiger_mosquito_colonisation_in_france(output = c("sf", "geojson"))
}
\arguments{
\item{output}{The output format. Can be either \code{"sf"} or \code{"geojson"}.}
}
\value{
If \code{output = "sf"}, an \code{sf} object with the tiger mosquito colonisation data in France. All polygons that exist on the map are covering the territories where the tiger mosquito (Aedes Albopictus) has alreadt been detected in France.
If \code{output = "geojson"}, a \code{GeoJSON} in a \code{character} vector with the tiger mosquito colonisation data in France. Using the 'geojson' option allows to use the package without the \code{sf} package. You can therefore just save the resulting string to a text file. See examples.
}
\description{
Get latest tiger mosquito colonisation data in France from the online map at \url{https://signalement-moustique.anses.fr/signalement_albopictus/colonisees}.
}
\examples{
\donttest{
# get the latest data in `sf`
x <- get_tiger_mosquito_colonisation_in_france(output = "sf")

# save the data to GeoPackage file with `sf`
if(interactive()) {
library(sf)
st_write(x, "tiger_mosquito_colonisation_in_france.gpkg")
}
}

# get the latest data in `geojson`
x <- get_tiger_mosquito_colonisation_in_france(output = "geojson")

# save the data to text file
if(interactive()) {
writeLines(x, "tiger_mosquito_colonisation_in_france.geojson")
}

}
