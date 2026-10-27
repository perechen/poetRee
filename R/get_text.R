#' Retrieve text of a poem
#'
#' @param corpus string, ISO code of the corpus language. Check get_metadata() for all available corpora.
#' @param poem_id integer, corpus-wide poem ID. Check get_poems() for these.
#' @param output string. Controls how extensive should be the output. Options are "lines" (one line = one row), "tokenized" (one token = one row) and "annotated"
#' @param metadata logical. Whether to include poems' metadata. Default is FALSE.
#' @param rhyme logical. Whether to include a `rhyme` column: comma-separated `id_line`s of lines rhyming with the given line (NA if none). Default is FALSE.
#' @param locations logical. Whether to include a `locations` column with Wikidata IDs of places mentioned. In "lines" output it lists all places mentioned in a line, in "tokenized" / "annotated" output it marks the tokens of the place name (NA otherwise). Default is FALSE.
#'
#' @return returns tidy data frame (tibble)
#' @export
#'
#' @examples
#'\dontrun{
#'df <- get_text(corpus="cs",poem_id=1)
#'df <- get_text(corpus="cs",poem_id=9,rhyme=TRUE,locations=TRUE)
#'}

get_text <- function(corpus,
                     poem_id,
                     output="lines",
                     metadata=FALSE,
                     rhyme=FALSE,
                     locations=FALSE) {

  if(!output %in% c("lines", "tokenized", "annotated")) {

    stop("Wrong output format. Options are: 'lines', 'tokenized', 'annotated'")

  }

  words=id_line=line_pos=NULL
  # construct request
  base_url <- paste0("https://poetree.org/api/poem?corpus=",
                     corpus,
                     "&id_poem=",
                     poem_id,
                     "&words=",
                     ifelse(output=="lines", 0, 1),
                     "&neighbors=",
                     0)

  # handling json output
  out <- GET(base_url)
  stop_for_status(out, task=paste0("get poem ", poem_id, " from corpus '", corpus, "'"))
  json <- out$content %>% rawToChar() %>% fromJSON()

  ## poem metadata: one row
  meta <- json[setdiff(names(json), c("body", "locations"))]

  #  API returns nulls and they are handled badly in tibbles, so we need to account for it
  nulls <- meta %>% sapply(is.null)
  meta[nulls] <- NA

  # handle multiple authors
  if(length(meta$id_author) > 1) {

    meta$id_author <- list(meta$id_author)

  }

  meta <- as_tibble(meta)

  ## lines: one row per line, renamed by name (word-level fields reuse `id_` and `id`)
  df <- as_tibble(json$body) %>%
    rename(id_line_="id_", id_line="id", line_text="text")

  # rhyme is a list of rhyming line ids per line
  if(rhyme) {
    df <- df %>%
      mutate(rhyme=vapply(rhyme, collapse_ids, character(1)))
  }

  ## tokens: one row per token
  if(output != "lines") {

    df <- df %>%
      unnest(words) %>%
      rename(id_word_="id_", id_word="id") %>%
      # 0-based token position in a line (word `id` restarts per sentence)
      group_by(id_line) %>%
      mutate(line_pos=row_number() - 1L) %>%
      ungroup()

  }

  ## locations: [line id, token position] spans, matched on lines or tokens
  if(locations) {

    loc <- parse_locations(json$locations)

    if(output == "lines") {
      df$locations <- match_spans(df$id_line, df$id_line,
                                  loc$id_line_start, loc$id_line_end, loc$wiki)
    } else {
      # (line, position) encoded as one ordered number
      key <- df$id_line * 1e4 + df$line_pos
      df$locations <- match_spans(key, key,
                                  loc$id_line_start * 1e4 + loc$token_start,
                                  loc$id_line_end * 1e4 + loc$token_end,
                                  loc$wiki)
    }

  }

  df <- cross_join(meta, df)

  v_cols <- c("id_poem"="id_", "id_stanza", "id_line", "line_text")

  if(rhyme) {
    v_cols <- c(v_cols, "rhyme")
  }

  if(metadata) {

    v_cols <- c(v_cols, "title", "id_source", "id_author", "year_created_from", "year_created_to", "duplicate")

  }

  if(output == "tokenized") {
    v_cols <- c(v_cols, "form", "lemma")
  } else if (output == "annotated") {

    v_cols <- c(v_cols, "form", "lemma","upos", "xpos","id_sentence","id_word_",  "head", "deprel",  "feats","multiword")

  }

  if(locations) {
    v_cols <- c(v_cols, "locations")
  }

  df <- df %>%
    select(all_of(v_cols)) %>%
    mutate(corpus=corpus) %>%
    select(corpus, everything())

  return(df)


}

# collapse a vector of ids into a comma-separated string, NA if empty
collapse_ids <- function(x) {
  if(length(x) == 0) NA_character_ else paste(x, collapse=",")
}

# for each row span [from, to], list wiki ids of overlapping spans [loc_from, loc_to]
match_spans <- function(from, to, loc_from, loc_to, wiki) {
  vapply(seq_along(from), function(i) {
    collapse_ids(wiki[loc_from <= to[i] & loc_to >= from[i]])
  }, character(1))
}
