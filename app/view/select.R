box::use(
  shiny[NS, selectInput]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  selectInput(
    ns("selection"), "Please select a species", "Loading, please wait"
  )
}

box::use(
  shiny[bindEvent, moduleServer, observe, reactive, updateSelectInput]
)

#' @export
server <- function(id, rct_vec_choices) {
  moduleServer(id, function(input, output, session) {

    observe({
      updateSelectInput(
        inputId = "selection",
        choices = rct_vec_choices()
      )
    }) |>
      bindEvent(rct_vec_choices())


    reactive({input$selection})
  })
}
