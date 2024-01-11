poetRee
================
Artjoms Šeļa
2024-01-11

- <a href="#installation" id="toc-installation">Installation</a>
- <a href="#usage" id="toc-usage">Usage</a>
- <a href="#cite" id="toc-cite">Cite</a>

**poetRee** library provides an easy way to get data in a tidy R format
from PoeTree API.

[PoeTree](https://versologie.cz/poetree/) is a standardized collection
of poetry corpora comprising over 300,000 poems in nine languages
(Czech, English, French, German, Hungarian, Italian, Portuguese,
Spanish, and Russian). Each corpus has been deduplicated, enriched with
Universal Dependencies, provided with additional metadata and converted
into a unified JSON structure.

## Installation

``` r
devtools::install_github("perechen/seetrees")
```

## Usage

`poetRee` is a simple wrapper around [PoeTree’s REST
API](https://versologie.cz/poetree/api_doc). You can always use the API
directly, but this library streamlines few things and follows `tidy`
data format in its output, including [`tidytext` for text analysis in
R](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html).

### get_metadata()

Returns summary of each corpus with language ISO codes.

``` r
library(poetRee)

get_metadata()
```

    ## # A tibble: 9 × 7
    ##   corpus desc                         n_authors n_poems n_lines n_types n_tokens
    ##   <chr>  <chr>                            <int>   <int>   <int>   <int>    <int>
    ## 1 cs     "Compiled by Petr Plecháč a…       606   80229 2727632  747141 18540972
    ## 2 de     "Compiled by Klemens Bobenh…       245   53133 1701234  678426 12482485
    ## 3 en     "Compiled by Petr Plecháč f…       447   40735 1998886  273879 17506242
    ## 4 es     "Compiled by Borja Navarro-…      1260    9379  131979   68350  1032179
    ## 5 fr     "Compiled by Richard Renaul…       195   18226  864184  160301  7877993
    ## 6 hu     "Compiled by Gábor Palkó an…        48   12955  538878  418116  3336959
    ## 7 it     "Based on the Biblioteca It…       243   39749 1614230  460917 13173536
    ## 8 pt     "Compiled by Adiel Mittmann…        25    5028  191643   94847  1375816
    ## 9 ru     "Compiled by Kirill Korchag…       371   45563 1472342  540012  9253036

### get_authors()

Returns a table with all authors in a corpus.

``` r
get_authors(corpus="cs")
```

    ## # A tibble: 606 × 8
    ##      id_ name                 viaf     wiki      country  born  died n_poems
    ##    <int> <chr>                <chr>    <chr>     <lgl>   <int> <int>   <int>
    ##  1   186 Adámek, Bohumil      83654820 Q11217870 NA       1848  1915      26
    ##  2   218 Adámek, Josef        <NA>     <NA>      NA         NA    NA       3
    ##  3     1 Albert, Eduard       50027287 Q700775   NA       1841  1900      43
    ##  4   519 Alexis               <NA>     <NA>      NA         NA    NA       1
    ##  5     2 Ambrož, Vilém        14479787 Q27479890 NA       1846  1903     105
    ##  6   152 Aren, J.             <NA>     <NA>      NA         NA    NA       1
    ##  7     4 Arietto, Ladislav    83656997 Q33037726 NA       1861  1927      23
    ##  8     5 Auředníček, Otakar   3401502  Q12043163 NA       1868  1947     103
    ##  9   263 Baar, Jindřich Šimon 54946709 Q1356321  NA       1869  1925      33
    ## 10   597 Baarová, Marie       <NA>     <NA>      NA         NA    NA      56
    ## # ℹ 596 more rows

### get_sources()

Returns a table with all (bibliographic) sources in a corpus. Optionally
supports author IDs.

``` r
get_sources(corpus="cs",author=81)
```

    ## # A tibble: 4 × 7
    ##     id_ id    title                     id_author year_published publisher place
    ##   <int> <chr> <chr>                         <int>          <int> <chr>     <chr>
    ## 1   407 0408  Básně                            81           1821 Vetterlo… Praha
    ## 2   408 0409  Slávy dcera ve třech zpě…        81           1824 Královsk… Budín
    ## 3   409 0410  Slávy dcera                      81           1832 Trattner… Pešť 
    ## 4   410 0411  Výklad                           81           1832 Trattner… Pešť

### get_poems()

Returns a table with all poems for a given author ID (or vector of
author IDs!). Check `?get_poems()` for more options and handling of
poems with multiple authors.

``` r
author_ids <- c(1,21)
get_poems(corpus = "cs",authors = author_ids)
```

    ## # A tibble: 383 × 8
    ##      id_ id          title id_source year_created_from year_created_to duplicate
    ##    <int> <chr>       <chr>     <int>             <int>           <int> <chr>    
    ##  1     1 0001_0001-… JARO…         1                NA              NA FALSE    
    ##  2     2 0001_0001-… ČASN…         1                NA              NA FALSE    
    ##  3     3 0001_0001-… ZMRZ…         1                NA              NA FALSE    
    ##  4     4 0001_0001-… V PO…         1                NA              NA FALSE    
    ##  5     5 0001_0001-… VEČE…         1                NA              NA FALSE    
    ##  6     6 0001_0001-… PŘED…         1                NA              NA FALSE    
    ##  7     7 0001_0001-… SNĚŽ…         1                NA              NA FALSE    
    ##  8     8 0001_0001-… ČESK…         1                NA              NA FALSE    
    ##  9     9 0001_0001-… HRAČ…         1                NA              NA FALSE    
    ## 10    10 0001_0001-… SMRT          1                NA              NA FALSE    
    ## # ℹ 373 more rows
    ## # ℹ 1 more variable: id_author <int>

### get_text()

Takes a poem ID, returns a tidy data frame with its text and
annotations. By default returns a poem in one-line-per-row format:

``` r
get_text(corpus="cs",poem_id=1)
```

    ## # A tibble: 14 × 5
    ##    corpus id_poem id_stanza id_line line_text                        
    ##    <chr>    <int>     <int>   <int> <chr>                            
    ##  1 cs           1         1       0 Tvá loď jde po vysokém moři,     
    ##  2 cs           1         1       1 v ně brázdu jako stříbro reje,   
    ##  3 cs           1         1       2 svou přídu v modré vlny noří     
    ##  4 cs           1         1       3 a bok svůj pěnné do peřeje.      
    ##  5 cs           1         2       4 Tvá lana sviští, plachty duní    
    ##  6 cs           1         2       5 a třepe vlajka. V noční chvíli   
    ##  7 cs           1         2       6 zříš magický svit mořských tůní, 
    ##  8 cs           1         2       7 a ve snu, Albatros jak pílí.     
    ##  9 cs           1         3       8 Já samotním, jsem na ostrově,    
    ## 10 cs           1         3       9 ohýnek topím, rybku lově         
    ## 11 cs           1         3      10 zasedám na břeh za večera.       
    ## 12 cs           1         4      11 Dým v kotoučích se modrých krade,
    ## 13 cs           1         4      12 kdes písklo ptáče, ještě mladé,  
    ## 14 cs           1         4      13 tma na mne hrozí z pološera.

`output` parameter controls output. `tokenized` and `annotated` options
return a text in one-token-per-row format. `annotated` also returns
UDpipe part-of-speech annotations and dependency parsing.

``` r
get_text(corpus="cs",
         poem_id=1,
         output="tokenized")
```

    ## # A tibble: 93 × 7
    ##    corpus id_poem id_stanza id_line line_text                      form    lemma
    ##    <chr>    <int>     <int>   <int> <chr>                          <chr>   <chr>
    ##  1 cs           1         1       0 Tvá loď jde po vysokém moři,   Tvá     tvůj 
    ##  2 cs           1         1       0 Tvá loď jde po vysokém moři,   loď     loď  
    ##  3 cs           1         1       0 Tvá loď jde po vysokém moři,   jde     jít  
    ##  4 cs           1         1       0 Tvá loď jde po vysokém moři,   po      po   
    ##  5 cs           1         1       0 Tvá loď jde po vysokém moři,   vysokém vyso…
    ##  6 cs           1         1       0 Tvá loď jde po vysokém moři,   moři    moře 
    ##  7 cs           1         1       0 Tvá loď jde po vysokém moři,   ,       ,    
    ##  8 cs           1         1       1 v ně brázdu jako stříbro reje, v       v    
    ##  9 cs           1         1       1 v ně brázdu jako stříbro reje, ně      on   
    ## 10 cs           1         1       1 v ně brázdu jako stříbro reje, brázdu  bráz…
    ## # ℹ 83 more rows

Check `?get_text` for more information and adding metadata.

## Cite

If using PoeTree in your research, please cite the two following items:

### Dataset

    @dataset{poetree_data,
      author    = {Plecháč, Petr and
                  Kolár, Robert and
                  Cinková, Silvie and
                  Šeļa, Artjoms and
                  De Sisto, Mirella and
                  Nugues, Lara and
                  Haider, Thomas and
                  Nagy, Benjamin and
                  Delente, Éliane and
                  Renault, Richard and
                  Bobenhausen, Klemens and
                  Hammerich, Benjamin and
                  Mittmann, Adiel and
                  Palkó, Gábor and
                  Horváth, Péter and
                  Navarro Colorado, Borja and
                  Ruiz Fabo, Pablo and
                  Bermúdez Sabel, Helena and
                  Korchagin, Kirill and
                  Plungian, Vladimir and
                  Sitchinava, Dmitri},
      title     = {{PoeTree. Poetry Treebanks in Czech, English, 
                  French, German, Hungarian, Italian, Portuguese,
                  Russian and Spanish}},
      month     = oct,
      year      = 2023,
      publisher = {Zenodo},
      version   = {0.0.1},
      doi       = {10.5281/zenodo.10008459},
      url       = {https://doi.org/10.5281/zenodo.10008459}
    }

### Paper

    Plecháč, P., Kolár, R., Cinková, S., Šeļa, A., De Sisto, M., Nugues, L., Haider, T. (forthcoming). PoeTree. Poetry Treebanks in Czech, English, French, German, Hungarian, Italian, Portuguese, Russian and Spanish 

If you *really* want, you can cite this library:

    @Manual{R-poetRee,
      title = {poetRee: Provides an Easy Way to Get Tidy Poetry Data},
      author = {Artjoms Šeļa},
      year = {2024},
      note = {R package version 0.0.0.9000},
      url = {https://github.com/perechen/poetRee},
    }
