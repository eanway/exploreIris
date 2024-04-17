box::use(
  shiny[
    actionButton, fluidPage, mainPanel, NS, sidebarLayout, sidebarPanel,
    textInput, selectInput
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
        actionButton(ns("delete_state"), "Delete current state"),
        select$ui(ns("state"), "a state to load")
      ),
      mainPanel(
        plot$ui(ns("plot"))
      )
    )
  )
}

box::use(
  shiny[
    moduleServer, reactive, reactiveValues, observe, bindEvent, validate, need,
    updateTextInput, updateSelectInput
  ],
  datasets[iris]
)

box::use(
  app/logic/get_column[get_column],
  app/logic/select_data[select_data],
  app/logic/get_columns[get_columns],
  app/logic/get_correlation[get_correlation],
  app/logic/update_state[update_state],
  app/logic/get_state_value[get_state_value],
  app/logic/delete_state[delete_state]
)

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    rct_df_data <- reactive({iris})

    # initialize empty states
    rctVal_states <- reactiveValues(
      df_states = data.frame(
        label = character(0), species = character(0),
        var_x = character(0), var_y = character(0)
      )
    )

    # populate existing states
    rct_vec_states <- reactive({
      rctVal_states$df_states |>
        get_column(label)
    })

    # update existing states

    rct_state <- select$server("state", rct_vec_states, reactive(input$label))

    # update state label
    rct_state_label <- reactive({
      rctVal_states$df_states |>
        get_state_value(rct_state(), label)
    })

    observe({
      updateTextInput(
        inputId = "label", value = rct_state_label()
      )
    }) |>
      bindEvent(rct_state())

    # species
    rct_vec_species <- reactive({
      rct_df_data() |>
        get_column(Species)
    })

    # species - update state
    rct_state_species <- reactive({
      rctVal_states$df_states |>
        get_state_value(rct_state(), species)
    })

    # species - get selected value
    rct_species <- select$server("species", rct_vec_species, rct_state_species)

    # columns
    rct_vec_columns <- reactive({
      rct_df_data() |>
        get_columns()
    })

    # columns - update state
    rct_state_var_x <- reactive({
      rctVal_states$df_states |>
        get_state_value(rct_state(), var_x)
    })

    rct_state_var_y <- reactive({
      rctVal_states$df_states |>
        get_state_value(rct_state(), var_y)
    })

    # columns - get selected value
    # can select the same column twice
    # could add observe to update and remove duplicate option
    rct_var_x <- select$server("variable_x", rct_vec_columns, rct_state_var_x)

    rct_var_y <- select$server("variable_y", rct_vec_columns, rct_state_var_y)

    # add or update state
    observe({
      rctVal_states$df_states <- rctVal_states$df_states |>
        update_state(
          input$label, rct_species(), rct_var_x(), rct_var_y()
        )
    }) |>
      bindEvent(input$save_state)

    # delete state
    observe({
      rctVal_states$df_states <- rctVal_states$df_states |>
        delete_state(rct_state())
    }) |>
      bindEvent(input$delete_state)

    observe({
      updateTextInput(
        inputId = "label", value = NULL
      )
    }) |>
      bindEvent(input$delete_state)

    # plotting
    rct_df_selected <- reactive({
      validate(
        need(rct_species(), "Please select a species"),
        need(rct_var_x(), "Please select an X variable"),
        need(rct_var_y(), "Please select a Y variable")
      )

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
