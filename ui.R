#############INTERFACCIA GRAFICA###################################################
 ui<-navbarPage("Piano paratubercolosi",
                tabPanel("Analisi quantitativa",
                         fluidPage(
                           titlePanel("Monitoraggio latte"),
                           #useShinyalert(),
                           sidebarPanel(
                             selectInput("cod", "Codice Allevix",
                                         c(unique(as.character(latte$codaz)))),
                            selectInput("cod2", "Prove quantitative",
                                         c("Proteine", "Grasso", "Lattosio", "Carica batterica totale","cellule somatiche","urea"
                                           )
                                         )),
                            # fluidRow(
                            #   column(4,
                            #          tabPanel("Help",tags$img(src = "Logo.png", position = "top")),
                            # 
                            #                     # Copy the line below to make a slider range
                            #                     sliderInput("slider2", label = h5("range"), min = 2016,
                            #                                 max = 2019, value = c(2016,2019))
                            #     )
                            #  ),
                  
                           # hr(),
                           # 
                           # fluidRow(
                           #   column(4, verbatimTextOutput("value")),
                           #   column(4, verbatimTextOutput("range"))
                           # )
                           
                       
                  
        
                          mainPanel(
                           DT::dataTableOutput("dt2"),
                           plotOutput("distPlot")
                          ))
                          ),


            tabPanel("Analisi qualitativa",
            
                     #mainPanel("",
            
                               fluidPage(
                                 sidebarPanel(
                                   selectInput("cod3", "Codice Allevix",
                                               c(unique(as.character(latte$codaz)))),
                                  
                                    selectInput("cod4", "Prove qualitative",
                                                c(unique(as.character(latte$prova))))
                                   ),
                                   
                                   
                                 mainPanel(
                                   DT::dataTableOutput("dt3")#,
                               # DT::dataTableOutput("tabella"),
                                   #plotOutput("prevalenza")
                                 )
                               )
            ),
                                       



tabPanel("Database",
         
         fluidPage(
           fluidRow(   
             DT::dataTableOutput("dt")
                   ) 
                  )
        )
)

