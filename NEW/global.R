library(tidyverse)
library(googlesheets)
library(shinydashboard)
library(lubridate)
library(knitr)
library(kableExtra)
library(DT)
library(psych)
library(tidyr)
library(formattable)
library(shinyBS)
library(scales)
#library(sparkline)
#library(htmltools)
#library(shiny)

rm(list=ls())

options(scipen = 999)
options(knitr.kable.NA = '')
gs_auth(token = "googlesheets_token.rds")
suppressMessages(gs_auth(token = "googlesheets_token.rds", verbose = FALSE))

sheet <- gs_title("newlatte")
latte<-gs_read(sheet)


names(latte)<-c("nconf","dtprel","dtconf", "codaz", "prova",
                "esito","esitodescr", "vet","propr","ageziologico",
                "risnum", "matrice", "um")

latte$risnum<-as.numeric(sub(",", ".", sub(".", "", latte$risnum, fixed=TRUE), fixed=TRUE))
latte$codaz<-casefold(latte$codaz, upper = TRUE)
latte$propr<-casefold(latte$propr, upper = TRUE)
latte$dtprel<-mdy(latte$dtprel)
latte$dtprel1<-format(latte$dtprel, "%d-%m-%Y")

latte<-mutate(latte,anno=year(dtprel))

latte$prova2<-ifelse(
  latte$prova=="Proteine" |latte$prova=="Grasso" | latte$prova=="Lattosio" |
    latte$prova=="Proteine" | latte$prova=="Cellule somatiche" | latte$prova=="Urea" |
    latte$prova== "Punto di congelamento" | latte$prova=="Caseine" |
    latte$prova=="Carica batterica totale", "Quanti", "Quali"
)


latte$esito<-ifelse(
      latte$esito=="-", "N", 
      ifelse(latte$esito=="P tipo 1", "P", 
             ifelse ( latte$esito=="0,8", "P", latte$esito))
)



latte$codaz<-ifelse(latte$propr=="SUARDI LUIGI", "219BG035", latte$codaz )
latte$codaz<-ifelse(latte$propr=="CAMPANA COSTANTINO E C. S.S", "245BG010", latte$codaz )
latte<-latte %>% 
  filter(!is.na(codaz))
latte$esito<-ifelse(latte$esito=="P1", "P", latte$esito)

n<-latte %>% 
  filter(prova2=="Quali") %>% 
  group_by(anno, prova) %>% 
  summarise(n=n())
p<-latte %>% 
  filter(prova2=="Quali") %>% 
  filter(esito=="P") %>% 
  group_by(anno, prova) %>% 
  summarise(p=n())
prev<-n %>% 
  full_join(p) %>% 
  replace_na(list(p=0)) %>% 
  mutate("Pos"=round((p/n)*100,1))



is<-latte %>% 
    filter(prova2=="Quali") %>%
    select(codaz,prova,propr,dtprel,esito) %>% 
    mutate("n.c"=ifelse(esito=="N", 0,
                       ifelse(esito=="I", NA, 1))) %>% 
    drop_na(n.c) %>% 
    group_by(codaz) %>% 
    summarise(ncontrolli=n(), nc=sum(n.c)) %>% 
    mutate("i.s"=round(1-(nc/ncontrolli),2)) #%>% 
 # ungroup() %>% 
  
  
  
  



