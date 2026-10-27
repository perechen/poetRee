# offline tests of poems, sources and locations parsing on synthetic fixtures

local_poems_fixtures <- function(env=parent.frame()) {
  local_api_fixtures(c("id_author=11"="poems_11.json",
                       "id_author=12"="poems_12.json"),
                     env=env)
}


test_that("co-authored poems get the requested author", {

  local_poems_fixtures()

  # API reports author 12 for poem 7 in both listings
  df <- get_poems("xx", authors=c(11, 12))
  expect_equal(sort(df$id_author[df$id_ == 7]), c(11L, 12L))
  expect_true(all(df$id_author %in% c(11L, 12L)))

})


test_that("tidy=FALSE gives one row per poem with bundled authors", {

  local_poems_fixtures()

  df <- get_poems("xx", authors=c(11, 12), tidy=FALSE)
  expect_equal(nrow(df), length(unique(df$id_)))
  expect_equal(df$id_author[df$id_ == 7], "11,12")
  expect_equal(df$id_author[df$id_ == 10], "12")

  # no co-authored poems: nothing to bundle
  expect_identical(get_poems("xx", authors=12, tidy=FALSE)$id_author, c(12L, 12L))

})


test_that("duplicates are filtered", {

  local_poems_fixtures()

  expect_equal(get_poems("xx", authors=11)$id_, c(7L, 8L))
  expect_equal(get_poems("xx", authors=11, duplicates=TRUE)$id_, c(7L, 8L, 9L))

})


test_that("get_poems() needs authors or list_all", {

  expect_error(get_poems("xx"), "author IDs")

})


test_that("sources with multiple authors are unnested or bundled", {

  local_api_fixtures(c("sources\\?corpus=xx$"="sources_multi.json"))

  df <- get_sources("xx")
  expect_equal(df$id_, c(1L, 1L, 2L))
  expect_identical(df$id_author, c(11L, 12L, 13L))

  df <- get_sources("xx", tidy=FALSE)
  expect_equal(df$id_, c(1L, 2L))
  expect_equal(df$id_author, c("11,12", "13"))

})


test_that("sources with single authors keep integer ids", {

  local_api_fixtures(c("sources\\?corpus=xx$"="sources_single.json"))

  expect_identical(get_sources("xx")$id_author, c(11L, 13L))
  expect_identical(get_sources("xx", tidy=FALSE)$id_author, c(11L, 13L))

})


test_that("get_locations() parses spans of several poems", {

  local_poem_fixtures()

  df <- get_locations("xx", c(7, 8))
  expect_named(df, c("corpus", "id_poem", "wiki", "id_line_start", "token_start", "id_line_end", "token_end"))
  expect_equal(df$wiki, c("Q60", "Q3", "Q90", "Q220"))
  expect_identical(df$id_poem, rep(7L, 4))
  expect_identical(df$token_start, c(3L, 3L, 0L, 2L))
  expect_identical(df$token_end, c(4L, 3L, 0L, 2L))

  # poem without locations: empty tibble with the same columns
  empty <- get_locations("xx", 8)
  expect_equal(nrow(empty), 0)
  expect_named(empty, names(df))

  expect_error(get_locations("xx", 999), "HTTP 404")

})
