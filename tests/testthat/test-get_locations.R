test_that("Fetching locations works", {

  df <- get_locations(corpus="cs",poem_id=c(1,5,9,22))
  expect_equal(dim(df), c(10, 7))
  expect_equal(unique(df$id_poem), c(5L, 9L, 22L))
  expect_equal(df$wiki[df$id_poem == 9], c("Q1497", "Q668", "Q1861", "Q869"))

  # `false` locations
  expect_equal(nrow(get_locations(corpus="it",poem_id=5)), 0)

})
