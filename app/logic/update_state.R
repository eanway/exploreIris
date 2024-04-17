update_state <- function(
    df_states, current_state, label, species, var_x, var_y) {
  box::use(
    dplyr[bind_rows, mutate, case_match]
  )

  if (current_state == label) {
    df_updated_states <- df_states |>
      mutate(
        species = case_match(
          label,
          current_state ~ species,
          .default = species
        ),
        var_x = case_match(
          label,
          current_state ~ var_x,
          .default = var_x
        ),
        var_y = case_match(
          label,
          current_state ~ var_y,
          .default = var_y
        )
      )

    return(df_updated_states)
  }

  df_new_state <- data.frame(
    label = label, species = species, var_x = var_x, var_y = var_y
  )

  df_states |>
    bind_rows(df_new_state)
}
