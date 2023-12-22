#' Get author metadata
#'
#' @param x json file
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
get_authors <- function(x="../samples_json/authors.json") {


df <- fromJSON(x) %>% as_tibble()
return(df)
}


usethis::create_from_github(
  "https://github.com/YOU/YOUR_REPO.git",
  destdir = "~/path/to/where/you/want/the/local/repo/"
)



