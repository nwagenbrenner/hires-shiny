library(shiny)

# Define UI for high-res wind application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("High-resolution Wind Data Access"),

  sidebarPanel(
    selectInput("site", "Choose a site:",
                list("BSB" = "BSB", 
                     "SRC" = "SRC")),
    
    htmlOutput("selectUI"),

    checkboxInput("vectorPlot", "Create a vector plot (not active)", FALSE),
   
    htmlOutput("setDates"),

    downloadButton('downloadData', 'Download')
  ),

  # Show the caption and plot of the requested variable against speed
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("speedPlot")), 
      tabPanel("Summary", verbatimTextOutput("summary")), 
      tabPanel("Table", tableOutput("table"))
    )
        
    #h3(textOutput("caption"))
    
    )
    
  ))


