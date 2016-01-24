## ---- eval=FALSE---------------------------------------------------------
## devtools::install_github("rstudio/leaflet")

## ----getAirports, echo=TRUE, cache=TRUE----------------------------------
  con <- curl::curl("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat")

  airports <- read.csv(con, header = F, col.names = c("id", "name", "city"
     , "country", "FAA", "ICAO", "lat", "lng", "altitude", "timezone", "letter", "DST")
     , stringsAsFactors = F)


## ----getRoutes, echo=TRUE, warning=FALSE, cache=TRUE---------------------
  con <- curl::curl("https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat")

  routes <- read.csv(con, header = F, col.names = c("airline", "airline_id", "source"
    , "source_id", "destination", "destination_id", "codeshare", "stops", "equipment")
    , stringsAsFactors = F)

  routes$source_id <- as.integer(routes$source_id)
  routes$destination_id <- as.integer(routes$destination_id)


## ----top01, echo=TRUE, message=F-----------------------------------------
library(dplyr)

top01 <- routes %>%
  group_by(source_id) %>%
  summarise(nb_routes = n()) %>%
  filter(percent_rank(nb_routes) >= 0.99)

top01 <- left_join(top01, airports, by=c("source_id" = "id"))

## ----load, echo=TRUE-----------------------------------------------------
library(leaflet)

## ----map00, echo=FALSE, fig.height=6, message=FALSE----------------------
leaflet(data = top01) %>% addMarkers(lat= ~lat, lng=~lng)

## ----map01, echo=FALSE, message=FALSE------------------------------------
leaflet(data = top01) %>%
  addProviderTiles("Thunderforest.TransportDark") %>%
  addMarkers(
    clusterOptions = markerClusterOptions()
  )

## ----map02, message=FALSE------------------------------------------------
leaflet(data = top01) %>%
  addTiles() %>%
  addMarkers(
    clusterOptions = markerClusterOptions()
  )

## ----map03, message=FALSE------------------------------------------------
leaflet(data = top01) %>%
  addTiles() %>% 
  addMarkers(
    clusterOptions = markerClusterOptions()
    , popup = ~name
  )

## ----map04, message=FALSE------------------------------------------------

## Markers
leaflet(data = top01) %>%
  setView(lng = -80, lat = 40, zoom = 4) %>% 
  addTiles() %>% 
  addMarkers(popup = ~paste0("<b>", name, " (", FAA, ")</b>"
                             ,"<br>Nb route: ", nb_routes)
  )

## ----map05, message=FALSE------------------------------------------------
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
  )

## ----map06, message=FALSE------------------------------------------------
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircles(popup = ~name
             , radius = ~nb_routes*200
  )

## ----map07, message=FALSE------------------------------------------------
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
  )

## ----map08, message=FALSE------------------------------------------------

pal <- colorNumeric("RdYlBu", top01$nb_routes)

leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
                   , color = ~pal(nb_routes)
  )

## ----map09, message=FALSE------------------------------------------------

pal <- colorBin("RdYlBu", -log(top01$nb_routes), bins = 20, pretty = F)

leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
                   , color = ~pal(-log(nb_routes))
  )

## ----map10, message=FALSE------------------------------------------------

pal <- colorFactor("RdYlBu", top01$DST)

leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
                   , color = ~pal(DST)
  )

## ----map11, message=FALSE, warning=FALSE---------------------------------

trip <- data.frame(FAA = c("BCN", "LIS", "LPA", "DKR", "JNB", "EZE", "LIM"
                           , "RDU", "SAN", "HNL", "HND", "LJG","HYD", "VCE", "BCN"))

trip <- left_join(trip, airports, by="FAA")

leaflet(data = trip) %>%
  addTiles() %>% 
  addMarkers(popup = ~FAA) %>% 
  addPolylines(data=as.matrix(trip %>% select(lng, lat)))


## ----GetShape, message=F-------------------------------------------------
Cob <- rgdal::readOGR(system.file("39322/", package="leaflettutoRial"),
                      layer = "39322", verbose = FALSE)
Cob <- sp::spTransform(Cob, sp::CRS("+proj=longlat +datum=WGS84"))

CascAntic <- subset(Cob, C_COMPOSTA == "ucc")

## ----map12, message=FALSE------------------------------------------------
leaflet(CascAntic) %>%
  addTiles() %>% 
  addPolygons(
    stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5
  )

## ----getDistricts--------------------------------------------------------
con <- curl::curl("https://cdn.rawgit.com/martgnz/bcn-geodata/master/barris/barris_geo.json")
geoData <- readLines(con) %>% paste(collapse = "\n")

## ----map13---------------------------------------------------------------
leaflet() %>% setView(lng = 2.17, lat = 41.37, zoom = 11) %>%
  addTiles() %>%
  addGeoJSON(geoData, weight = 3, color = "red", fill = FALSE, opacity = 0.5)

