box::use(
  shiny[fluidPage, mainPanel, NS, sidebarLayout, sidebarPanel],
)

box::use(
  app/view/data,
  app/view/select
)

box::use(
  app/logic/get_species[get_species],
  app/logic/select_data[select_data]
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  fluidPage(
    sidebarLayout(
      sidebarPanel(
        select$ui(ns("species"))
      ),
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

    rct_vec_species <- reactive({
      rct_df_data() |>
        get_species()
    })

    rct_species <- select$server("species", rct_vec_species)

    rct_df_selected <- reactive({
      rct_df_data() |>
        select_data(rct_species())
    })

    data$server(
      "data", rct_df_selected
    )
  })
}
