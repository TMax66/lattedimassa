library(tidyverse)
library(googlesheets)
library(shinydashboard)
library(lubridate)
library(knitr)
library(kableExtra)
library(DT)

rm(list=ls())
sheet <- gs_title("LMassa")
latte<-gs_read(sheet)
latte$risnum<-as.numeric(sub(",", ".", sub(".", "", latte$risnum, fixed=TRUE), fixed=TRUE))
latte$codaz<-casefold(latte$codaz, upper = TRUE)
latte$propr<-casefold(latte$propr, upper = TRUE)
latte$dtprel<-mdy(latte$dtprel)
latte$dtprel1<-format(latte$dtprel, "%d-%m-%Y")
latte<-mutate(latte,anno=year(dtprel))

latte$codaz<-ifelse(latte$propr=="SUARDI LUIGI", "219BG035", latte$codaz )
latte$codaz<-ifelse(latte$propr=="CAMPANA COSTANTINO E C. S.S", "245BG010", latte$codaz )
latte<-

# latte %>% 
#   group_by(codaz, anno, prova) %>% 
#   filter(prova=="Proteine") %>%
#  # filter(!is.na(esito)) %>% 
#   ggplot(aes(x=anno, y=risnum))+geom_point()+geom_line()
# 
# 
