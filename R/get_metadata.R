
#' List all PoeTree corpora
#'
#'
#' @return returns tidy data frame (tibble)

#'
#' @examples
#'\dontrun{
#'df <- get_metadata()
#'}

get_metadata <- function() {

  # request
  base_url <- "https://versologie.cz/poetree/api/corpora"

  # handling json output
  out <- GET(base_url)
  json <- out$content %>% rawToChar()

  # converting to tibble
  df <- fromJSON(json) %>% as_tibble()

  return(df)
}
