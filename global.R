library(tidyverse)
library(googlesheets4)
library(googledrive)
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


#IL CODICE SEGUENTE SI FA SOLO LA PRIMA VOLTA CHE SI ACCEDE AL DRIVE DI GOOGLE
# options(gargle_oauth_cache = ".secrets")
# gargle::gargle_oauth_cache()
# drive_auth()
# list.files(".secrets/")

options(
  gargle_oauth_cache = ".secrets",
  gargle_oauth_email = TRUE
)
drive_auth()

gs4_auth(token = drive_token())
mydrive<-drive_find(type = "spreadsheet")
id<-mydrive %>% 
  filter(name=="lmassa") %>% 
  select(2)

options(scipen = 999)

latte<-read_sheet(id$id)

names(latte)<-c("nconf","dtprel","dtconf", "codaz", "prova",
                "esito","esitodescr", "vet","propr","ageziologico",
                "risnum", "matrice", "um")

latte$risnum<-as.numeric(sub(",", ".", sub(".", ".", latte$risnum, fixed=TRUE), fixed=TRUE))
latte$codaz<-casefold(latte$codaz, upper = TRUE)
latte$propr<-casefold(latte$propr, upper = TRUE)
latte$dtprel<-as.Date(latte$dtprel)
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
#  # ungroup() %>% 
  
  
  
# is<-latte %>%
#   filter(prova2=="Quali") %>%
#   select(codaz,prova,propr,dtprel,esito) %>%
#   mutate("n.c"=ifelse(esito=="N", 0,
#                       ifelse(esito=="I", NA, 1))) %>%
#   drop_na(n.c) %>%
#   group_by(codaz) %>%
#   summarise(ncontrolli=n(), nc=sum(n.c)) %>%
#   mutate(Med=median(ncontrolli)) %>% 
#   mutate(x=ifelse(ncontrolli<median(ncontrolli),nc+(median(ncontrolli)-ncontrolli), nc) ) %>% 
#   mutate(x2=ifelse(x>ncontrolli, ncontrolli-1, 
#                    ifelse(ncontrolli<median(ncontrolli) & x<=ncontrolli, nc+(ncontrolli-x), x))) %>% 
#   mutate(is=1-(nc/ncontrolli),
#                isW=1-(x2/ncontrolli))
#   
# 
# 
# tibble(c=c(rep(10,6), rep(100,6)), nc=c(seq(from=0 , to=5, by=1 ),seq(from=0, to=50, by=10))) %>%
  #mutate(is=1-(nc/c), isW=is*c)



