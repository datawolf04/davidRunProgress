####################################################################
##
## ccDataIO.R
## 
## A collection of functions for loading the current dataset, calculating 
## important quantities, and visualizing the result.
##
####################################################################

library(tidyverse)
library(janitor)
library(readODS)
library(scales)
library(paletteer)

getCCSeasonData = function(year,init){
  colTypes = c('Dccfcdddc')
  odsFile = str_glue('crossCountry{init}.ods')
  seasonDat = read_ods(odsFile, sheet=as.character(year),
                       col_types = colTypes)
  seasonDat = seasonDat |> clean_names() |>
    mutate(
      result = lubridate::ms(result),
      year = year(date)
    )
  return(seasonDat)
}

calcKmPace = function(dat){
  distance = as.numeric(as.character(dat$distance_km))
  time = period_to_seconds(dat$result)
  pace = time/distance
  return(pace)
}

calcMilePace = function(dat){
  pace = 1.6*calcKmPace(dat)
  return(pace)
}

project5kTimes = function(year,init){
  seasonDat = getCCSeasonData(year,init)
  projectedDat = seasonDat |>
    mutate(
      kmPace = calcKmPace(seasonDat),
      miPace = calcMilePace(seasonDat),
      result = ifelse(as.numeric(distance_km)==5, result, kmPace*5),
      projection = distance_km != 5
    ) 
  return(projectedDat)
}

project3kTimes = function(year,init){
  seasonDat = getCCSeasonData(year,init)
  projectedDat = seasonDat |>
    mutate(
      kmPace = calcKmPace(seasonDat),
      miPace = calcMilePace(seasonDat),
      result = ifelse(as.numeric(distance_km)==3, result, kmPace*3),
      projection = distance_km != 3
    ) 
  return(projectedDat)
}

