box::use(
  DT[DTOutput],
  shiny[NS],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  DTOutput(ns("data"))
}

box::use(
  DT[renderDataTable],
  shiny[moduleServer],
)

#' @export
server <- function(id, rct_df_data) {
  moduleServer(id, function(input, output, session) {
    output$data <- renderDataTable(rct_df_data())
  })
}
