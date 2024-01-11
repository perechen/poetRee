#' List PoeTree poems (metadata only)
#'
#' @param corpus string, ISO code of the corpus language. Check get_metadata() for all available corpora.
#' @param authors integer or vector of integers, author ID. Check get_authors() for these. Supports multiple ids provided in a vector.
#' @param duplicates logical. Whether to include duplicated texts. Default is FALSE. See more about duplicate detection strategy: https://versologie.cz/poetree/deduplication/
#' @param tidy logical. If TRUE it unnests poem records that have multiple authors (one poem-author per row format). If FALSE, it bundles author IDs in a string (one poem per row format). Very rarely useful, TRUE by default
#' @param list_all logical. If TRUE, lists all poems available in the given corpus. Default is FALSE.
#'
#' @return returns tidy data frame (tibble)
#' @export
#'
#' @examples
#'\dontrun{
#'df <- get_poems(corpus="cs",author=c(81,52))
#'}

get_poems <- function(corpus="cs",
                      authors=NULL,
                      duplicates=FALSE,
                      tidy=TRUE,
                      list_all=FALSE) {

  if(is.null(authors) & !list_all)
  {
    stop("Please provide author IDs, or use `list_all=TRUE`")
  }

  ## list all author ids per corpus
  if(list_all) {
  df_aut <- get_authors(corpus=corpus)
  authors_v <- df_aut$id_
  } else {

    authors_v <- authors

  }

  ## get list of poems for each author
  df <- lapply(authors_v, get_poems_a,corpus=corpus,duplicates=duplicates) %>%
    bind_rows()

  ## handling multiple authors per poem if tidy=FALSE
  if(!tidy) {

    poems <- unique(df$id_) %>% length()
    rows <- nrow(df)

    # only execute if n unique poems < n of rows in the dataframe
    ## return original if there are no multiple authors per poem


    if(poems < rows) {

    df <- df %>%
        group_by(across(c(-.data$id_author))) %>%
        summarise(id_author=paste0(.data$id_author, collapse=",")) %>%
        ungroup()

    }


  }


  return(df)
}
