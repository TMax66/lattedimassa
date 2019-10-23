library(googlesheets)
library(tidyverse)
library(leaflet)
library(maps)
library(rgdal)
library(sp)
library(lubridate)
library(janitor)
library(rmapshaper)
library(DataExplorer)
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
#library(sparkline)
#library(htmltools)
#library(shiny)


rm(list=ls())

####IS Aziendale#########################################

options(scipen = 999)
options(knitr.kable.NA = '')

# token <- gs_auth(cache = FALSE)
# gd_token()
# saveRDS(token, file = "googlesheets_token.rds")


gs_auth(token = "googlesheets_token.rds")
suppressMessages(gs_auth(token = "googlesheets_token.rds", verbose = FALSE))

sheet <- gs_title("LATTISAz")
latte<-gs_read(sheet)


latte<-latte[, -14]


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
    latte$prova=="Cellule somatiche" | 
    latte$prova=="Carica batterica totale", "pq", "ps"
)


latte$esito<-ifelse(
  latte$esito=="-", "N", 
  ifelse(latte$esito=="P tipo 1", "P", 
         ifelse ( latte$esito=="+", "P", 
                  ifelse(latte$esito=="P aureus", "P",
                         ifelse(latte$esito=="PR1", "P", 
                                ifelse(latte$esito=="PR2","P",
                                       ifelse(latte$esito=="< 5 ng/l", "N", 
                                              ifelse(latte$esito=="NR", "N", latte$esito)))))))
)

latte<-
  latte %>% 
  filter(esito %in% c("P" , "N"))


x<-latte %>% 
  filter(prova2=="ps") %>%
  filter(anno>2009) %>% 
  select(codaz,prova,anno,esito) %>% 
  mutate("n.c"=ifelse(esito=="N", 0, 1)) %>% 
  drop_na(n.c) %>% 
  group_by(codaz, anno) %>% 
  summarise(ncontrolli=n(), nc=sum(n.c)) %>% 
  mutate(scontr=cumsum(ncontrolli), snc=cumsum(nc), cis=round(1-(snc/scontr),2),
         is=1-(nc/ncontrolli))
  
  
  #mutate("i.s"=1-(nc/ncontrolli)) %>%
  #ggplot(aes(x=i.s))+geom_histogram(fill="lightblue", col="black")+facet_grid(~anno)
  ggplot(aes(y=i.s, x=anno))+geom_point()+geom_line()
  #geom_line(aes(y=ncontrolli))



####################################################
regione<-readOGR(dsn="shp", layer = "Regione_2018")
regione<-spTransform(regione, CRS("+proj=longlat +datum=WGS84"))
regione<-rmapshaper::ms_simplify(regione)

province<-readOGR(dsn="shp", layer="Province_2018")
province<-spTransform(province, CRS("+proj=longlat +datum=WGS84"))
province<-rmapshaper::ms_simplify(province)

comuni<-readOGR(dsn="shp", layer = "Comuni_2018_poligonali")
comuni<-spTransform(comuni, CRS("+proj=longlat +datum=WGS84"))
comuni<-rmapshaper::ms_simplify(comuni)


pr<-c("BERGAMO")
prov<-subset(province, province@data$NOME %in% pr)































##########MAPPE#######################################################
regione<-readOGR(dsn="shp", layer = "Regione_2018")
regione<-spTransform(regione, CRS("+proj=longlat +datum=WGS84"))
regione<-rmapshaper::ms_simplify(regione)

province<-readOGR(dsn="shp", layer="Province_2018")
province<-spTransform(province, CRS("+proj=longlat +datum=WGS84"))
province<-rmapshaper::ms_simplify(province)

comuni<-readOGR(dsn="shp", layer = "Comuni_2018_poligonali")
comuni<-spTransform(comuni, CRS("+proj=longlat +datum=WGS84"))
comuni<-rmapshaper::ms_simplify(comuni)




pr<-c("BERGAMO","LECCO", "SONDRIO", "VARESE", "PAVIA", "COMO", "BRESCIA")
prov<-subset(province, province@data$NOME %in% pr)















