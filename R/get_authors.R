#' Get author metadata
#'
#' @param corpus string, ISO code of the corpus language. Check get_metadata() for all available corpora.
#'
#' @return returns tidy data frame (tibble)
#'
#' @export
#'
#' @examples
#'\dontrun{
#'df <- get_authors(corpus="en")
#'}
#' @import dplyr
#' @import jsonlite
#' @import httr
#' @import tidyr
#'
get_authors <- function(corpus="cs") {

  # request
  base_url <- paste0("https://versologie.cz/poetree/api/authors?corpus=",corpus)

  # handling json output
  out <- GET(base_url)
  json <- out$content %>% rawToChar()

  # converting to tibble
  df <- fromJSON(json) %>% as_tibble()

return(df)
}
