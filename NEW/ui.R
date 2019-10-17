

ui <- dashboardPage(
  dashboardHeader(title = "MonitorMilk"),
  dashboardSidebar(
    sidebarMenu(
      
      menuItem("Situazione Generale", tabName = "overview", icon = icon("dashboard")),
      
      menuItem("Situazione aziendale", tabName="az", icon=icon("th"),
          menuSubItem("Parametri Qualitativi", tabName = "quali", icon = icon("th")),
          menuSubItem("Parametri Quantitativi", tabName = "quanti", icon = icon("th"))),
     
      menuItem("Base dati", tabName="dati", icon = icon("edit"))
      )
    
  ),
  dashboardBody(
    # tags$head(tags$style(HTML('
    #                           .modal-lg {
    #                           width: 88%;
    #                           
    #                           }
    #                           '))),
 tabItems(
    #####primo tab item#####
     tabItem(
     tabName = "overview",
         fluidPage(
   fluidRow(
    column(3,
     valueBoxOutput("aziende", width=NULL),
     valueBoxOutput("camp", width = NULL),
     valueBoxOutput("prot", width=NULL),
     valueBoxOutput("grasso", width=NULL),
     valueBoxOutput("lattosio", width=NULL),
     valueBoxOutput("css", width=NULL),
     valueBoxOutput("cbt", width=NULL)),
   
    
    
     column(8,
        selectInput("prova", "Andamento Parametri quantitativi nel gruppo di allevementi",
                    c(unique(as.character(subset(latte$prova, latte$prova2=="Quanti")))),"Cellule somatiche"),
           plotOutput("p1"), 
        
        br(),hr(),
        
        selectInput("quali", "Andamento Paramentri qualitativi nel gruppo di allevamenti",
                    c(unique(as.character(subset(latte$prova, latte$prova2=="Quali"))))),
        plotOutput("p2")
        
        )
 
      ))),
    
      #####secondo tab item########
   ###primo subitem----qualitativi###
    tabItem(
     tabName = "quali",
            fluidRow(
            
                   box(solidHeader = TRUE,
              
              selectInput("cod", "Codice Allevix",
                                   c(unique(as.character(latte$codaz))))
              
            )), 
     hr(),
     br(),
     fluidRow(
       DT::dataTableOutput("info"),
       hr(),
       tableOutput("tq")
       
     )
     ),
         
   ######secondo subitem---quantitativi----####•
   tabItem(
     tabName = "quanti",
     fluidRow(
       box(solidHeader = TRUE,
           selectInput("cod2", "Codice Allevix",
                      c(unique(as.character(latte$codaz))))
     )),
     hr(),
     br(),
     fluidRow(
       DT::dataTableOutput("info2"),
       hr(),
       tableOutput("tquant")

     )

   ),
   # 
   # 
   
   
    
    #   #####terzo tab item######
      tabItem(
        tabName = "dati",

        fluidRow(
      
              DT::dataTableOutput("dt")
          )
        )
      )
    )
)
  

