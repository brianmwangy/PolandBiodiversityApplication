
library(shiny)
library(shiny.semantic)
library(leaflet)
library(rsconnect)


# Define UI for application 
ui <- semanticPage(
  h2( class="ui blue header","Poland Biodiversity Application"),
  div(class="ui divider"),
  searchui("var"),
  chartui("charts")
)


#### Define server 
server <- function(input, output,session) {
  searchserver("var")
  chartserver("charts")
}

# Run the application 
shinyApp(ui = ui, server = server)
