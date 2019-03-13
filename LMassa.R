library(tidyverse)
library(googlesheets)

rm(list=ls())
sheet <- gs_title("LMassa")
data<-gs_read(sheet)
data$dt_prelievo<-as.Date(data$dt_prelievo, origin=as.Date("1970-01-01"))
data$allevix<-casefold(data$allevix, upper=TRUE)
data$vetlp<-casefold(data$vetlp, upper=TRUE)
data%>%as.tibble()%>%
  mutate(anno=year(dt_prelievo))%>%
  arrange(desc(dt_prelievo))


x<-data %>% 
  filter(prova=="Proteine")
hist(x$risnum)
