source('ccScoring.R')
library(tidyverse)

gaResults = read.csv('grtAmerRed.csv')
gaVarsity = filterVarsity(gaResults)
teamRes = scoreMeet(gaVarsity) |>
  mutate(Score = as.numeric(Score)) |>
  arrange(Score)
teamRes

write_csv(teamRes,'grtAmerRedTeamResults.csv')
