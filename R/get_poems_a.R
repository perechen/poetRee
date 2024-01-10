#' Get poem metadata by author ID
#'
#' @param corpus string, ISO code of the corpus language. Check get_metadata() for all available corpora.
#' @param author integer, author ID. Check get_authors() for these.
#' @param duplicates logical. Whether to include duplicated texts. Default is FALSE. See more about duplicate detection strategy: https://versologie.cz/poetree/deduplication/
#'
#' @return returns tidy data frame (tibble)
#' @export
#'
#' @examples
#'\dontrun{
#'df <- get_poems_a(corpus="cs",author=81)
#'}
get_poems_a <- function(corpus,
                        author,
                        duplicates=FALSE) {

  author_req = paste0("&id_author=",author)
  # request
  base_url <- paste0("https://versologie.cz/poetree/api/poems?corpus=",corpus,author_req)

  # handling json output
  out <- GET(base_url)
  json <- out$content %>% rawToChar()

  # converting to tibble
  # additional handling of column types
  df <- fromJSON(json) %>%
    as_tibble() %>%
    mutate(across(c(starts_with("year"),"id_source"),~as.integer(.x)),
           across("duplicate", ~as.character(.x)),
           id_author=as.integer(author))

  if(!duplicates) {

    df <- df %>% filter(.data$duplicate == "FALSE")

  }

  return(df)
}
