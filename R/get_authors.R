#' Get author metadata
#'
#' @param corpus string, ISO code of the corpus language. Currently supported: "cs", "de", "en","es","fr","hu", "it", "pt", "ru"
#'
#' @return returns tidy data frame (tibble)
#'
#' @export
#'
#' @examples
#'\dontrun{
#'df <- get_authors()
#'}
#' @import dplyr
#' @import jsonlite
#' @import httr
#'
#'
get_authors <- function(corpus="cs") {

base_url <- "https://versologie.cz/poetree/api/authors?corpus="

api_request <- paste0(base_url, corpus)
out <- GET(api_request)
json <- out$content %>% rawToChar()

df <- fromJSON(json) %>% as_tibble()
return(df)
}






# corpus	1	str	Corpus to scan
# country	0	str	Limit to authors from certain countries. Either single value (country=pt) or stringified list (country=pt,br)
# born_after	0	int	Limit to authors born no sooner than a given year
# born_before	0	int	Limit to authors born no later than a given year
# died_after	0	int	Limit to authors that died no sooner than a given year
# died_before	0	int	Limit to authors that died no later than a given year
