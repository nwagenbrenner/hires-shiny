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

    #selectInput('variable', 'Sensor', unique(data$plot_id)),

    checkboxInput("outliers", "Show suspect data (not active)", FALSE),
    checkboxInput("vectorPlot", "Create a vector plot (not active)", FALSE),
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

    #plotOutput("speedPlot")
    
  )
))


