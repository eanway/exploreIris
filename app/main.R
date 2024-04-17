box::use(
  shiny[
    actionButton, fluidPage, mainPanel, NS, sidebarLayout, sidebarPanel,
    textInput
  ],
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
        select$ui(ns("variable_y"), "a Y variable"),
        textInput(ns("label"), "Label"),
        actionButton(ns("save_state"), "Save current state"),
        select$ui(ns("state"), "a label")
      ),
      mainPanel(
        plot$ui(ns("plot"))
      )
    )
  )
}

box::use(
  shiny[moduleServer, reactive, reactiveValues, observe, bindEvent],
  datasets[iris]
)

box::use(
  app/logic/get_column[get_column],
  app/logic/select_data[select_data],
  app/logic/get_columns[get_columns],
  app/logic/get_correlation[get_correlation],
  app/logic/update_state[update_state],
)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    rct_df_data <- reactive({iris})

    rctVal_states <- reactiveValues(
      df_states = data.frame(
        label = character(0), species = character(0),
        var_x = character(0), var_y = character(0)
      )
    )

    rct_vec_states <- reactive({
      rctVal_states$df_states |>
        get_column(label)
    })

    rct_state <- select$server("state", rct_vec_states)

    rct_vec_species <- reactive({
      rct_df_data() |>
        get_column(Species)
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

    observe({
      rctVal_states$df_states <- rctVal_states$df_states |>
        update_state(
          rct_state(), input$label, rct_species(), rct_var_x(), rct_var_y()
        )
    }) |>
      bindEvent(input$save_state)

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
