
latte<-latte[, -14]


names(latte)<-c("nconf","dtprel","dtconf", "codaz", "prova",
                "esito","esitodescr", "vet","propr","ageziologico",
                "risnum", "matrice", "um")

latte$risnum<-as.numeric(sub(",", ".", sub(".", "", latte$risnum, fixed=TRUE), fixed=TRUE))
latte$codaz<-casefold(latte$codaz, upper = TRUE)

latte$codaz <- substr(as.character(latte$codaz),1,8)

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


is<-latte %>% 
  filter(prova2=="ps") %>%
  filter(anno>2009) %>% 
  select(codaz,prova,anno,esito) %>% 
  mutate("n.c"=ifelse(esito=="N", 0, 1)) %>% 
  drop_na(n.c) %>% 
  group_by(codaz, anno) %>% 
  summarise(ncontrolli=n(), nc=sum(n.c)) %>% 
  mutate(scontr=cumsum(ncontrolli), snc=cumsum(nc), cis=round(1-(snc/scontr),2),
         is=1-(nc/ncontrolli))