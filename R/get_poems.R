get_poems <- function(corpus="cs") {

  ## list all author ids per corpus
  df_aut <- get_authors(corpus=corpus)
  authors_v <- df_aut$id_

  ## get list of poems for each author
  df <- lapply(authors_v, get_poems_a,corpus=corpus) %>%
    bind_rows()


  return(df)
}
