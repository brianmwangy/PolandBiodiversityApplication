
library(shiny)
library(shiny.semantic)
library(leaflet)
library(rsconnect)
library(readr)

poland_data<-read_csv("./www/poland.csv")
# Define UI for application 
ui <- semanticPage(
  h2( class="ui blue header","Poland Biodiversity Application"),
  div(class="ui divider"),
  
  ##############grid UI layout############
  tags$div(
    class="ui grid",
    tags$div(
      class="two column row",
      
      ###############search UI###############
      tags$div(
        class="column",
        uiOutput("search_names"),
        p("Selected species:"),
        textOutput("selected_species")
        
      )
    )
)
)
#### Define server 
server <- function(input, output,session) {
  vernacular_name <- unique(poland_data$vernacularName)
  scientific_name <- unique(poland_data$scientificName)
  output$search_names <- shiny::renderUI(
    search_selection_choices("search_result", scientific_name, value = "Grus grus", multiple = TRUE, groups = vernacular_name))
  output$selected_species <- renderText(input[["search_result"]])
}

# Run the application 
shinyApp(ui = ui, server = server)
