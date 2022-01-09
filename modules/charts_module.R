library(shiny)
library(shiny.semantic)
library(echarts4r)
library(tidyverse)
library(plotly)

#loading app data
df<-use("constants.R")

#loading chart data
monthly_occurence<-df$app_df$monthly_data
yearly_occurence<-df$app_df$yearly_data
yearly_occurence$year<-as.Date(as.character(yearly_occurence$year), format = "%Y")
monthly_occurence$month<-fct_relevel(monthly_occurence$month,c("January","February","March",
                                                               "April","May", "June","July",
                                                               "August","September","October",
                                                               "November", "December"))



#UI module
chartui<-function(id){
  ns<-NS(id)
  
  #chart UI
  tags$div(
    class="ui grid",
    tags$div(
      class="two column row",
      tags$div(
        h4( class="ui black header","Occurence per month"),
        class="eight wide column",
        tags$div(class="ui raised segment",
                 plotlyOutput(ns("month")),height=450)
      ),
      tags$div(
        h4( class="ui black header","Occurence per year"),
        class="eight wide column",
        tags$div(class="ui raised segment",
                 plotlyOutput(ns("year"),height=450))
      )
    )
    
  )
}

#server module
chartserver<-function(id){
  moduleServer(id, function(input, output,session){
    
    output$month<-renderPlotly({
       ggplotly(monthly_occurence %>%
         ggplot(aes(x=month, y=occurence))+
           geom_col(fill="blue")+
           labs(x="Month",y="Occurence")+
           theme_classic()+
           theme(
             axis.text.x = element_text(angle = 45),
             panel.background = element_blank()
           )
       )
    })
    
    output$year<-renderPlotly({
      ggplotly(yearly_occurence %>%
        ggplot(aes(x=year,y=occurence))+
          geom_line(color="blue")+
          labs(x="Year",y="Occurence")+
          theme_classic()
          
      )
    })
    
  })
}
