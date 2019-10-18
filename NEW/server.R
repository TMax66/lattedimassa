#######################FUNZIONI DI R#############################################
 
 server<-function(input, output, session){
   
##########OVERVIEW##################
   
   output$year<-renderValueBox(
     {
       valueBox(max(latte$anno), "Anno di riferimento", icon("th"), 
                color="green")

     }
   )
   
   
   
   output$aziende <- renderValueBox({
     valueBox(
       latte %>% 
         filter(anno==max(latte$anno))%>% 
         group_by(codaz) %>% 
         summarise(az=n_distinct(codaz)) %>% 
         ungroup() %>% 
         summarise(naz=sum(az)) %>% 
         select(naz), "# Aziende", icon = icon("keyboard"),
       color = "red"
     )
   })
   
   
   output$camp<- renderValueBox({
     valueBox( 
   latte %>%   
     filter(anno==max(latte$anno)) %>% 
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
         filter(anno==max(latte$anno)) %>% 
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
         filter(anno==max(latte$anno)) %>% 
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
         filter(anno==max(latte$anno)) %>% 
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
         filter(anno==max(latte$anno)) %>% 
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
         filter(anno==max(latte$anno)) %>% 
         filter(prova=="Carica batterica totale") %>% 
         group_by(anno,nconf)%>%    
         summarise(cbt =geometric.mean(risnum, na.rm=T))%>% 
         ungroup() %>% 
         summarise(prot = round(geometric.mean(cbt, na.rm=T), 1)), "CBT",
       color="green"
     )
   })
   
   
   output$ibr<- renderValueBox({
     valueBox( 
       latte %>% 
         filter(anno==max(latte$anno)) %>% 
         filter(prova=="BHV1/Rinotracheite Infettiva Bovina: anticorpi nel latte") %>% 
         group_by(anno,nconf)%>%    
         summarise(cbt =geometric.mean(risnum, na.rm=T))%>% 
         ungroup() %>% 
         summarise(prot = round(geometric.mean(cbt, na.rm=T), 1)), "CBT",
       color="green"
     )
   })
   
   
   output$ibr<- renderValueBox({
     valueBox(
       prev %>% 
         filter(anno==max(latte$anno)) %>% 
         filter(prova=="BHV1/Rinotracheite Infettiva Bovina: Ab x gE del virus nel latte") %>% 
         group_by(prova)%>%    
         summarise(IBR =round(mean(Pos, na.rm=T),1)) %>% 
         select(IBR),"% IBR-gE",
       color="green"
     )
   })
   
   output$stg<- renderValueBox({
     valueBox(
       prev %>% 
         filter(anno==max(latte$anno)) %>% 
         filter(prova=="Esame batteriologico latte (ricerca Streptococcus agalactiae)") %>% 
         group_by(prova)%>%    
         summarise(stag =round(mean(Pos, na.rm=T),1)) %>% 
         select(stag),"% Str.agalactiae",
       color="green"
     )
   })
   
   output$stf<- renderValueBox({
     valueBox(
       prev %>% 
         filter(anno==max(latte$anno)) %>% 
         filter(prova=="Esame batteriologico latte (ricerca Stafilococco coagulasi +)" ) %>% 
         group_by(prova)%>%    
         summarise(stau =round(mean(Pos, na.rm=T),1)) %>% 
         select(stau),"% Staf.aureus",
       color="yellow"
     )
   })
   
   
   output$fbq<- renderValueBox({
     valueBox(
       prev %>% 
         filter(anno==max(latte$anno)) %>% 
         filter(prova=="Febbre Q da Coxiella burnetii: agente eziologico") %>% 
         group_by(prova)%>%    
         summarise(fq =round(mean(Pos, na.rm=T),1)) %>% 
         select(fq),"% Febbre Q",
       color="navy"
     )
   })
   
   
   
   output$neos<- renderValueBox({
     valueBox(
       prev %>% 
         filter(anno==max(latte$anno)) %>% 
         filter(prova=="Neospora caninum: anticorpi") %>% 
         group_by(prova)%>%    
         summarise(nsp =round(mean(Pos, na.rm=T),1)) %>% 
         select(nsp),"% N.caninum",
       color="navy"
     )
   })
   
   
   
   
   
#############Grafici##############   
   quan<-reactive({
     
     latte %>%
       group_by(codaz, anno, prova) %>%
       filter(prova==input$prova) %>%
       summarise(y=mean(risnum)) %>%
       ungroup() %>%
       group_by(anno) %>%
       summarise(y=mean(y, na.rm = T))
     
   })
   
   output$p1<-renderPlot(
     quan() %>% 
       ggplot(aes(x=anno, y=y))+geom_point()+geom_line()+
       labs(y=paste("media",input$prova))
       
   )
   
 output$p2<-renderPlot(
   prev %>% 
     filter(prova==input$quali) %>% 
     ggplot(aes(x=anno, y=Pos))+geom_point()+geom_line()
 )
   
####controlli qualitativi########
   # output$info<-DT::renderDataTable(
   #   latte %>% 
   #     filter(codaz==input$cod) %>% 
   #     arrange(desc(dtprel)) %>% 
   #     select("proprietario"=propr, "ultimo controllo"=dtprel1) %>% 
   #     head(1), 
   #   options = list(searching=FALSE, dom = 't'))
   

info<-reactive({ latte %>% 
     filter(codaz==input$cod) %>% 
     arrange(desc(dtprel)) %>% 
     select("proprietario"=propr, "ultimo controllo"=dtprel1) %>% 
     head(1)})
     
output$info<-function(){  
   knitr::kable(info())%>% 
     kable_styling("striped", full_width = F,fixed_thead = T, font_size = 15) 
    }
 
 
 
 
 
   quali<-reactive({latte %>% 
       filter(prova2=="Quali") %>%
       filter(codaz==input$cod) %>%
       select("Parametri Sanitari"=prova,dtprel,esito) %>% 
       mutate(esito = 
                ifelse(esito=="N",     
                       cell_spec(esito, "html", color="green",bold=T),
                       cell_spec(esito, "html", color="red", bold=T))) %>% 
       
       arrange(dtprel) %>% 
       mutate(dtprel=format(dtprel, "%d-%m-%Y")) %>% 
       pivot_wider(names_from=dtprel,values_from=esito ) 
       
       })
     
     
   output$tq<-function(){
     
     knitr::kable(quali(), escape = F)%>% 
       kable_styling("striped", full_width = F,fixed_thead = T, font_size = 18) 
    
   }
   
    
##controlli quantitativi########
   
   # output$info2<-DT::renderDataTable(
   #   latte %>% 
   #     filter(codaz==input$cod2) %>% 
   #     arrange(desc(dtprel)) %>% 
   #     select("proprietario"=propr, "ultimo controllo"=dtprel1) %>% 
   #     head(1), 
   #   options = list(searching=FALSE, dom = 't'))

   
   
   
   
   
  quanti<-reactive({latte %>%
      filter(prova2=="Quanti") %>%
      filter(codaz==input$cod) %>%
      select("Parametri Qualità Latte"=prova,dtprel,risnum) %>%
      arrange(dtprel) %>%
      mutate(dtprel=format(dtprel, "%d-%m-%Y")) %>%
      pivot_wider(names_from=dtprel,values_from=risnum )

   })


  output$tquant<-function(){
    options(knitr.kable.NA = '')
    knitr::kable(quanti(), escape = F)%>% 
      kable_styling("striped", full_width = F,fixed_thead = T, font_size = 18) 
    
  }
  

   
#   graph <- reactive({ quanti() %>% 
#     group_by(prova) %>% 
#     gather(key=year, value=value, -prova) %>% 
#     summarise(graph=spk_chr(
#       value, 
#       chartRangeMin = 0,
#       type="line"))})
#   
#  quanti2 <- reactive({left_join(quanti(), graph(), by=c("prova"))
#     })
#  
#  
#  t<-reactive({ quanti2() %>%
#    formattable::format_table(
#      x = .,
#      formatters = list(
#        align=c("l")
#      )
#    )})
#  
#   
# 
# 
#   
#  output$tquant<-renderText({
# t() %>% 
#      kable_styling("striped", full_width = T,fixed_thead = T, font_size = 18) %>%
#      htmltools::HTML() %>%
#      shiny::div() %>%
#      sparkline::spk_add_deps()
# 
#   })
 #   
   
   
   
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