#' Get places mentioned in poems
#'
#' @param corpus string, ISO code of the corpus language. Check get_metadata() for all available corpora.
#' @param poem_id integer or vector of integers, corpus-wide poem ID. Check get_poems() for these.
#'
#' @return returns tidy data frame (tibble), one location mention per row. `wiki` is a Wikidata ID; a mention spans from token `token_start` in line `id_line_start` to token `token_end` in line `id_line_end` (token positions are 0-based within a line, line IDs match `id_line` in get_text()). Poems without locations contribute no rows.
#' @export
#'
#' @examples
#'\dontrun{
#'df <- get_locations(corpus="cs",poem_id=c(5,9,22))
#'}

get_locations <- function(corpus,
                          poem_id) {

  df <- lapply(poem_id, get_locations_p, corpus=corpus) %>%
    bind_rows()

  return(df)
}

# locations of a single poem
get_locations_p <- function(poem_id,
                            corpus) {

  # request
  base_url <- paste0("https://poetree.org/api/poem?corpus=",
                     corpus,
                     "&id_poem=",
                     poem_id,
                     "&words=0&neighbors=0")

  # handling json output
  out <- GET(base_url)
  stop_for_status(out, task=paste0("get poem ", poem_id, " from corpus '", corpus, "'"))
  json <- out$content %>% rawToChar() %>% fromJSON()

  df <- parse_locations(json$locations) %>%
    mutate(corpus=corpus,
           id_poem=as.integer(poem_id),
           .before=1)

  return(df)
}

# API locations ([], false or data frame of wiki + [line, token] spans) to tibble
parse_locations <- function(loc) {

  if(!is.data.frame(loc) || nrow(loc) == 0) {

    return(tibble(wiki=character(),
                  id_line_start=integer(), token_start=integer(),
                  id_line_end=integer(), token_end=integer()))

  }

  starts <- do.call(rbind, loc$loc_start)
  ends <- do.call(rbind, loc$loc_end)

  tibble(wiki=loc$wiki,
         id_line_start=as.integer(starts[,1]), token_start=as.integer(starts[,2]),
         id_line_end=as.integer(ends[,1]), token_end=as.integer(ends[,2]))
}
