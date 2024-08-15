####################################################################
##
## ccPlotting.R
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
library(reshape2)

source('ccDataIO.R')

transform_ms = function(){
  new_transform("ms", 
                transform = function(x) {
                  structure(as.numeric(x), names = names(x))}, 
                inverse = lubridate::ms, 
                breaks = breaks_hms())
}


makeCCTimePlot = function(dat,runner,as.of=Sys.Date()){
  name = ifelse(runner=="DJW","David",
                ifelse(runner=="WFW","William",NULL))
  
  pltTitle = paste(name,"'s CC results",sep='')
  capTxt = paste('Updated:',format(as.of, format='%B %d, %Y'))
  
  # dat = dat |> melt() 
  
  #plt = 
  ggplot(dat, aes(x=dayMonth,y=value,color=as.factor(year))) + 
    geom_line(aes(x=dayMonth,y=value,color=as.factor(year))) + 
    theme_minimal() + xlab('Date') + ylab('Time') +
    facet_grid(rows = vars(variable)) +
    geom_point(aes(shape=distance_km,size=2)) + guides(size='none') +
    scale_y_time( #limits = lubridate::ms(c('20:00','30:00')),
      labels = \(x) format(as_datetime(x, tz = "UTC"), "%M:%S")) +
    scale_color_paletteer_d("tvthemes::Aquamarine") +
    labs(color="Year", 
         shape="Race distance",
         title=pltTitle,
         caption = capTxt
         ) + scale_shape(labels=c("5k","3k"))
  return(plt)
}

#######################################################################
## Loading and plotting data
freshDJW = project5kTimes(2024,"DJW")

# |>
#   mutate(
#     dayMonth = as_date(paste(2024,strftime(date,format="%m-%d"),sep='-'))
#   )

## Need to mutate the year so that years overlap on the plot.

sixthWFW = project3kTimes(2024,"WFW")  |>
  mutate(
    dayMonth = as_date(paste(2024,strftime(date,format="%m-%d"),sep='-'))
  )

runner="DJW"
dat = freshDJW
as.of = Sys.Date()

djwCCPlot = makeCCTimePlot(freshDJW,"DJW")
ggsave('davidCCPlot.png',djwCCPlot)

wfwCCPlot = makeCCTimePlot(sixthWFW,"WFW")
ggsave('williamCCplot.png',wfwCCPlot)