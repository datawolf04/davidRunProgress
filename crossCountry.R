####################################################################
##
## crossCountry.R
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

getCCSeasonData = function(year){
  colTypes = c('Dccdcdddc')
  
  seasonDat = read_ods('crossCountry.ods', sheet=as.character(year),
                       col_types = colTypes)
  seasonDat = seasonDat |> clean_names() |>
    mutate(
      result = lubridate::hms(result),
      year = year(date),
      dayMonth = format(date, "%D-%M")
    )
  return(seasonDat)
}

calcKmPace = function(dat){
  distance = dat$distance_km
  time = period_to_seconds(dat$result)
  pace = time/distance
  return(pace)
}

calcMilePace = function(dat){
  pace = 1.6*calcKmPace(dat)
  return(pace)
}

project5kTimes = function(year){
  seasonDat = getCCSeasonData(year)
  projectedDat = seasonDat |>
    mutate(
      kmPace = calcKmPace(seasonDat),
      miPace = calcMilePace(seasonDat),
      result = seconds_to_period(ifelse(distance_km==5,
                                        period_to_seconds(result),
                                        kmPace*5)),
      projection = distance_km != 5
    ) 
  return(projectedDat)
}

transform_ms = function () {
  new_transform("ms", 
                transform = function(x) {
                  structure(as.numeric(x), names = names(x))}, 
                inverse = lubridate::ms, 
                breaks = breaks_hms())
}

fresh = project5kTimes(2024)
soph = project5kTimes(2025)
jr = project5kTimes(2026)
sr = project5kTimes(2027)
tst = rbind(fresh,soph,jr,sr)
tst = tst |>
  mutate(
    dayMonth = as_date(paste(2024,strftime(date,format="%m-%d"),sep='-'))
  )
  
ggplot(tst, aes(x=dayMonth,y=result,color=as.factor(year))) + 
  geom_line() + theme_minimal() + xlab('Date') + ylab('5k Time') +
  geom_point(aes(shape=projection,size=2)) +
  guides(size=FALSE) +
  scale_y_time(labels = \(x) format(as_datetime(x, tz = "UTC"), "%M:%S")) +
  scale_color_paletteer_d("tvthemes::Aquamarine") +
  labs(color="Year", shape="Run distance") + scale_shape(labels=c("5k","3k"))
