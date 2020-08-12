

ui <- dashboardPage(
  dashboardHeader(title = "MonitorMilk"),
  dashboardSidebar(
    sidebarMenu(
      
      menuItem("Situazione Generale", tabName = "overview", icon = icon("dashboard")),
      
      menuItem("Situazione aziendale", tabName="az", icon=icon("th")),

      menuItem("Base dati", tabName="dati", icon = icon("edit")), 
      hr(),
# helpText(tags$strong("dati aggiornati al:", format(max(latte$dtprel),"%d-%m-%Y") , style="color:red")),
helpText(tags$strong("dati aggiornati al:", "31-12-2019" , style="color:red")),


hr()
      
      )
    
  ),

dashboardBody(
 tabItems(
    #####primo tab item#####
     tabItem(
     tabName = "overview",
         fluidPage(
   fluidRow(
     valueBoxOutput("year"),
     
     div(id='clickdiv0',
     valueBoxOutput("aziende")),
     bsModal("AZ", "Aziende controllate", "clickdiv0",tableOutput("taz"), size = "large"),
     
     
     div(id='clickdiv13',
     valueBoxOutput("is")),
     bsModal("ins", "I.S", "clickdiv13",tableOutput("tIS"), size = "large")
     
     
     
     
     ),
   
   hr(),
   hr(),
   
   fluidRow( 
     h3("Parametri Qualità Latte", align = "center"),
     div(id='clickdiv',
     valueBoxOutput("prot")),
     bsModal("p", "Proteine", "clickdiv",plotOutput("pr"), size = "large"),
     
     div(id='clickdiv2',
     valueBoxOutput("grasso")),
     bsModal("g", "Grasso", "clickdiv2",plotOutput("gr"), size = "large"),
     
     div(id='clickdiv3',
     valueBoxOutput("lattosio")),
     bsModal("l", "Lattosio", "clickdiv3",plotOutput("ls"), size = "large"),
     
     div(id='clickdiv3a',
         valueBoxOutput("urea")),
     bsModal("u", "Urea", "clickdiv3a",plotOutput("ur"), size = "large"),
     
     
     div(id='clickdiv4',
     valueBoxOutput("css")),
     bsModal("cs", "Cellule Somatiche", "clickdiv4",plotOutput("cel"), size = "large"),

     div(id='clickdiv5',
     valueBoxOutput("cbt")),
     bsModal("cr", "CBT", "clickdiv5",plotOutput("car"), size = "large")
   ),
     
     hr(),hr(),
   fluidRow(   
     h3("Parametri Sanitari", align = "center"),
     div(id='clickdiv7',
         valueBoxOutput("stg")),
     bsModal("strg", "Str.agalactiae", "clickdiv7",plotOutput("gstg"), size = "large"),
     
     
     div(id='clickdiv8',
         valueBoxOutput("stf")),
     bsModal("stau", "Staf.aureus", "clickdiv8",plotOutput("gstf"), size = "large"),
     
     div(id='clickdiv11',
         valueBoxOutput("protho")),
     bsModal("Protho", "Prototheca spp", "clickdiv11",plotOutput("gprotho"), size = "large"),
     
     div(id='clickdiv6',
     valueBoxOutput("ibr")),
     bsModal("bhv", "IBR", "clickdiv6",plotOutput("gibr"), size = "large"),

     div(id='clickdiv9',
     valueBoxOutput("fbq")),
     bsModal("Fq", "Febbre Q", "clickdiv9",plotOutput("gfbq"), size = "large"),
  
     
     div(id='clickdiv10',
         valueBoxOutput("myc")),
     bsModal("Myc", "Mycoplasma bovis", "clickdiv10",plotOutput("gmyc"), size = "large"), 
     
     div(id='clickdiv12',
         valueBoxOutput("bvd")),
     bsModal("Bvd", "BVD", "clickdiv12",plotOutput("gbvd"), size = "large")
     )
     

      )
  ),
  #####secondo tab item########
   ###primo subitem----qualitativi###
  tabItem(
     tabName = "az",
            fluidRow(
          
                   box(solidHeader = TRUE, width = 4,

              selectInput("cod", "Codice Allevix",
                                   c(unique(as.character(latte$codaz))))
            
            ), 

            div(id='clickdiv14',
            valueBoxOutput("IS")),
            bsModal("cIS", "IS cumulativo", "clickdiv14",plotOutput("gCis"), size = "large")
            
           
              ), 
     hr(),
     br(),
     fluidRow(
       tableOutput("info") ,
       hr(),
       br(),
   
       tableOutput("tquant"),
  
       hr(),
       br(),
       tableOutput("tq")
       
       
     )
     ),
         
  
   
   
    
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
  

