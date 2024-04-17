box::use(
  shiny[fluidPage, mainPanel, NS, sidebarLayout, sidebarPanel],
)

box::use(
  app/view/data
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  fluidPage(
    sidebarLayout(
      sidebarPanel(),
      mainPanel(
        data$ui(ns("data"))
      )
    )
  )
}

box::use(
  shiny[moduleServer, reactive],
  datasets[iris]
)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    rct_df_data <- reactive({iris})

    data$server(
      "data", rct_df_data
    )
  })
}
