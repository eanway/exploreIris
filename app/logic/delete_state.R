delete_state <- function(df_states, state) {
  box::use(
    dplyr[filter]
  )

  df_states |>
    filter(label != state)
}
