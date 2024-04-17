box::use(
  shiny[NS, plotOutput]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  plotOutput(ns("plot"))
}

box::use(
  shiny[moduleServer, renderPlot, reactive, validate, need]
)

box::use(
  app/logic/plot_correlation[plot_correlation]
)

#' @export
server <- function(
    id, rct_df_selected, rct_var_x, rct_var_y, rct_correlation_coef) {
  moduleServer(id, function(input, output, session) {
    rct_gg_plot <- reactive({
      validate(
        need(rct_var_x(), "Loading, please wait"),
        need(rct_var_y(), "Loading, please wait")
      )

      rct_df_selected() |>
        plot_correlation(rct_var_x(), rct_var_y(), rct_correlation_coef())
    })

    output$plot <- renderPlot(rct_gg_plot())
  })
}
