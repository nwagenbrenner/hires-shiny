library(shiny)
#library(windtools)

#set default db as src
library('RSQLite')
db<-'/home/natalie/test/src.sqlite'
start_time = '2011-08-15 06:00:00'
end_time = '2011-08-20 06:00:00'

con <- dbConnect('SQLite', dbname = db)
    
sql <- paste0("SELECT * FROM mean_flow_obs ", 
            "WHERE Date_time BETWEEN '", start_time, "' ", "AND '", end_time, "' ",
            "AND Quality='OK'", collapse="")
            
res <- dbSendQuery(con, statement = sql)
data <- fetch(res, n = -1) #fetch all data
dbClearResult(res)
dbDisconnect(con)

#data<-dbFetchAll(db, start_time, end_time)

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("High-resolution Wind Data Access for Big Southern Butte and Salmon River Canyon"),

  sidebarPanel(
    selectInput("site", "Site:",
                list("BSB" = "BSB", 
                     "SRC" = "SRC")),
    
    selectInput('variable', 'Sensor', unique(data$plot_id)),

                     
    #selectInput("variable", "Sensor:",
    #            list("R2" = "R2", 
    #                 "TSW8" = "TSW8", 
    #                 "R5" = "R5")),

    checkboxInput("outliers", "Show suspect data", FALSE)
  ),

  # Show the caption and plot of the requested variable against speed
  mainPanel(
    h3(textOutput("caption1")),
  
    h3(textOutput("caption"))

    #plotOutput("speedPlot")
    
  )
))


