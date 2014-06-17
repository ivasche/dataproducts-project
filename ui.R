# Loading required packages
library(shiny)
library(XML)

# Reading and cleaning country data with average male and female BMI from Wiki
url<-"http://en.wikipedia.org/wiki/Body_mass_index"
table<-readHTMLTable(url)[[7]]
table<-table[,!grepl("Relative|Ratio|Average",names(table))]
table<-table[1:177,]
names(table)<-c("country","male","female")
table$country<-as.character(table$country)
table$male<-as.numeric(as.character(table$male))
table$female<-as.numeric(as.character(table$female))

# Defining shiny UI
shinyUI(pageWithSidebar(
      headerPanel("Body Mass Index comparison"),
      sidebarPanel(
            selectInput("country", "Choose your country:",
                        as.list(table$country)),
            selectInput("sex", "Choose your sex:",
                        list("Male","Female")),
            numericInput("weight", "Type your weigth in kilograms",
                         80,min=1,step=1),
            numericInput("height", "Type your heigth in meters",
                         1.80,min=0.01,step=0.01),
            actionButton("go", "Calculate")
      ),
      mainPanel(textOutput("text1"),
                textOutput("text2"),
                plotOutput("plot1",width="100%",height="100%")
      )
))