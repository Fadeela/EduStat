library(ggplot2)
library(dplyr)

shinyServer (function(input, output, session){
        
        df <- read.csv("Data.csv", stringsAsFactors = FALSE) 
        df$Year <- as.Date(ISOdate(df$Year,12,31))
        
        data1 <- reactive ({
        
                 df %>%
                        filter(df$Region == input$regionInput, 
                               df$Indicator == input$indicatorInput) 
        })
        output$plot1 <- renderPlotly({
          
                 plot_ly(data = data1(), x = ~Year) %>% add_lines(y = ~Total.Basic.Education, name = "Basic Education") %>%
                        add_lines(y=~Total.General.Education, name = "General Education", type = "scatter") %>%
                        layout(title = paste(input$indicatorInput,"<br>","Basic Vs. General Total Education in",input$regionInput), xaxis = list(title = "Date"), yaxis = list(title = input$indicatorInput), 
                               legend = list(orientation = 'h'), margin = c(0,0.2,.1,.1)) 
               
        })
        output$plot2 <- renderPlotly({
           
                p1 <-   if(all(is.na(data1()[,6])) == TRUE) {
                        plot_ly(data = data1(), x = ~Year) %>% add_trace(y = ~Female.Total, name = "Female Schools") %>%
                                layout(xaxis = list(title = "Date"), yaxis = list(title = input$indicatorInput),legend = list(orientation = 'h'),
                                        margin = c(0,0.2,.1,0))
                } else if (all(is.na(data1()[,6])) == FALSE) {
                        plot_ly(data = data1(), x = ~Year) %>% add_trace(y = ~Female.Basic.Education, name = "Female Basic Education",type = 'bar') %>%
                                add_trace(y=~Female.General.Education, name = "Female General Education", type = "bar") %>%
                                layout(xaxis = list(title = "Date"),yaxis = list(title =input$indicatorInput), barmode = "group",
                                       legend = list(orientation = 'h'), margin = c(0,0.2,.1,0))
                } 
                
                p2 <- if(all(is.na(data1()[,8])) == TRUE) {
                        plot_ly(data = data1(), x = ~Year) %>% add_trace(y = ~Male.Total, name = "Male Schools") %>%
                                layout(xaxis = list(title = "Date"),legend = list(orientation = 'h'), margin = c(0,0.2,.1,0))
                } else if (all(is.na(data1()[,8])) == FALSE) {
                        plot_ly(data = data1(), x = ~Year) %>% add_trace(y = ~Male.Basic.Education, name = "Male Basic Education", type = 'bar') %>%
                                add_trace(y=~Male.General.Education, name = "Male General Education", type = "bar") %>%
                                layout(barmode = "group",legend = list(orientation = 'h'), margin = c(0,0.2,.1,0))
                } 
                
                subplot(p1, p2, shareX = TRUE, shareY = TRUE) %>%
                        layout(title = paste(input$indicatorInput,"Basic Vs. General Gender based Education in", input$regionInput))
                
        })
        
        
        students <- reactive ({
                text1 <- df %>% filter(df$Region == input$regionInput,
                                       df$Indicator == "No. of Students")
                
                text2 <- df %>% filter(df$Region == input$regionInput,
                                       df$Indicator == "No. of Classes")

                Variable <- c("Basic Education - Female", "Basic Education - Male","General Education - Female", "General Education - Male" )
                Students.Per.Class <- c(round((text1$Female.Basic.Education[text1$Year=="2015-12-31"])/(text2$Female.Basic.Education[text2$Year=="2015-12-31"]),0),
                                       round((text1$Male.Basic.Education[text1$Year=="2015-12-31"])/(text2$Male.Basic.Education[text2$Year=="2015-12-31"]),0),
                                       round((text1$Female.General.Education[text1$Year=="2015-12-31"])/(text2$Female.General.Education[text2$Year=="2015-12-31"]),0), 
                                       round((text1$Male.General.Education[text1$Year=="2015-12-31"])/(text2$Male.General.Education[text2$Year=="2015-12-31"]),0))
                
                if(input$indicatorInput == "No. of Classes") {
                       data.frame(cbind(Variable,Students.Per.Class)) 
                }       else return("Not Applicable") 

                })
        
        teachers <- reactive({
                text3 <- df %>% filter(df$Region == input$regionInput,
                                       df$Indicator == "No. of Students")
                text4 <- df %>% filter(df$Region == input$regionInput,
                                       df$Indicator == "No. of Teachers")
                
                if(input$indicatorInput == "No. of Teachers") {
                

                Variable <- c("Basic Education - Female", "Basic Education - Male","General Education - Female", "General Education - Male" )
                Students.Per.Teacher <- c(round((text3$Female.Basic.Education[text3$Year=="2015-12-31"])/(text4$Female.Basic.Education[text4$Year=="2015-12-31"]),0),
                                          round((text3$Male.Basic.Education[text3$Year=="2015-12-31"])/(text4$Male.Basic.Education[text4$Year=="2015-12-31"]),0),
                                          round((text3$Female.General.Education[text3$Year=="2015-12-31"])/(text4$Female.General.Education[text4$Year=="2015-12-31"]),0), 
                                          round((text3$Male.General.Education[text3$Year=="2015-12-31"])/(text4$Male.General.Education[text4$Year=="2015-12-31"]),0))
                
                
                        data.frame(cbind(Variable,Students.Per.Teacher)) 
                              
                }       else return("Not Applicable") 

        })
        
        
        output$pred1 <- renderTable({
                students()
              
        })

        output$pred2 <- renderTable({
                teachers()
                })      
})
