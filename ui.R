#############INTERFACCIA GRAFICA###################################################
 ui<-navbarPage("Monitoraggio latte",
                tabPanel("Controlli",
                         fluidPage(
                           titlePanel(""),
                           #useShinyalert(),
                           sidebarPanel(
                             selectInput("cod", "Codice Allevix",
                                         c(unique(as.character(latte$codaz)))),
                             
                             DT::dataTableOutput("info"),
                            
                  
                            
                            
                            
                            br(),
                            hr(),
                            
                            selectInput("cod2", "Prove quantitative",
                                         c("Proteine", "Grasso", "Lattosio", "Carica batterica totale","cellule somatiche","urea"
                                           )
                                         ),
                            selectInput("cod4", "Prove qualitative",
                                        c(unique(as.character(latte$prova))))
                            ),
                            
                       
                  
        
                          mainPanel(
                           h4(strong("Prove quantitative"), align = "center"),
                           hr(),
                          
                           DT::dataTableOutput("dt2"),
                           
                           br(),
                           h4(strong("Prove qualitative"), align = "center"),
                           hr(),
                           DT::dataTableOutput("dt3")
                          
                          ))
                          ),


            # tabPanel("Controlli",
            # 
            #          #mainPanel("",
            # 
            #                    fluidPage(
            #                      sidebarPanel(
            #                        # selectInput("cod3", "Codice Allevix",
            #                        #             c(unique(as.character(latte$codaz)))),
            #                       
            #                         selectInput("cod4", "Prove qualitative",
            #                                     c(unique(as.character(latte$prova))))
            #                        ),
            #                        
            #                        
            #                      mainPanel(
            #                      #  DT::dataTableOutput("dt3")#,
            #                    # DT::dataTableOutput("tabella"),
            #                        #plotOutput("prevalenza")
            #                      )
            #                    )
            # ),
                                       



tabPanel("Database",
         
         fluidPage(
           fluidRow(   
             DT::dataTableOutput("dt")
                   ) 
                  )
        )
)

