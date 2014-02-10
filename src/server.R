library(shiny)
#library(windtools)

#set default db as src
#db<-'/home/natalie/test/src.sqlite'

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  # Compute the forumla text in a reactive expression since it is 
  # shared by the output$caption and output$mpgPlot expressions
  
  formulaText <- reactive({
    paste("Wind Speed: ")
    #paste("Wind Speed: ", input$variable)
  })
  formulaText1 <- reactive({
    paste("Site Location: ", input$site)
  })

  # Return the formula text for printing as a caption
  output$caption1 <- renderText({
    formulaText1()
  })
  
  output$caption <- renderText({
    formulaText()
  })

  # Generate a plot of the requested sensor speed 
  #output$speedPlot <- renderPlot({
  #  s<-subset(d, subset=(plot==input$variable))
  #  p<-plotSensorSpeed(d, input$variable)
  #  print(p)
  #})
  
  output$speedPlot <- renderPlot({
    #if(input$site == 'SRC'){
      #db<-'/home/natalie/test/src.sqlite'
    #}
    #else if(input$site == 'BSB'){
      #db<-'/home/natalie/test/bsb.sqlite'
    #}
   library(ggplot2)
   db<-'/home/natalie/test/src.sqlite'
   start_time = '2011-08-15 06:00:00'
   end_time = '2011-08-20 06:00:00'
   data<-dbFetchAll(db, start_time, end_time)
   
   s<-subset(data, subset=(plot_id=='K2'))
   
   s$date_time2<-as.POSIXct(strptime(s[,"date_time"], '%Y-%m-%d %H:%M:%S'))

   p<-ggplot(s, aes(x=date_time2, y=wind_speed)) + 
      geom_point(shape=19, size=1.5, color='blue') + 
      theme_bw() +
      xlab("Time") + 
      ylab("Observed Speed (m/s)")
  
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
  

})


