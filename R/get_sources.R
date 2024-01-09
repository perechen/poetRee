#' List available bibliographic sources of poems.
#'
#' @param corpus string, ISO code of the corpus language. Check get_metadata() for all available corpora.
#' @param author integer, optional author ID. Check get_authors() for these.
#' @param tidy logical. If TRUE it unnests sources that have multiple authors (one author per row format). If FALSE, it bundles author IDs in a string (one source per row). TRUE by default
#'
#' @return returns tidy data frame (tibble)
#' @export
#'
#' @examples
#'\dontrun{
#'df <- get_sources(corpus="en",author=189)
#'}


get_sources <- function(corpus="cs",
                        author=NULL,
                        tidy=TRUE) {

  ## if author ID is supplied, add it to the GET
  if(!is.null(author)) {

    author = paste0("&id_author=",author)

  }

  # request
  base_url <- paste0("https://versologie.cz/poetree/api/sources?corpus=",corpus,author)

  # handling json output
  out <- GET(base_url)
  json <- out$content %>% rawToChar()

  # converting to tibble
  df <- fromJSON(json) %>%
    as_tibble()

  # bundle author ids in a string if tidy=FALSE
  # some corpora have only one author per book, so let's keep column consistently integer, if possible
  if(!tidy & is.list(df$id_author)) {

    df <- df %>%
      group_by(across(c(-.data$id_author))) %>%
      summarise(id_author=paste0(.data$id_author, collapse=",")) %>%
      ungroup()

  # unnest author ids if tidy=TRUE (default)
  } else {
    df <- df %>% unnest(.data$id_author)
  }

  return(df)
}

