poetRee
================
Artjoms Šeļa
2026-10-27

  - [Installation](#installation)
  - [Usage](#usage)
  - [Cite](#cite)

**poetRee** library provides an easy way to get data in a tidy R format
from PoeTree API.

[PoeTree](https://poetree.org/) is a standardized collection of poetry
corpora comprising over 300,000 poems in 11 languages (Czech, English,
French, German, Hungarian, Italian, Norwegian, Portuguese, Russian,
Slovenian and Spanish). Each corpus has been deduplicated, enriched with
Universal Dependencies, provided with additional metadata and converted
into a unified JSON structure.

## Installation

``` r
devtools::install_github("perechen/poetRee")
```

## Usage

`poetRee` is a simple wrapper around [PoeTree’s REST
API](https://poetree.org/api_doc). You can always use the API directly,
but this library streamlines few things and follows `tidy` data format
in its output, including [`tidytext` for text analysis in
R](https://cran.r-project.org/web/packages/tidytext/vignettes/tidytext.html).

### get\_metadata()

Returns summary of each corpus with language ISO codes.

``` r
library(poetRee)

get_metadata()
```

    ## # A tibble: 11 × 7
    ##    corpus desc                        n_authors n_poems n_lines n_types n_tokens
    ##    <chr>  <chr>                           <int>   <int>   <int>   <int>    <int>
    ##  1 cs     "Compiled by Petr Plecháč …       606   80229 2727632  747141 18540972
    ##  2 de     "Compiled by Thomas Haider…       258   74351 2158923  991666 16038169
    ##  3 en     "Compiled by Petr Plecháč …       447   40735 1998886  273879 17506242
    ##  4 es     "Compiled by Borja Navarro…      1235    9379  131979   68350  1032179
    ##  5 fr     "Compiled by Richard Renau…       195   18226  864184  160301  7877993
    ##  6 hu     "Compiled by Gábor Palkó a…        48   12955  538878  418116  3336959
    ##  7 it     "Based on the Biblioteca I…       243   39749 1614230  460917 13173536
    ##  8 no     "Compiled by Ranveig Kvinn…        56    3117  111779   91969   750430
    ##  9 pt     "Compiled by Adiel Mittman…        25    5028  191643   94847  1375816
    ## 10 ru     "Compiled by Kirill Korcha…       372   45563 1472345  528185  9249958
    ## 11 sl     "Compiled by Neža Kočnik"          64    5587  142185  109539   875000

### get\_authors()

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

### get\_sources()

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

### get\_poems()

Returns a table with all poems for a given author ID (or vector of
author IDs\!). Check `?get_poems()` for more options and handling of
poems with multiple authors.

``` r
author_ids <- c(1,21)
get_poems(corpus = "cs",authors = author_ids)
```

    ## # A tibble: 383 × 8
    ##      id_ id          title id_source id_author year_created_from year_created_to
    ##    <int> <chr>       <chr>     <int>     <int>             <int>           <int>
    ##  1     1 0001_0001-… JARO…         1         1                NA              NA
    ##  2     2 0001_0001-… ČASN…         1         1                NA              NA
    ##  3     3 0001_0001-… ZMRZ…         1         1                NA              NA
    ##  4     4 0001_0001-… V PO…         1         1                NA              NA
    ##  5     5 0001_0001-… VEČE…         1         1                NA              NA
    ##  6     6 0001_0001-… PŘED…         1         1                NA              NA
    ##  7     7 0001_0001-… SNĚŽ…         1         1                NA              NA
    ##  8     8 0001_0001-… ČESK…         1         1                NA              NA
    ##  9     9 0001_0001-… HRAČ…         1         1                NA              NA
    ## 10    10 0001_0001-… SMRT          1         1                NA              NA
    ## # ℹ 373 more rows
    ## # ℹ 1 more variable: duplicate <chr>

### get\_text()

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

`metadata=TRUE` adds poem metadata (title, source, author IDs, dates of
creation, duplicate status).

`rhyme=TRUE` adds a `rhyme` column: IDs of lines (`id_line`) that rhyme
with the given line, comma-separated (`NA` if a line has no rhyme
partner).

`locations=TRUE` adds a `locations` column with
[Wikidata](https://www.wikidata.org/) IDs of places mentioned in a poem.
In the default line output, it lists all places mentioned in a line:

``` r
get_text(corpus="cs",
         poem_id=9,
         rhyme=TRUE,
         locations=TRUE)
```

    ## # A tibble: 52 × 7
    ##    corpus id_poem id_stanza id_line line_text                    rhyme locations
    ##    <chr>    <int>     <int>   <int> <chr>                        <chr> <chr>    
    ##  1 cs           9        39       0 „Kraj světa obešel jsem, vš… 3     <NA>     
    ##  2 cs           9        39       1 plemene lidského jsem pozna… 2,4   <NA>     
    ##  3 cs           9        39       2 všech pásem: nejlibější v c… 1,4   <NA>     
    ##  4 cs           9        39       3 od břehů širých otce Missis… 0     Q1497    
    ##  5 cs           9        39       4 až k Indu, rumem bohatému v… 1,2   Q668     
    ##  6 cs           9        39       5 jsem v Bankoku zřel lidské … 7     Q1861    
    ##  7 cs           9        39       6 na dvoře krále Siamského sk… 10    Q869     
    ##  8 cs           9        39       7 Ač příroda tam krásy dává s… 5     <NA>     
    ##  9 cs           9        39       8 ten hošek malý pleti světlo… 12    <NA>     
    ## 10 cs           9        39       9 a nekonečně důvěřivých očí   17    <NA>     
    ## # ℹ 42 more rows

In `tokenized` and `annotated` output, only tokens of a place name are
marked:

``` r
library(dplyr)

get_text(corpus="cs",
         poem_id=22,
         output="tokenized",
         locations=TRUE) %>%
  filter(!is.na(locations))
```

    ## # A tibble: 5 × 8
    ##   corpus id_poem id_stanza id_line line_text               form  lemma locations
    ##   <chr>    <int>     <int>   <int> <chr>                   <chr> <chr> <chr>    
    ## 1 cs          22       111       0 Stál svatý Vojtěch v Ř… Římě  Řím   Q220     
    ## 2 cs          22       111       6 V té chvíli Bůh ho do … Čech  Čechy Q213     
    ## 3 cs          22       111       8 ta jedna v Římě stála … Římě  Řím   Q220     
    ## 4 cs          22       112      27 A Bůh jej do Říma zas … Říma  Řím   Q220     
    ## 5 cs          22       113      31 Jen rukavička v Čechác… Čech… Čechy Q213

Check `?get_text` for more information.

### get\_locations()

Takes a poem ID (or vector of poem IDs\!), returns a table of places
mentioned in poems, one mention per row. `wiki` is a Wikidata ID; a
mention spans from the token `token_start` in the line `id_line_start`
to the token `token_end` in the line `id_line_end`. Line IDs match
`id_line` in `get_text()`; token positions are counted from 0 within a
line. Poems without locations contribute no rows.

``` r
get_locations(corpus="cs",poem_id=c(5,9,22))
```

    ## # A tibble: 10 × 7
    ##    corpus id_poem wiki  id_line_start token_start id_line_end token_end
    ##    <chr>    <int> <chr>         <int>       <int>       <int>     <int>
    ##  1 cs           5 Q1286            12           3          12         3
    ##  2 cs           9 Q1497             3           4           3         4
    ##  3 cs           9 Q668              4           2           4         2
    ##  4 cs           9 Q1861             5           2           5         2
    ##  5 cs           9 Q869              6           3           6         3
    ##  6 cs          22 Q220              0           4           0         4
    ##  7 cs          22 Q213              6           6           6         6
    ##  8 cs          22 Q220              8           3           8         3
    ##  9 cs          22 Q220             27           4          27         4
    ## 10 cs          22 Q213             31           3          31         3

## Cite

If using PoeTree in your research, please cite the two following items:

### Paper

    @article { poetree_paper,
          author = "Petr Plecháč and 
                    Silvie Cinková and
                    Robert Kolár and 
                    Artjoms Šeļa and
                    Mirella De Sisto and 
                    Lara Nugues and 
                    Thomas Haider and 
                    Neža Kočnik",
          title = "PoeTree: Poetry Treebanks in Czech, English, French, German, Hungarian, Italian, Portuguese, Russian, Slovenian and Spanish",
          journal = "Research Data Journal for the Humanities and Social Sciences",
          year = "2024",
          publisher = "Brill",
          address = "Leiden, The Netherlands",
          doi = "10.1163/24523666-bja10044",
          pages=      "1 - 17",
          url = "https://brill.com/view/journals/rdj/aop/article-10.1163-24523666-bja10044/article-10.1163-24523666-bja10044.xml"
    }

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

If you *really* want, you can cite this library:

    @Manual{R-poetRee,
      title = {poetRee: Provides an Easy Way to Get Tidy Poetry Data},
      author = {Artjoms Šeļa},
      year = {2026},
      note = {R package version 0.1.0},
      url = {https://github.com/perechen/poetRee},
    }
