######LIBRERIE######
library(shiny)
library(shinydashboard)
library (DT)
library(plotly)
library(reshape2)
library(data.table)
library(dplyr)
library(ggplot2)
library(tibble)
library(lubridate)
library(scales)
library(gridExtra)
library(forecast)
library(TTR)
library(xts)
library(dygraphs)
library(datasets)
library(tidyverse)
library(rpivotTable)
library(shinyalert)
library(knitr)
library(formattable)
library(kableExtra)
library(readxl)
###############################


dati <- read_excel("absuini.xlsx")
 
#dati$data<-dmy(dati$data)
dati<-mutate(dati,anno=year(data))
dati$azienda<-casefold(dati$azienda, upper = TRUE)








# dati$antibiotico<-
#   plyr::revalue(dati$antibiotico,
#                 c("Lincomicina"="Clindamicina", "Pirlimicina"="Clindamicina",
#                   "Enrofloxacin"="Danofloxacin", "Marbofloxacin"="Danofloxacin",
#                   "Flumequina"="Acido Nalidixico", "Amoxicillina"="Ampicillina",
#                   "Apramicina"="Gentamicina","Cefalexina"="Cefalotina", "Cefoperazone"="Ceftiofur",
#                   "Cefquinome"="Ceftiofur", "Cloxacillina"="Oxacillina",  "Penetamato Iodidrato" = "Penicillina G",
#                   "Penicillina"="Penicillina G", "Spiramicina"="Tilmicosina", "Streptomicina"="Kanamicina",
#                   "Sulfadimetossina"="Sulfisoxazolo", "Tilosina"="Tilmicosina", "Tiamfenicolo"="Cloramfenicolo",
#                   "Nafcillina"="Oxacillina", "Rifaximina"="Rifampicina", "Clortetraciclina"="Tetraciclina",
#                   "Ossitetraciclina"="Tetraciclina", "Florfenicolo"="Cloramfenicolo", "Tulatromicina"="Eritromicina",
#                   "Sulfadiazina"="Sulfisoxazolo", "Cefpodoxime"="Ceftiofur"))

 

dati$I<-ifelse(dati$I=="I", 1, dati$I)
dati$R<-ifelse(dati$R=="R", 1, dati$R)
dati$S<-ifelse(dati$S=="S", 0, dati$S)

dati$Res <-rowSums(dati[,12:14], na.rm = T)


 x<-dati %>%
  select(anno,azienda,ceppo, Res) %>%
  group_by(anno,azienda, ceppo) %>% 
  mutate(res=sum(Res),
  test=n(),
  ARindex=res/test) %>% 
  select(anno, azienda,ARindex) %>% 
  unique() %>%
   ungroup() %>%
   select(azienda, ARindex) %>% 
   group_by(azienda) %>% 
   summarise(mARindex=mean(ARindex, na.rm=T))
 

  


# y<-dati %>% 
#   select(anno,azienda,  antib,Res) %>% 
#   group_by(anno, azienda ) %>% 
#   mutate(rn = row_number()) %>% 
#   pivot_wider(names_from=antib,values_from=Res) %>% 
#   group_by(anno, azienda) %>% 
#   unique()

  



  