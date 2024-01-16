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
  expect_equal(dim(get_text(corpus="ru",poem_id = 1)), c(28, 5))
})


test_that("Fetching tokens works", {

  expect_equal(dim(get_text(corpus="cs",poem_id=1,output = "tokenized")), c(93, 7))
  expect_equal(dim(get_text(corpus="de",poem_id=1,output = "tokenized")), c(10, 7))
  expect_equal(dim(get_text(corpus="en",poem_id = 2,output = "tokenized")), c(227, 7))
  expect_equal(dim(get_text(corpus="es",poem_id = 1,output = "tokenized")), c(97, 7))
  expect_equal(dim(get_text(corpus="fr",poem_id = 1,output = "tokenized")), c(89, 7))
  expect_equal(dim(get_text(corpus="hu",poem_id = 2,output = "tokenized")), c(169, 7))
  expect_equal(dim(get_text(corpus="it",poem_id = 1,output = "tokenized")), c(128, 7))
  expect_equal(dim(get_text(corpus="pt",poem_id = 2,output = "tokenized")), c(121, 7))
  expect_equal(dim(get_text(corpus="ru",poem_id = 1,output = "tokenized")), c(165, 7))


})
