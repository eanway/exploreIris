box::use(
  shiny[NS, plotOutput, tabPanel]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tabPanel(
    "Correlation",
    plotOutput(ns("plot"))
  )
}

box::use(
  shiny[moduleServer, renderPlot, reactive]
)

box::use(
  app/logic/plot_correlation[plot_correlation]
)

#' @export
server <- function(
    id, rct_df_selected, rct_var_x, rct_var_y, rct_correlation_coef) {
  moduleServer(id, function(input, output, session) {
    rct_gg_plot <- reactive({
      rct_df_selected() |>
        plot_correlation(rct_var_x(), rct_var_y(), rct_correlation_coef())
    })

    output$plot <- renderPlot(rct_gg_plot())
  })
}
