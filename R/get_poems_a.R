get_poems_a <- function(corpus,
                        author) {

  author = paste0("&id_author=",author)
  # request
  base_url <- paste0("https://versologie.cz/poetree/api/poems?corpus=",corpus,author)

  # handling json output
  out <- GET(base_url)
  json <- out$content %>% rawToChar()

  # converting to tibble
  # additional handling of column types
  df <- fromJSON(json) %>%
    as_tibble() #%>%
#    mutate(across(c(starts_with("year"),"id_source"),~as.integer(.x)),
#           across("duplicate", ~as.character(.x)))

  return(df)
}
#
# ,
# .data$duplicate=as.character(.data$duplicate),
# .data$title=as.character(.data$title)) %>%
