---
title: "Vignette Title"
author: "Vignette Author"
date: "2016-01-26"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



## What is leaflet?

*Leaflet is the leading open-source JavaScript library for mobile-friendly interactive maps*


- "*Leaflet is designed with simplicity, performance and usability in mind*" (easier than *Google Maps* and *OpenLayer* APIs)
- an API, not a map provider
- active community, numerous [extensions](http://leafletjs.com/plugins.html)

http://leafletjs.com/

## R HtmlWidgets

**htmlwidget** brings *the best of JavaScript data visualization* to R.

**leaflet** is one of these widgets.

Other examples:

   - [dygraph](http://www.htmlwidgets.org/showcase_dygraphs.html): to plot
   and browse time series
   - [DataTables = DT](http://www.htmlwidgets.org/showcase_datatables.html): to
   print interactive html tables

<br>
<http://www.htmlwidgets.org>

# Leaflet package

## Installation


To install this R package, run this command at your R prompt:


```r
devtools::install_github("rstudio/leaflet")
```


# Dataset

## Airports...

We'll play with Flights data made available by [OpenFlights](http://openflights.org/).

<http://datahub.io/dataset/open-flights>

First the list of all airports...


```r
  con <- curl::curl("https://raw.githubusercontent.com/jpatokal/openflights/master/data/airports.dat")

  airports <- read.csv(con, header = F, col.names = c("id", "name", "city"
     , "country", "FAA", "ICAO", "lat", "lng", "altitude", "timezone", "letter", "DST")
     , stringsAsFactors = F)
```


## ...then the routes


```r
  con <- curl::curl("https://raw.githubusercontent.com/jpatokal/openflights/master/data/routes.dat")

  routes <- read.csv(con, header = F, col.names = c("airline", "airline_id", "source"
    , "source_id", "destination", "destination_id", "codeshare", "stops", "equipment")
    , stringsAsFactors = F)

  routes$source_id <- as.integer(routes$source_id)
  routes$destination_id <- as.integer(routes$destination_id)
```

## 1% airports with more routes


```r
library(dplyr)
```

```
## Error in library(dplyr): there is no package called 'dplyr'
```

```r
top01 <- routes %>%
  group_by(source_id) %>%
  summarise(nb_routes = n()) %>%
  filter(percent_rank(nb_routes) >= 0.99)
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```

```r
top01 <- left_join(top01, airports, by=c("source_id" = "id"))
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "left_join"
```

## Library

We load the library.


```r
library(leaflet)
```

```
## Error in library(leaflet): there is no package called 'leaflet'
```


## First map


```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```


## Base maps

There is a [wide selection of *base maps* available](http://leaflet-extras.github.io/leaflet-providers/preview/index.html):
  

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```




## Base maps

By default the `OpenStreetMap` data is used:
  

```r
leaflet(data = top01) %>%
  addTiles() %>%
  addMarkers(
    clusterOptions = markerClusterOptions()
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```


## Markers

You can add pop-up to markers


```r
leaflet(data = top01) %>%
  addTiles() %>% 
  addMarkers(
    clusterOptions = markerClusterOptions()
    , popup = ~name
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```

## Markers

HTML is interpreted


```r
## Markers
leaflet(data = top01) %>%
  setView(lng = -80, lat = 40, zoom = 4) %>% 
  addTiles() %>% 
  addMarkers(popup = ~paste0("<b>", name, " (", FAA, ")</b>"
                             ,"<br>Nb route: ", nb_routes)
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```



## Circle markers

Size in pixel


```r
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```

## Circles

Size in meter


```r
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircles(popup = ~name
             , radius = ~nb_routes*200
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```

## Circle markers

Size in pixel


```r
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```


## Colors

Special method for building factorial and continuous palettes.


```r
pal <- colorNumeric("RdYlBu", top01$nb_routes)
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "colorNumeric"
```

```r
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
                   , color = ~pal(nb_routes)
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```


## Colors

Special method for building factorial and continuous palettes.


```r
pal <- colorBin("RdYlBu", -log(top01$nb_routes), bins = 20, pretty = F)
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "colorBin"
```

```r
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
                   , color = ~pal(-log(nb_routes))
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```


## Colors

Special method for building factorial and continuous palettes.


```r
pal <- colorFactor("RdYlBu", top01$DST)
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "colorFactor"
```

```r
leaflet(data = top01) %>%
  addTiles() %>% 
  setView(lng = 2, lat = 45, zoom = 4) %>% 
  addCircleMarkers(popup = ~name
                   , radius = ~nb_routes/30
                   , color = ~pal(DST)
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```


## Lines and shapes


```r
trip <- data.frame(FAA = c("BCN", "LIS", "LPA", "DKR", "JNB", "EZE", "LIM"
                           , "RDU", "SAN", "HNL", "HND", "LJG","HYD", "VCE", "BCN"))

trip <- left_join(trip, airports, by="FAA")
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "left_join"
```

```r
leaflet(data = trip) %>%
  addTiles() %>% 
  addMarkers(popup = ~FAA) %>% 
  addPolylines(data=as.matrix(trip %>% select(lng, lat)))
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```

## Shape files

We get "[Mapa de Cobertes](http://www.creaf.uab.es/mcsc/poligons4.htm)" from **uab.es**. Transform it...


```r
Cob <- rgdal::readOGR(system.file("39322/", package="leaflettutoRial"),
                      layer = "39322", verbose = FALSE)
```

```
## Error in loadNamespace(name): there is no package called 'rgdal'
```

```r
Cob <- sp::spTransform(Cob, sp::CRS("+proj=longlat +datum=WGS84"))
```

```
## Error in loadNamespace(name): there is no package called 'sp'
```

```r
CascAntic <- subset(Cob, C_COMPOSTA == "ucc")
```

```
## Error in subset(Cob, C_COMPOSTA == "ucc"): objeto 'Cob' no encontrado
```

...and plot it:


```r
leaflet(CascAntic) %>%
  addTiles() %>% 
  addPolygons(
    stroke = FALSE, fillOpacity = 0.5, smoothFactor = 0.5
  )
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```

## JSON

Get *district* form Barcelona...


```r
con <- curl::curl("https://cdn.rawgit.com/martgnz/bcn-geodata/master/barris/barris_geo.json")
geoData <- readLines(con) %>% paste(collapse = "\n")
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```

...and map them:

```r
leaflet() %>% setView(lng = 2.17, lat = 41.37, zoom = 11) %>%
  addTiles() %>%
  addGeoJSON(geoData, weight = 3, color = "red", fill = FALSE, opacity = 0.5)
```

```
## Error in eval(expr, envir, enclos): no se pudo encontrar la función "%>%"
```



