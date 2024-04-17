get_correlation <- function(df_data) {
  box::use(
    stats[cor]
  )

  with(
    df_data,
    cor(x, y)
  )
}
