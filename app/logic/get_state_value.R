get_state_value <- function(df_states, state, value) {
  box::use(
    dplyr[filter, pull],
    utils[head],
  )

  df_states |>
    filter(label == state) |>
    pull({{ value }}) |>
    head(1)
}
