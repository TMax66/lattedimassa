#######################FUNZIONI DI R#############################################
 
 server<-function(input, output, session){
   
##########OVERVIEW##################
   
   output$aziende <- renderValueBox({
     valueBox(
       length(unique(latte$codaz)), "# Aziende", icon = icon("keyboard"),
       color = "red"
     )
   })
   
   
   output$camp<- renderValueBox({
     valueBox( 
   latte %>%                     
     group_by(anno,nconf)%>%    
     summarise(ncampioni = n_distinct(nconf))%>% 
     summarise(x=sum(ncampioni)) %>% 
     ungroup() %>% 
     summarise(ncamp = sum(x)), "#Campioni",
   color="blue"
   )
   })
   
   output$prot<- renderValueBox({
     valueBox( 
       latte %>% 
         filter(prova=="Proteine") %>% 
         group_by(anno,nconf)%>%    
         summarise(proteine = mean(risnum, na.rm=T))%>% 
         ungroup() %>% 
         summarise(prot = round(mean(proteine), 1)), "Proteine",
       color="green"
     )
   })
   
   output$grasso<- renderValueBox({
     valueBox( 
       latte %>% 
         filter(prova=="Grasso") %>% 
         group_by(anno,nconf)%>%    
         summarise(grasso = mean(risnum, na.rm=T))%>% 
         ungroup() %>% 
         summarise(grass = round(mean(grasso), 1)), "Grasso",
       color="green"
     )
   })
   
   output$lattosio<- renderValueBox({
     valueBox( 
       latte %>% 
         filter(prova=="Lattosio") %>% 
         group_by(anno,nconf)%>%    
         summarise(lattosio = mean(risnum, na.rm=T))%>% 
         ungroup() %>% 
         summarise(latt = round(mean(lattosio), 1)), "Lattosio",
       color="green"
     )
   })
   
   output$css<- renderValueBox({
     valueBox( 
       latte %>% 
         filter(prova=="Cellule somatiche") %>% 
         group_by(anno,nconf)%>%    
         summarise(css =geometric.mean(risnum, na.rm=T))%>% 
         ungroup() %>% 
         summarise(scc = round(geometric.mean(css, na.rm=T), 1)), "SCC",
       color="green"
     )
   })
   
   output$cbt<- renderValueBox({
     valueBox( 
       latte %>% 
         filter(prova=="Carica batterica totale") %>% 
         group_by(anno,nconf)%>%    
         summarise(cbt =geometric.mean(risnum, na.rm=T))%>% 
         ungroup() %>% 
         summarise(prot = round(geometric.mean(cbt, na.rm=T), 1)), "CBT",
       color="green"
     )
   })
   
   
#############Grafici##############   
   qual<-reactive({
     
     latte %>%
       group_by(codaz, anno, prova) %>%
       filter(prova==input$prova) %>%
       summarise(y=mean(risnum)) %>%
       ungroup() %>%
       group_by(anno) %>%
       summarise(y=mean(y))
     
   })
   
   output$p1<-renderPlot(
     qual() %>% 
       ggplot(aes(x=anno, y=y))+geom_point()+geom_line()+
       labs(y=paste("media",input$prova))
       
   )
   
####controlli qualitativi########
   output$info<-DT::renderDataTable(
     latte %>% 
       filter(codaz==input$cod) %>% 
       arrange(desc(dtprel)) %>% 
       select("proprietario"=propr, "ultimo controllo"=dtprel1) %>% 
       head(1), 
     options = list(searching=FALSE, dom = 't'))
   

   quali<-reactive({latte %>% 
     filter(prova2=="Quali") %>%
     filter(codaz==input$cod) %>%
     select(prova,dtprel,esito) %>% 
     arrange(desc(dtprel)) %>% 
       mutate(dtprel=format(dtprel, "%d-%m-%Y")) %>% 
       pivot_wider(names_from=dtprel,values_from=esito ) })
     
     
   output$tq<-function(){
     
     knitr::kable(quali(), escape = F)%>% 
       kable_styling("striped", full_width = T,fixed_thead = T)
     
   }
   
    
   
#####Base dati######################################
   milk<-reactive({   
     latte %>% 
       select(dtconf, codaz, prova, esito, vet, ageziologico,risnum, anno)})

   output$dt<- DT::renderDataTable(
     milk(), server= FALSE,filter = 'top',extensions = 'Buttons',class = 'cell-border stripe',
     rownames = FALSE, options = list(
       dom = 'Bfrtip',paging = TRUE,
       pageLength = 10,buttons = c("csv",'excel'))
   )
   
  
  
  
   
   
}