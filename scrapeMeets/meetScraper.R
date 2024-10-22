library(tidyverse)
library(rvest)

newBernMeetUrl = "https://nc.milesplit.com/meets/636731-bcc-xc-all-teams-new-bern-9112024-2024/results"
nbMeetRes = read_html(newBernMeetUrl)
nbMeet = nbMeetRes |> html_element("body") |> html_element('main') |> 
  html_element('.content') |> html_elements('pre') |> html_text2()

write_file(nbMeet,'~/Documents/runTracker/scrapeMeets/nbMeetRes.txt')

boRunChampUrl = "https://nc.milesplit.com/meets/624617-bo-run-2024/results/1083114/raw"
brChampRes = read_html(boRunChampUrl)
brChamp = brChampRes |> html_element("body") |> html_element("main") |>
  html_element('.content') |> html_elements('pre') |> html_text2()
write_file(brChamp,'~/Documents/runTracker/scrapeMeets/boRunChamp.txt')

boRunInviteUrl = "https://nc.milesplit.com/meets/624617-bo-run-2024/results/1083116?type=formatted"
brInviteRes = read_html(boRunInviteUrl)
brInvite = brInviteRes |> html_element("body") |> html_element("main") |>
  html_element('.content') |> html_elements('pre') |> html_text2()
write_file(brInvite,'~/Documents/runTracker/scrapeMeets/boRunInvite.txt')

bccUrl = "https://nc.milesplit.com/meets/626483-bcc-round-up-boyd-lee-scdhcnbjhr-2024/results"
bccRoundUpBL = read_html(bccUrl)
bccRound = bccRoundUpBL |> html_element("body") |> html_element("main") |>
  html_element('.content') |> html_elements('pre') |> html_text2()
write_file(bccRound, '~/Documents/runTracker/scrapeMeets/bccRoundUpOct02.txt')

grtAmUrl = "https://nc.milesplit.com/meets/619800-great-american-xc-festival-2024/results/1088306/raw"
grtAmRed = read_html(grtAmUrl)
grtAmRes = grtAmRed |> html_element("body") |> html_element("main") |>
  html_element('.content') |> html_elements('pre') |> html_text2()
write_file(grtAmRes, '~/Documents/runTracker/scrapeMeets/grtAmericanRed.txt')

nbTriMeetUrl = "https://nc.milesplit.com/meets/642353-bcc-xc-tri-rose-south-central-new-bern-2024/results/1092144?type=raw"
nbTriMeet = read_html(nbTriMeetUrl)
nbTriRes = nbTriMeet |> html_element("body") |> html_element("main") |>
  html_element('.content') |> html_elements('pre') |> html_text2()
write_file(nbTriRes, '~/Documents/runTracker/scrapeMeets/nbTriMeetRes.txt')
