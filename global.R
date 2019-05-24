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
#latte$anno<-as.Date((paste(latte$anno,"-01","-01",sep="")))
#latte$anno<-substr(latte$anno, 1,4)





