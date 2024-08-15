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
library(ggthemes)

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
  
  dat = dat |> pivot_longer(
    cols = c(result, kmPace, miPace),
    names_to = 'timeType', values_to = 'times'
  ) |> 
  mutate(
    dayMonth = as_date(paste(2024,strftime(date,format="%m-%d"),sep='-'))
  ) |> mutate(
    timeType = factor(timeType, levels=c('result','miPace','kmPace'),
                      labels=c("Race result","Mile Pace","km pace"))
  )
  
  plt = ggplot(dat, aes(x=dayMonth,y=times,color=as.factor(year))) + 
    geom_line(aes(x=dayMonth,y=times,color=as.factor(year))) + 
    theme_solarized() + 
    xlab('Date') + ylab('Time') + 
    geom_point(aes(shape=distance_km,size=2)) + guides(size='none') +
    scale_y_time( #limits = lubridate::ms(c('20:00','30:00')),
      labels = \(x) format(as_datetime(x, tz = "UTC"), "%M:%S")) +
    scale_color_paletteer_d("tvthemes::Aquamarine") +
    facet_grid(rows = vars(timeType), scale='free', switch = 'y') +
    theme(strip.placement = "outside",
          plot.title.position = 'plot',
          plot.caption.position = 'plot') +
    labs(color="Year", 
         shape="Race distance",
         title=pltTitle,
         caption = capTxt
         ) + scale_shape(labels=paste(levels(dat$distance_km),"K",sep=''))
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

sixthWFW = project3kTimes(2024,"WFW") 


djwCCPlot = makeCCTimePlot(freshDJW,"DJW")
ggsave('davidCCPlot.png',djwCCPlot)

wfwCCPlot = makeCCTimePlot(sixthWFW,"WFW")
ggsave('williamCCplot.png',wfwCCPlot)