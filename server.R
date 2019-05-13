#######################FUNZIONI DI R#############################################
 
 server<-function(input, output){


   
   
   output$info<-DT::renderDataTable(
     latte %>% 
       filter(codaz==input$cod) %>% 
       arrange(desc(dtprel)) %>% 
       select("proprietario"=propr, "ultimo controllo"=dtprel1) %>% 
     head(1), 
     options = list(searching=FALSE, dom = 't'))
     
     
     
  
 
     
   

#Pagina 1
  
  # output$distPlot <- renderPlot({
  #   latte %>%
  #     filter(codaz==input$cod)%>%
  #     filter(prova==input$cod2)%>%
  #     ggplot(aes(dtprel, risnum))+geom_line()+geom_point()
  # 
  #     
  #   })
  # output$range <- renderPrint({ input$slider2 })
  
  
  output$dt2<-DT::renderDataTable(
    latte %>%
      filter(prova==input$cod2)%>%
      filter(codaz==input$cod) %>%
      select(anno,  "conferimento"=nconf, vet, prova, "esito"=risnum) %>%
      arrange(anno),
    rownames=FALSE,
      options=list(dom = 't')
  )
  
  
#pagina 2
  
  output$dt<- DT::renderDataTable(
    latte, server= FALSE,filter = 'top',extensions = 'Buttons',class = 'cell-border stripe',
    rownames = FALSE, options = list(
      dom = 'Bfrtip',paging = TRUE,autoWidth = TRUE,
      pageLength = 10,buttons = c("csv",'excel'))
  )

#Pagina 3
  
  #output$range <- renderPrint({ input$slider3 })
  
  output$dt3<-DT::renderDataTable(

    latte %>%
    filter(codaz==input$cod) %>%
    filter(prova==input$cod4) %>%
      select(anno, "conferimento"=nconf, vet, prova, esito) %>%
      arrange(anno),
    rownames=FALSE,options=list(dom = 't')
)
  
  
  
  # output$dt4<-renderPrint(
  #   if(is.null){print("Nessun dato disponibile")}
  # )
    

   ####IL REACTIVE VA FUORI DALLA FUNZIONE CHE TI SERVE PER FARE LA TABELLA E/O IL GRAFICO####
   # PREV<-reactive({
   #  ANALISI<-latte %>%
   #   group_by(anno, prova, codaz) %>%
   #   summarise("n"=n())
   # POSITIVI<-latte %>%
   #   group_by(anno, prova, codaz) %>%
   #   filter(esito=="P") %>%
   #   summarise("P"=n())
   # PREVAL<-ANALISI %>% 
   #   full_join(POSITIVI)%>%
   #   replace_na(list(P=0)) %>%
   #   mutate("%positivi"=(P/n)*100)})
   # 
   

   
   

}