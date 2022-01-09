library(shiny)
library(shiny.semantic)
library(shinyWidgets)
library(utils)
library(htmlwidgets)


df<-use("constants.R")

#loading data
table_data<-df$app_df$table_data
map_data<-df$app_df$map_data


#search UI module
searchui<-function(id){
  ns<-NS(id)
  
  ##semantic UI
  tags$div(
    class="ui grid",
    tags$div(
      class="two column row",
      
      tags$div(
        class="column",
        selectizeInput(ns("scientific"),h4("Select Scientific name:"),
                       choices =NULL)
      ),
      tags$div(
        class="column",
        selectizeInput(ns("vernacular"),h4("Vernacular name:"),
                       choices =NULL)
      )
    ),
    tags$div(
      class="two column row",
      
      tags$div(
        h4( class="ui black header","Species Data"),
        class="eight wide column",
        tags$div(class="ui raised segment",
                 dataTableOutput(ns("table")),height=450)
      ),
      tags$div(
        h4( class="ui black header","Map"),
        class="eight wide column",
        tags$div(class="ui raised segment",
        leafletOutput(ns("map"),height=450))
      )
    )
   
  )
}

#server module
searchserver<-function(id){
  moduleServer(id, function(input, output,session){
  
    #search choices
    vernacular_name<-df$vernacular_name
    scientific_name<-df$scientific_name
    
    #reactive function for scientific names
    scientific_react<-reactive({
      map_data %>% filter(scientificName==input$scientific)
    }) %>% bindCache(input$scientific)
    
    #server side selectizeinput
    updateSelectizeInput(session,"scientific",choices =scientific_name)
    
    #updating vernacular name based on scientific name
    observeEvent(input$scientific,{
      updateSelectizeInput(session, "vernacular", choices = unique(scientific_react()$vernacularName))
    })
    
    #data table rendering
    output$table<-renderDataTable(
      scientific_react(),
      options = list(dom = 'ft', deferRender = TRUE, scrollY = "55vh",scrollX = "55vh", scroller = TRUE)
    )
    
    #map rendering
    output$map<-renderLeaflet(
      leaflet() %>%
        addTiles(group = "OSM (default)") %>%
        addProviderTiles(providers$Stamen.TonerLite, group = "Toner") %>% 
        addProviderTiles(providers$Esri.WorldStreetMap, group = "WorldStreetMap") %>% 
        addProviderTiles(providers$Esri.WorldImagery, group = "WorldImagery") %>% 
        addProviderTiles(providers$Esri.NatGeoWorldMap, group = "NatGeoWorldMap") %>% 
        addCircleMarkers(
          data = scientific_react(),
          fillOpacity = 0.7,
          fillColor = "blue",
          radius = 6,
          stroke = FALSE,
          lat = ~lat,
          lng = ~lon,
          label=paste(
            "<strong>Scientific name: </strong>",scientific_react()$scientificName,"<br>",
            "<strong>Vernacular name: </strong>",scientific_react()$vernacularName,"<br>",
            "<strong>Observation: </strong>",scientific_react()$observation,"<br>"
          ) %>% lapply(htmltools::HTML), labelOptions = labelOptions( style = list("font-weight" = "normal", 
                                                                                   padding = "3px 8px"), 
                                                                      textsize = "10px", direction = "auto")
        ) %>%
            addLayersControl(baseGroups = c("OSM (default)", "Toner", "WorldStreetMap", 
                                            "WorldImagery", "NatGeoWorldMap"),
                             position = "topright") 
        )
  })
}
