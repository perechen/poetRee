# getting lines
test_that("Fetching poems works", {
  expect_equal(dim(get_text(corpus="cs",poem_id=1)), c(14, 5))
  expect_equal(dim(get_text(corpus="de",poem_id=1)), c(2, 5))
  expect_equal(dim(get_text(corpus="en",poem_id = 2)), c(28, 5))
  expect_equal(dim(get_text(corpus="es",poem_id = 1)), c(14, 5))
  expect_equal(dim(get_text(corpus="fr",poem_id = 1)), c(12, 5))
  expect_equal(dim(get_text(corpus="hu",poem_id = 2)), c(22, 5))
  expect_equal(dim(get_text(corpus="it",poem_id = 1)), c(16, 5))
  expect_equal(dim(get_text(corpus="pt",poem_id = 2)), c(14, 5))
  expect_equal(dim(get_text(corpus="ru",poem_id = 1)), c(40, 5))
  expect_equal(dim(get_text(corpus="sl",poem_id = 1)), c(6, 5))
  expect_equal(dim(get_text(corpus="no",poem_id = 3)), c(48, 5))
  })


test_that("Fetching tokens works", {

  expect_equal(dim(get_text(corpus="cs",poem_id=1,output = "tokenized")), c(93, 7))
  expect_equal(dim(get_text(corpus="de",poem_id=1,output = "tokenized")), c(10, 7))
  expect_equal(dim(get_text(corpus="en",poem_id = 2,output = "tokenized")), c(224, 7))
  expect_equal(dim(get_text(corpus="es",poem_id = 1,output = "tokenized")), c(95, 7))
  expect_equal(dim(get_text(corpus="fr",poem_id = 1,output = "tokenized")), c(86, 7))
  expect_equal(dim(get_text(corpus="hu",poem_id = 2,output = "tokenized")), c(169, 7))
  expect_equal(dim(get_text(corpus="it",poem_id = 1,output = "tokenized")), c(125, 7))
  expect_equal(dim(get_text(corpus="pt",poem_id = 2,output = "tokenized")), c(113, 7))
  expect_equal(dim(get_text(corpus="ru",poem_id = 1,output = "tokenized")), c(219, 7))
  expect_equal(dim(get_text(corpus="sl",poem_id = 1,output = "tokenized")), c(42, 7))
  expect_equal(dim(get_text(corpus="no",poem_id = 3,output = "tokenized")), c(238, 7))



})


test_that("Poems with multiple authors don't break the universe", {

  #expect_equal(dim(get_text(corpus="ru",poem_id = 33957,output = "lines")), c(8, 5))

  expect_equal(dim(get_text(corpus="ru",poem_id = 44228,output = "lines")), c(8, 5))



})
