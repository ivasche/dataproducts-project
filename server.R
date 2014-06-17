# Loading required packages
library(shiny)
library(XML)

# Reading and cleaning country data with average male and female BMI from Wiki
url<-"http://en.wikipedia.org/wiki/Body_mass_index"
table<-readHTMLTable(url)[[7]]
table<-table[,!grepl("Relative|Ratio|Average",names(table))]
table<-table[1:177,]
names(table)<-c("Country","Male","Female")
table$Country<-as.character(table$Country)
table$Male<-as.numeric(as.character(table$Male))
table$Female<-as.numeric(as.character(table$Female))

# Calculating BMI for specified inputs and drawing a plot with country averages
shinyServer(
      function(input, output) {
            output$text1<-renderText({
                  input$go
                  if (input$go == 0) "Please choose parameters on the left"
                  else isolate(paste("Your BMI (dashed line) is",
                                     round(input$weight/(input$height^2),2)
                                     )
                              )
                  })
            output$text2<-renderText({
                  input$go
                  if (input$go == 0) ""
                  else isolate(paste("Average",
                                input$sex,
                                "BMI in",
                                input$country,
                                "is",
                                as.numeric(subset(
                                      table,
                                      table$Country==input$country,
                                      input$sex))
                                    )
                              )
                  })
            output$plot1<-renderPlot({
                  if (input$go == 0) {return()}
                  else {fun<-function(){
                              x<-subset(table,select=input$sex)
                              x$Country<-table$Country
                              x<-x[order(x[,1],decreasing=F),]
                              cols<-c("blue","red")
                              cols<-cols[(!x$Country==input$country)+1]
                              par(mar=c(2,12,2,0))
                              barplot(x[,1],
                                      bg="transparent",
                                      yaxs="i",
                                      border=F,
                                      horiz=T,
                                      col=cols,
                                      names.arg=x$Country,
                                      axisnames=T,
                                      las=1,
                                      main="",
                                      cex.names=0.8,
                                      cex.axis=0.8)
                              title(main=paste("Average",input$sex,"BMI"))
                              abline(v=input$weight/(input$height^2),col=4,lty=2)
                        }
                        isolate(fun())
                  }            
            },height=1600,width=800)
      }
)