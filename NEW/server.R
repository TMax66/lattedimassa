#######################FUNZIONI DI R#############################################
 
 server<-function(input, output, session){
   
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