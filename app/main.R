box::use(
  shiny[fluidPage, mainPanel, NS, sidebarLayout, sidebarPanel],
)

box::use(
  app/view/select,
  app/view/plot,
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  fluidPage(
    sidebarLayout(
      sidebarPanel(
        select$ui(ns("species"), "a species"),
        select$ui(ns("variable_x"), "an X variable"),
        select$ui(ns("variable_y"), "a Y variable")
      ),
      mainPanel(
        plot$ui(ns("plot"))
      )
    )
  )
}

box::use(
  shiny[moduleServer, reactive],
  datasets[iris]
)

box::use(
  app/logic/get_species[get_species],
  app/logic/select_data[select_data],
  app/logic/get_columns[get_columns],
  app/logic/get_correlation[get_correlation],
)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    rct_df_data <- reactive({iris})

    rct_vec_species <- reactive({
      rct_df_data() |>
        get_species()
    })

    rct_vec_columns <- reactive({
      rct_df_data() |>
        get_columns()
    })

    rct_species <- select$server("species", rct_vec_species)

    # can select the same column twice
    # could add observe to update and remove duplicate option
    rct_var_x <- select$server("variable_x", rct_vec_columns)

    rct_var_y <- select$server("variable_y", rct_vec_columns)

    rct_df_selected <- reactive({
      rct_df_data() |>
        select_data(rct_species(), rct_var_x(), rct_var_y())
    })

    rct_correlation_coef <- reactive({
      rct_df_selected() |>
        get_correlation()
    })

    plot$server(
      "plot", rct_df_selected, rct_var_x, rct_var_y, rct_correlation_coef
    )
  })
}
