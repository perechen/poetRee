# offline tests of get_text() parsing on synthetic fixtures (see fixtures/poem_7*.json)

test_that("output columns follow options", {

  local_poem_fixtures()

  for(output in c("lines", "tokenized", "annotated")) {
    for(opt in list(c(F,F,F), c(T,F,F), c(F,T,F), c(F,F,T), c(T,T,T))) {

      df <- get_text("xx", 7, output=output, metadata=opt[1], rhyme=opt[2], locations=opt[3])
      expect_named(df, text_cols(output, opt[1], opt[2], opt[3]))

    }
  }

})


test_that("lines are parsed with correct ids and types", {

  local_poem_fixtures()
  df <- get_text("xx", 7)

  expect_equal(df$corpus, rep("xx", 3))
  expect_identical(df$id_poem, rep(7L, 3))
  expect_identical(df$id_line, 0:2)
  expect_identical(df$id_stanza, c(1L, 1L, 2L))
  expect_equal(df$line_text, c("Ann went to New York.", "Rain. Then sun", "Paris and Rome"))

})


test_that("tokens are unnested once, keep line ids and don't clash with word ids", {

  local_poem_fixtures()
  df <- get_text("xx", 7, output="annotated")

  expect_equal(nrow(df), 6 + 4 + 3)
  expect_identical(df$id_word_, 1001:1013)
  expect_equal(df$form[df$id_line == 1], c("Rain", ".", "Then", "sun"))
  expect_identical(df$id_sentence[df$id_line == 1], c(2L, 2L, 3L, 3L))
  # line-level values repeated on every token of the line
  expect_true(all(df$line_text[df$id_line == 2] == "Paris and Rome"))

  # tokenized is a column subset of annotated
  tok <- get_text("xx", 7, output="tokenized")
  expect_equal(tok, df[, names(tok)])

})


test_that("rhyme is collapsed to line ids, NA when empty", {

  local_poem_fixtures()

  expect_equal(get_text("xx", 7, rhyme=TRUE)$rhyme, c("2", NA, "0"))
  expect_equal(get_text("xx", 8, rhyme=TRUE)$rhyme, c(NA_character_, NA_character_))
  expect_equal(get_text("xx", 7, output="tokenized", rhyme=TRUE)$rhyme,
               rep(c("2", NA, "0"), c(6, 4, 3)))

})


test_that("metadata handles nulls and multiple authors", {

  local_poem_fixtures()

  df <- get_text("xx", 7, metadata=TRUE)
  expect_equal(df$title, rep("Test poem", 3))
  expect_equal(df$id_author, rep(list(c(11L, 12L)), 3))
  expect_true(all(is.na(df$year_created_to)))
  expect_true(all(is.na(df$duplicate)))

  expect_identical(get_text("xx", 8, metadata=TRUE)$id_author, c(11L, 11L))

})


test_that("locations are matched by line and token position", {

  local_poem_fixtures()

  df <- get_text("xx", 7, locations=TRUE)
  expect_equal(df$locations, c("Q60", "Q3", "Q90,Q220"))

  df <- get_text("xx", 7, output="tokenized", locations=TRUE)
  marked <- df[!is.na(df$locations), ]
  # multi-token span: both tokens marked
  expect_equal(marked$form, c("New", "York", "sun", "Paris", "Rome"))
  # position counts tokens in the line, not word ids (which restart per sentence)
  expect_equal(marked$locations, c("Q60", "Q60", "Q3", "Q90", "Q220"))

})


test_that("`false` locations give an NA column", {

  local_poem_fixtures()

  expect_equal(get_text("xx", 8, locations=TRUE)$locations, c(NA_character_, NA_character_))
  expect_true(all(is.na(get_text("xx", 8, output="tokenized", locations=TRUE)$locations)))

})


test_that("spans are matched across lines", {

  # span from line 0 token 4 to line 1 token 1
  wiki <- "Q1"
  lines <- 0:2
  expect_equal(match_spans(lines, lines, 0, 1, wiki), c("Q1", "Q1", NA))

  key <- c(0, 3, 4, 1e4, 1e4 + 1, 1e4 + 2)
  expect_equal(match_spans(key, key, 4, 1e4 + 1, wiki), c(NA, NA, "Q1", "Q1", "Q1", NA))

})


test_that("errors are informative", {

  local_poem_fixtures()

  expect_error(get_text("xx", 7, output="words"), "Wrong output format")
  expect_error(get_text("xx", 999), "HTTP 404.*poem 999 from corpus 'xx'")

})
