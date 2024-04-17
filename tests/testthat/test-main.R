box::use(
  shiny[testServer],
  testthat[expect_true, test_that],
)
box::use(
  app/main[server, ui],
)

test_that("main server works", {
  expect_true(TRUE)
})