# amr <- read.delim("amr.csv")
# 
# funz<-function(x){
#   
#   abs(as.numeric(as.factor(x))-2)
# }
# 
# amr<-amr %>% 
#   select(-tilmicosina,-oxacillina, -eritromicina)
# 
# amr[,13:22]<-apply(amr[,13:22], 2 , funz)
# 
# 
# 
# amr<-amr %>% 
#   mutate(MDR = rowSums(.[13:22])) 
# 
# #amr<-amr[-416,]
# 
# amr<-amr %>% 
#   group_by(comune, zalt,altcentro.m., litoraneo,montano,        
#            sup, urb,aziende,capi, hapasc, sup.kmq.,       
#            altmin,altmax,range, media, mediana,std,denpop.abkmq.)%>% 
#   summarise(MAR=sum(MDR)/(n()*10)) %>% 
#   as.data.frame()





com<-subset(comuni, comuni@data$NOME_COM %in% amr$comune)

com<-merge(com, amr, by.x = "NOME_COM", by.y = "comune")

com@data$MAR[ which(com@data$MAR == 0)] = NA

leaflet(data=regione) %>% addTiles() %>% 
  addPolygons(data=com,fill="F", fillColor="navy", 
              fillOpacity = 0.5,weight=1, opacity=1.0) %>% 
  addPolygons(data=province, fill="F",color="") %>% 
  addPolygons(data=prov, fill=F, color="black", weight=1, opacity=1.0) 

mybins=c(0,0.20,0.4,0.6,0.8,1)
mypalette = colorBin( palette="YlOrBr",
                      domain=com@data$MAR, na.color="transparent", bins=mybins)

mytext=paste("MAR Index: ", round(com@data$MAR,2),  sep="") %>%
  lapply(htmltools::HTML)




leaflet(data=regione) %>% addTiles() %>% 
  addPolygons(data=com, 
              fillColor = ~mypalette(MAR),
              fillOpacity = 0.9,stroke=FALSE, weight = 10) %>% 
addLegend( pal=mypalette, values= com@data$MAR, opacity=0.9, title = "MAR Index", position = "bottomleft" )%>% 
  addPolygons(data=province, fill="F",color="") %>% 
  addPolygons(data=prov, fill=F, color="black", weight=1, opacity=1.0) 
  




BG@data %>% inner_join(avv, by=c("NOME_COM"="comune"))

nomecom<-BG@data$NOME_COM
centroidi<-coordinates(BG)
bg<-tibble("comune"=as.character(nomecom), "lng"=centroidi[,1], "lat"=centroidi[,2])
bg<-bg 
  # mutate("lng"=jitter(lng, factor=0.0001), "lat"=jitter(lat, factor=0.0001))

# leaflet(data=bg) %>% addTiles() %>% 
#   addMarkers(~lng, ~lat,popup = ~as.character(comune), label = ~as.character(comune))


amr <- read.delim("amr.csv")
amr$colistina<-ifelse(amr$colistina=='R', 'COL',0)
amr$ceftiofur<-ifelse(amr$ceftiofur=='R', 'CFT',0)
#amr$tilmicosina<-ifelse(amr$tilmicosina=='R', 'TIL',0)
amr$kanamicina<-ifelse(amr$kanamicina=='R', 'KAN',0)
amr$enrofloxacin<-ifelse(amr$enrofloxacin=='R', 'ENR',0)
#amr$oxacillina<-ifelse(amr$oxacillina=='R', 'OXA',0)
#amr$eritromicina<-ifelse(amr$eritromicina=='R', 'ERT',0)
amr$gentamicina<-ifelse(amr$gentamicina=='R', 'GEN',0)
amr$tetraciclina<-ifelse(amr$tetraciclina=='R', 'TET',0)
amr$ampicillina<-ifelse(amr$ampicillina=='R', 'AMP',0)

#write.table(amr, file="amrxx.csv")


amr[,13:22]<-amr[,13:22] != 0
nomi_abb<-toupper(abbreviate(names(amr)[13:22]))
X<-  apply(amr[, 13:22], 1, function(x) nomi_abb[x])
XX<-lapply(X, paste, collapse="-")

amr$profilo<-unlist(XX)




amr %>% 
  filter(profilo!="NA-NA-NA-NA-NA-NA-NA-NA-NA-NA") %>% 
  group_by(profilo) %>% 
  summarise(n=n()) %>% 
  arrange(n) %>% 
  top_n(10, n) %>% 
  mutate(profilo = factor(profilo, unique(profilo))) %>% 
  ggplot(aes(x=profilo, y=n))+geom_bar(stat = "identity")+coord_flip()
