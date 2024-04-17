box::use(
  shiny[NS, selectInput],
  glue[glue]
)

#' @export
ui <- function(id, str_selection) {
  ns <- NS(id)

  selectInput(
    ns("selection"), glue("Please select {str_selection}"),
    NULL
  )
}

box::use(
  shiny[bindEvent, moduleServer, observe, reactive, updateSelectInput]
)

#' @export
server <- function(id, rct_vec_choices, rct_state_selected) {
  moduleServer(id, function(input, output, session) {

    observe({
      updateSelectInput(
        inputId = "selection",
        choices = rct_vec_choices(),
        selected = rct_state_selected()
      )
    }) |>
      bindEvent(rct_vec_choices(), rct_state_selected())

    reactive({input$selection})
  })
}
