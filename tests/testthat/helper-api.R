# live tests hit poetree.org: skip them on CRAN and without internet
skip_if_no_api <- function() {
  skip_on_cran()
  skip_if_offline("poetree.org")
}

fake_response <- function(url, status, body) {
  structure(list(url=url, status_code=status, headers=list(),
                 content=charToRaw(enc2utf8(body))),
            class="response")
}

# serve API requests from tests/testthat/fixtures
# `routes` maps a regex matched against the request URL to a fixture file;
# unmatched requests get a 404 HTML page, like the real API
local_api_fixtures <- function(routes, env=parent.frame()) {

  local_mocked_bindings(GET=function(url, ...) {

    hit <- names(routes)[vapply(names(routes), grepl, logical(1), x=url)]

    if(length(hit) == 0) {
      return(fake_response(url, 404L, "<!DOCTYPE html><html></html>"))
    }

    path <- test_path("fixtures", routes[[hit[1]]])
    fake_response(url, 200L, paste(readLines(path, encoding="UTF-8", warn=FALSE), collapse="\n"))

  }, .env=env)
}

local_poem_fixtures <- function(env=parent.frame()) {
  local_api_fixtures(c("id_poem=7&words=0"="poem_7.json",
                       "id_poem=7&words=1"="poem_7_words.json",
                       "id_poem=8&"="poem_8.json"),
                     env=env)
}

# expected get_text() columns for a given set of options
text_cols <- function(output="lines", metadata=FALSE, rhyme=FALSE, locations=FALSE) {
  c("corpus", "id_poem", "id_stanza", "id_line", "line_text",
    if(rhyme) "rhyme",
    if(metadata) c("title", "id_source", "id_author", "year_created_from", "year_created_to", "duplicate"),
    if(output == "tokenized") c("form", "lemma"),
    if(output == "annotated") c("form", "lemma", "upos", "xpos", "id_sentence", "id_word_", "head", "deprel", "feats", "multiword"),
    if(locations) "locations")
}

# rhyme column to a two-column matrix of (line, rhyming line) pairs
rhyme_pairs <- function(df) {
  df <- df[!is.na(df$rhyme), ]
  partners <- lapply(strsplit(df$rhyme, ","), as.integer)
  cbind(rep(df$id_line, lengths(partners)), unlist(partners))
}
