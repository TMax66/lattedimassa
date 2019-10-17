library(tidyverse)
library(googlesheets)
library(lubridate)
library(DT)

rm(list=ls())


# token <- gs_auth(cache = FALSE)
# gd_token()
# saveRDS(token, file = "googlesheets_token.rds")

gs_auth(token = "googlesheets_token.rds")
suppressMessages(gs_auth(token = "googlesheets_token.rds", verbose = FALSE))




sheet <- gs_title("LMassa")
latte<-gs_read(sheet,
               locale = readr::locale(decimal_mark = ","))

latte$dtprel<-mdy(latte$dtprel)
latte$dtprel1<-format(latte$dtprel, "%d-%m-%Y")
latte<-mutate(latte,anno=year(dtprel))
#latte$anno<-as.Date((paste(latte$anno,"-01","-01",sep="")))
#latte$anno<-substr(latte$anno, 1,4)



# latte %>% 
#   group_by(codaz, anno, prova) %>% 
#   filter(prova=="Proteine") %>%
#  # filter(!is.na(esito)) %>% 
#   ggplot(aes(x=anno, y=risnum))+geom_point()+geom_line()
# 
# 
