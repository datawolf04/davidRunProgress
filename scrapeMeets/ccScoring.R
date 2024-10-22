##################################################################
##
## ccScoring.R
##
## This takes a roster of teams and places and has functions to filter the 
## results and score the meet.
##################################################################

makeFakeResults = function(seed=123){
  racerunners = c(rep("A",25), rep("B",25), rep("C",7))
  set.seed(seed = seed)
  raceorder = sample(racerunners)
  place = 1:length(racerunners)
  rTime = numeric(length(racerunners))
  Name = paste("Athlete Name",place,"Team",raceorder)
  raceresults = data.frame("Place"=place,"Time"=rTime,"Team"=raceorder,Name)
  return(raceresults)
}
# fakeResults = makeFakeResults()
# write.csv(fakeResults,file="testScoreSheet.csv")

filterVarsity = function(results){
  teamList = sort(unique(results$Team))
  varsityOnly = results
  for (t in teamList){
    teamCount = sum(varsityOnly$Team==t)
    keep = rep(TRUE,nrow(varsityOnly))
    if(teamCount>7){
      varsity=c(rep(TRUE,7),rep(FALSE,teamCount-7))
      keep[varsityOnly$Team==t] = varsity
      varsityOnly = varsityOnly[keep, ]
    } else if(teamCount<5){
      keep[varsityOnly$Team==t] = rep(FALSE,teamCount)
      varsityOnly = varsityOnly[keep, ]
    }
  }
  vPlace = 1:nrow(varsityOnly)
  origPlace = varsityOnly$Place
  teamName = varsityOnly$Team
  athlete = varsityOnly$Name
  varsityResult = data.frame(origPlace,"Place"=vPlace,teamName,athlete)
  names(varsityResult)[1] = "Original Place"
  return(varsityResult)
}

filterTeam = function(results,teamName){
  teamOnly = results[results$Team==teamName, ]
  return(teamOnly)
}

scoreMeet = function(results){
  places = results$Place
  teams = sort(unique(results$teamName))
  scores = numeric(length(teams))
  for(t in teams){
    tPlace = places[results$teamName==t]
    print(paste(t,"places:"))
    print(tPlace)
    tScore="No Score"
    if(length(tScore>4.5)){
      tScore = sum(tPlace[1:5])
    }
    print(paste(t,"team score:", tScore))
    cat('\n\n')
    scores[teams==t] = tScore
  }
  scores = as.character(scores)
  scores[is.na(scores)] = "DNS"
  teamResults = data.frame("Team.Name"=teams,"Score"=scores)
  return(teamResults)
}

# results = read.csv('testScoreSheet.csv')
# varsityResults = filterVarsity(results)
# scoreMeet(varsityResults)
# filterTeam(results,"B")
