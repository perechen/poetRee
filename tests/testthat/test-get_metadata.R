test_that("Fetching PoeTree metadata works", {
  expect_equal(dim(get_metadata()), c(9,7))
})
