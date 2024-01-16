# testing available corpora
test_that("Fetching sources works", {
  expect_equal(dim(get_sources(corpus="cs",author=1)), c(1,7))
  expect_equal(dim(get_sources(corpus="en",author=1)), c(1,7))
  expect_equal(dim(get_sources(corpus="fr",author=1)), c(2,7))
})

# testing tidy nesting of multiple authors per source
test_that("Tidy authors in sources works", {
  expect_equal(dim(get_sources(corpus="en")), c(856,7))
  expect_equal(dim(get_sources(corpus="en",tidy = F)), c(849,7))
})
