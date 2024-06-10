test_that("Fetching poems works", {
  expect_equal(dim(get_poems(corpus="cs",authors=4)), c(21, 8))
  expect_equal(dim(get_poems(corpus="de",authors=3)), c(16, 8))
  expect_equal(dim(get_poems(corpus="en",authors = 3)), c(38, 8))
  expect_equal(dim(get_poems(corpus="es",authors = 3)), c(8, 8))
  expect_equal(dim(get_poems(corpus="fr",authors = 2)), c(8, 8))
  expect_equal(dim(get_poems(corpus="hu",authors = 3)), c(8, 8))
  expect_equal(dim(get_poems(corpus="it",authors = 33)), c(2, 8))
  expect_equal(dim(get_poems(corpus="pt",authors = 3)), c(10, 8))
  expect_equal(dim(get_poems(corpus="ru",authors = 65)), c(33, 8))
  expect_equal(dim(get_poems(corpus="sl",authors = 14)), c(42, 8))
})


test_that("Duplicate filters work", {

  expect_equal(dim(get_poems(corpus="cs",authors=4)), c(21, 8))
  expect_equal(dim(get_poems(corpus="cs",authors=4,duplicates = T)), c(23, 8))


})
