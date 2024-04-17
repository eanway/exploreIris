get_column <- function(df_data, column) {
  box::use(
    dplyr[pull]
  )

  df_data |>
    pull({{ column }}) |>
    unique() |>
    sort()
}
