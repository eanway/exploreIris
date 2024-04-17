update <- function(
    df_states, new_label, new_species, new_var_x, new_var_y) {
  box::use(
    dplyr[bind_rows, mutate, case_match]
  )

  if (new_label %in% df_states$label) {
    df_updated_states <- df_states |>
      mutate(
        species = case_match(
          label,
          new_label ~ new_species,
          .default = species
        ),
        var_x = case_match(
          label,
          new_label ~ new_var_x,
          .default = var_x
        ),
        var_y = case_match(
          label,
          new_label ~ new_var_y,
          .default = var_y
        )
      )

    return(df_updated_states)
  }

  df_new_state <- data.frame(
    label = new_label, species = new_species,
    var_x = new_var_x, var_y = new_var_y
  )

  df_states |>
    bind_rows(df_new_state)
}

read <- function(df_states, state, value) {
  box::use(
    dplyr[filter, pull],
    utils[head],
  )

  df_states |>
    filter(label == state) |>
    pull({{ value }}) |>
    # in case there are multiple values, but that shouldn't be possible
    # because the state addition and updating are in the same function / event
    head(1)
}


delete <- function(df_states, state) {
  box::use(
    dplyr[filter]
  )

  df_states |>
    filter(label != state)
}

