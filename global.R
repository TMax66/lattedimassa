library(tidyverse)
library(googlesheets)
library(lubridate)
library(DT)

rm(list=ls())
sheet <- gs_title("LMassa")
latte<-gs_read(sheet)

latte$dtprel<-mdy(latte$dtprel)
latte$dtprel1<-format(latte$dtprel, "%d-%m-%Y")
latte<-mutate(latte,anno=year(dtprel))
latte$anno<-as.Date((paste(latte$anno,"-01","-01",sep="")))
latte$anno<-substr(latte$anno, 1,4)

#latte$dtprel<-as.Date(latte$dtprel, origin=as.Date("1970-01-01"))

#latte$codaz<-casefold(latte$codaz, upper=TRUE)
#latte$veterinario<-casefold(latte$veterinario, upper=TRUE)
#latte$proprietario<-casefold(latte$proprietario, upper=TRUE)
#selezionoanni <- subset(latte, anno == "2016", "2017", "2018", "2019")




