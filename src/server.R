library(shiny)
#library(windtools)

library('RSQLite')

db<-'/FVS/shiny-server/shinyWindTools/src.sqlite'
start_time = '2011-08-15 06:00:00'
end_time = '2011-08-20 06:00:00'

con <- dbConnect('SQLite', dbname = db)
sql <- paste0("SELECT * FROM mean_flow_obs ",
            "WHERE Date_time BETWEEN '", start_time, "' ", "AND '", end_time, "' ",
            "AND Quality='OK'", collapse="")
res <- dbSendQuery(con, statement = sql)
src <- fetch(res, n = -1) #fetch all data
dbClearResult(res)
dbDisconnect(con)

db<-'/FVS/shiny-server/shinyWindTools/bsb.sqlite'
start_time = '2010-08-15 06:00:00'
end_time = '2010-08-20 06:00:00'

con <- dbConnect('SQLite', dbname = db)
sql <- paste0("SELECT * FROM mean_flow_obs ",
            "WHERE Date_time BETWEEN '", start_time, "' ", "AND '", end_time, "' ",
            "AND Quality='OK'", collapse="")
res <- dbSendQuery(con, statement = sql)
bsb <- fetch(res, n = -1) #fetch all data
dbClearResult(res)
dbDisconnect(con)
colnames(bsb)<-c("plot_id", "date_time", "wind_speed", "wind_gust", "wind_dir", "qualtiy", "sensor_qual")

# Define server logic
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$mpgPlot expressions
  formulaText <- reactive({
    paste("Wind Speed: ", input$variable)
  })

  # Return the formula text for printing as a caption
  output$caption <- renderText({
    formulaText()
  })

  output$selectUI <- renderUI({ 
    if(input$site == 'SRC'){
      selectInput('variable', 'Choose a sensor:', unique(src$plot_id))
    }
    else if(input$site == 'BSB'){
      selectInput('variable', 'Choose a Sensor:', unique(bsb$plot_id))
    }
  })

  # Generate a plot of the requested sensor speed 
  output$speedPlot <- renderPlot({
     library(ggplot2)
     if(input$site == 'SRC'){
       s<-subset(src, subset=(plot_id==input$variable))
     }
     else if(input$site == 'BSB'){
       s<-subset(bsb, subset=(plot_id==input$variable))
     }
     s$date_time2<-as.POSIXct(strptime(s[,"date_time"], '%Y-%m-%d %H:%M:%S'))
     
     p<-ggplot(s, aes(x=date_time2, y=wind_speed)) + 
        geom_point(shape=19, size=1.5, color='blue') + 
        theme_bw() +
        xlab("Time") + 
        ylab("Observed Speed (m/s)") +
        ggtitle(input$variable)
  
     p<-p + scale_x_datetime(breaks=c(min(s$date_time2),
                       (max(s$date_time2) - min(s$date_time2))/4 + min(s$date_time2),
                       (max(s$date_time2) - min(s$date_time2))/4*2 + min(s$date_time2),
                       (max(s$date_time2) - min(s$date_time2))/4*3 + min(s$date_time2),
                       max(s$date_time2)))

     p <- p + theme(axis.text.x = element_text(angle = 45))
     p <- p + theme(axis.text.x = element_text(vjust = 0.5))

     p <- p + theme(axis.text = element_text(size = 14))
     p <- p + theme(axis.title = element_text(size = 14))
   
     print(p)
  })

  # Generate a summary of the data
  output$summary <- renderPrint({
    if(input$site == 'SRC'){
        s<-subset(src, subset=(plot_id==input$variable))
    }
    else if(input$site == 'BSB'){
        s<-subset(bsb, subset=(plot_id==input$variable))
    }
    summary(s)
  })

  # Generate an HTML table view of the data
  output$table <- renderTable({
    if(input$site == 'SRC'){
        s<-subset(src, subset=(plot_id==input$variable))
    }
    else if(input$site == 'BSB'){
        s<-subset(bsb, subset=(plot_id==input$variable))
    }
    data.frame(x=s)
  })
})


