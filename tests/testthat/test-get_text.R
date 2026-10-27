# live tests against poetree.org
# one known poem per corpus
poems <- c(cs=1, de=1, en=2, es=1, fr=1, hu=2, it=1, pt=2, ru=1, sl=1, no=3)

# getting lines
test_that("Fetching poems works", {
  skip_if_no_api()
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
  skip_if_no_api()

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


test_that("All corpora return the full schema with all options", {
  skip_if_no_api()

  # catches API changes in any corpus (new fields, `false` vs `[]`, etc.)
  expect_setequal(names(poems), get_metadata()$corpus)

  for(corpus in names(poems)) {

    df <- get_text(corpus, poems[[corpus]], output="annotated",
                   metadata=TRUE, rhyme=TRUE, locations=TRUE)

    expect_named(df, text_cols("annotated", TRUE, TRUE, TRUE))
    expect_type(df$id_line, "integer")
    expect_type(df$id_word_, "integer")
    expect_type(df$line_text, "character")
    expect_type(df$form, "character")
    expect_type(df$rhyme, "character")
    expect_type(df$locations, "character")
    expect_true(all(df$id_poem == poems[[corpus]]))

  }

})


test_that("Lines and tokens are consistent", {
  skip_if_no_api()

  for(corpus in c("cs", "en", "ru")) {

    lines <- get_text(corpus, poems[[corpus]], rhyme=TRUE)
    tokens <- get_text(corpus, poems[[corpus]], output="tokenized", rhyme=TRUE)

    # line ids are 0..n-1, every line has tokens
    expect_identical(lines$id_line, seq_len(nrow(lines)) - 1L)
    expect_setequal(unique(tokens$id_line), lines$id_line)

    # line-level columns of the token output reproduce the lines output
    expect_equal(distinct(tokens[, names(lines)]), lines)

    # tokens appear in the line text, in order
    for(i in lines$id_line) {
      forms <- tokens$form[tokens$id_line == i]
      pos <- regexpr(paste(gsub("([][{}()+*^$|\\\\?.])", "\\\\\\1", forms), collapse=".*"),
                     lines$line_text[i + 1])
      expect_true(pos > 0, label=paste(corpus, "line", i))
    }

  }

})


test_that("Rhymes point to existing lines and are symmetric", {
  skip_if_no_api()

  for(id in c(1, 9, 27)) {

    df <- get_text("cs", id, rhyme=TRUE)
    pairs <- rhyme_pairs(df)

    expect_true(nrow(pairs) > 0)
    expect_true(all(pairs[,2] %in% df$id_line))
    expect_setequal(paste(pairs[,1], pairs[,2]), paste(pairs[,2], pairs[,1]))

  }

})


test_that("Poems with multiple authors don't break the universe", {
  skip_if_no_api()

  #expect_equal(dim(get_text(corpus="ru",poem_id = 33957,output = "lines")), c(8, 5))

  expect_equal(dim(get_text(corpus="ru",poem_id = 44228,output = "lines")), c(8, 5))

  df <- get_text(corpus="ru",poem_id=44228,metadata=TRUE)
  expect_setequal(df$id_author[[1]], c(364L, 366L))

})


test_that("Locations agree between get_text() and get_locations()", {
  skip_if_no_api()

  for(id in c(5, 9, 22)) {

    loc <- get_locations("cs", id)
    lines <- get_text("cs", id, locations=TRUE)
    tokens <- get_text("cs", id, output="tokenized", locations=TRUE)

    expect_setequal(lines$id_line[!is.na(lines$locations)], loc$id_line_start)
    # one marked token per single-token mention
    expect_equal(sum(!is.na(tokens$locations)),
                 sum(loc$token_end - loc$token_start + 1))

  }

  df <- get_text("cs", 22, output="tokenized", locations=TRUE)
  expect_equal(df$form[!is.na(df$locations)], c("Římě", "Čech", "Římě", "Říma", "Čechách"))

  # poems with `false` or empty locations
  expect_true(all(is.na(get_text(corpus="it",poem_id=5,locations=TRUE)$locations)))
  expect_true(all(is.na(get_text(corpus="cs",poem_id=1,locations=TRUE)$locations)))

})


test_that("Unknown corpus or poem fails clearly", {
  skip_if_no_api()

  expect_error(get_text("nl", 1), "HTTP 404")
  expect_error(get_text("cs", 99999999), "HTTP 404")

})
