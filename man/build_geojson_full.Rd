% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/internal.R
\name{build_geojson_full}
\alias{build_geojson_full}
\title{Build a full GeoJSON FeatureCollection}
\usage{
build_geojson_full(features)
}
\arguments{
\item{features}{A \code{character} vector with the \code{GeoJSON} features.}
}
\value{
A \code{character} vector of length 1 with the full GeoJSON FeatureCollection that can be read with \link[sf]{st_read}/\link[sf]{read_sf}.
}
\description{
Build a full GeoJSON FeatureCollection
}
\keyword{internal}
