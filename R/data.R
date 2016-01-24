#' get Airports data from OpenFlights
#'
#' @return
#' @export
#'
#' @examples
saveAirports <- function() {

  con <- curl::curl("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat")

  airports <- read.csv(con, header = F, col.names = c("id", "name", "city"
     , "country", "FAA", "ICAO", "lat", "lng", "altitude", "timezone", "letter", "DST")
     , stringsAsFactors = F)

  save(airports, file = "inst/extdata/airports.Rdata")
}

#' get Routes data from OpenFlights
#'
#' @return
#' @export
#'
#' @examples
saveRoutes <- function() {

  con <- curl::curl("https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat")

  routes <- read.csv(con, header = F, col.names = c("airline", "airline_id", "source"
    , "source_id", "destination", "destination_id", "codeshare", "stops", "equipment")
    , stringsAsFactors = F)

  routes$source_id <- as.integer(routes$source_id)
  routes$destination_id <- as.integer(routes$destination_id)

  save(routes, file="inst/extdata/routes.Rdata")
}
