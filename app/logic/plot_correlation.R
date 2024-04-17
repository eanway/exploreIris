plot_correlation <- function(df_data, x_lab, y_lab) {
  box::use(
    ggplot2[aes, ggplot, geom_point, labs]
  )

  ggplot(df_data, aes(x = x, y = y)) +
    geom_point() +
    labs(title = "Correlation", x = x_lab, y = y_lab)
}
