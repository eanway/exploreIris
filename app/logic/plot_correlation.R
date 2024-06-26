plot_correlation <- function(df_data, x_lab, y_lab, correlation_coef) {
  box::use(
    ggplot2[aes, ggplot, geom_point, geom_smooth, labs],
    glue[glue],
  )

  str_subtitle <- glue("Correlation Coefficient = {round(correlation_coef, 2)}")

  ggplot(df_data, aes(x = x, y = y)) +
    geom_point() +
    geom_smooth(method = "lm",formula = y ~ x) +
    labs(title = "Correlation", subtitle = str_subtitle, x = x_lab, y = y_lab)
}
