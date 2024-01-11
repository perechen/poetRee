#' Retrieve text of a poem
#'
#' @param corpus string, ISO code of the corpus language. Check get_metadata() for all available corpora.
#' @param poem_id integer, corpus-wide poem ID. Check get_poems() for these.
#' @param output string. Controls how extensive should be the output. Options are "lines" (one line = one row), "tokenized" (one token = one row) and "annotated"
#' @param metadata logical. Whether to include poems' metadata. Default is FALSE.
#'
#' @return returns tidy data frame (tibble)
#' @export
#'
#' @examples
#'\dontrun{
#'df <- get_text(corpus="cs",poem_id=1)
#'}

get_text <- function(corpus,
                     poem_id,
                     output="lines",
                     metadata=FALSE) {

  if(!output %in% c("lines", "tokenized", "annotated")) {

    stop("Wrong output format. Options are: 'lines', 'tokenized', 'annotated'")

  }
  # construct request
  base_url <- paste0("https://versologie.cz/poetree/api/poem?corpus=",
                     corpus,
                     "&id_poem=",
                     poem_id,
                     "&words=",
                     ifelse(output=="lines", 0, 1),
                     "&neighbors=",
                     0)

  # handling json output
  out <- GET(base_url)
  json <- out$content %>% rawToChar() %>% fromJSON()

  #  API returns nulls and they are handled badly in tibbles, so we need to account for it
  nulls <- json %>% sapply(is.null)
  json[nulls] <- NA

  df <- json %>% as_tibble()
  ## new names for unnesting data frame
  new_names <- c("id_line_", "id_line", "id_stanza", "line_text", "part", "words")

  if(output=="lines"){
    new_names <- new_names[-length(new_names)]
  }

  nm1 <- c(setdiff(names(df), 'body'), new_names)


  v_cols <- c("id_poem"="id_", "id_stanza", "id_line", "line_text")

  if(metadata) {

    v_cols <- c(v_cols, "title", "id_source", "id_author", "year_created_from", "year_created_to", "duplicate")

  }

  if(output == "tokenized") {
    v_cols <- c(v_cols, "form", "lemma")
  } else if (output == "annotated") {

    v_cols <- c(v_cols, "form", "lemma","upos", "xpos","id_sentence","id_word_",  "head", "deprel",  "feats")

  }


  ## handling the output of data frames etc.
  if(output=="lines") {

  df <- df %>%
    unnest_wider(body,names_repair = ~ nm1) %>%
    select(all_of(v_cols))


  } else {

    ## first unnest to set names
    df_lines <- df %>%
      unnest_wider(body,names_repair = ~ nm1) #%>%


    ## names for the second unnest

    w_names <- c("id_word_", "id_word", "id_sentence", "head", "deprel", "form", "lemma", "upos", "xpos","feats")
    nm2 <- c(setdiff(names(df_lines), 'words'), w_names)


    # second unnest

    df <- df_lines %>%
      unnest(.data$words,names_repair = ~ nm2) %>%
      select(all_of(v_cols))

  }

  df <- df %>% mutate(corpus=corpus) %>%
    select(corpus, everything())

  return(df)


}

