library(shiny)
library(plotly)

df <- read.csv("Data.csv", stringsAsFactors = FALSE) 
df$Year <- as.Date(ISOdate(df$Year,12,31))

shinyUI (fluidPage(
        
        titlePanel("Oman Education Statistics"),
        sidebarLayout(
                sidebarPanel(
                        helpText("This application will help you get main education statistics in Oman between 2002-2015.
                                 Selecting required indicator, four choices, and the desired region three interactive charts 
                                 will be displayed; Total Education for Basic versus General systems, and two genders based charts.
                                 Detailed figures can reveal by pointing the mouse pointer in the charts. 
                                 Also, two tables of 2015 students/class and students/teacher ratios at the bottom 
                                 to understand average loads for these indicators."),
                        selectInput("indicatorInput", "Choose indicator", choices = c( "No. of Classes","No. of Schools",
                                                                                       "No. of Students","No. of Teachers")),
                        selectInput("regionInput", "Region", choices = c( "Muscat","Dhofar","Musandam","Al Buraymi",
                                                                          "Ad Dakhliyah","Al Batinah North","Al Batinah South",
                                                                          "Ash Sharqiyah South","Ash Sharqiyah North","Adh Dhahirah",
                                                                          "Al Wusta"))
                        
                        ),
                
                mainPanel(
                        plotlyOutput("plot1"),
                        br(), br(),
                        plotlyOutput("plot2"),
                        h3(c("2015 Average No. of;")),
                        fluidRow(
                                splitLayout(cellWidths = c("50%", "50%"),tableOutput("pred1"), tableOutput("pred2") )
                        ),
                        br(),
                        p("Data obtained from National Center for Statistical Information (NCSI) Data Portal, visit the ",
                          a("NCSI homepage.",
                            href = "https://www.ncsi.gov.om"))
                        
                        
                       
                       
                        
                )
        )
))