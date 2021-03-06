library(shiny)
library(miniUI)
library(leaflet)

ui <- miniPage(
  gadgetTitleBar("Shiny gadget example"),
  miniContentPanel(padding = 0,
    leafletOutput("map", height = "100%")
  ),
  miniButtonBlock(
    actionButton("reset", "Reset bounds")
  )
)

server <- function(input, output, session) {
  output$cars <- renderPlot({
    require(ggplot2)
    ggplot(cars, aes(speed, dist)) + geom_point()
  })

  output$map <- renderLeaflet({
    leaflet(quakes, height = "100%") %>% addTiles() %>% addMarkers()
  })

  output$table <- DT::renderDataTable({
    diamonds
  })

  observeEvent(input$done, {
    stopApp(TRUE)
  })

  observeEvent(input$reset, {
    leafletProxy("map", data = quakes) %>% fitBounds(
      ~min(long), ~min(lat),
      ~max(long), ~max(lat)
    )
  })
}

runGadget(ui, server, viewer = paneViewer())
#' @examples
#' options(shiny.autoreload=TRUE)
#' shiny::runApp("test2.R", launch.browser = getOption("viewer", TRUE))
