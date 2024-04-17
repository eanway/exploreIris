select_data <- function(df_data, species, var_x, var_y) {
  box::use(
    dplyr[filter, select],
    rlang[sym]
  )

  df_data |>
    filter(Species == !!species) |>
    select(x = !!sym(var_x), y = !!sym(var_y))
}
