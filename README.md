
<!-- README.md is generated from README.Rmd. Please edit that file -->
RSLP
====

> Removedor de Sufixos da Língua Portuguesa

This package uses the algorithm *Stemming Algorithm for the Portuguese Language* described in [this article](http://homes.dcc.ufba.br/~dclaro/download/mate04/Artigo%20Erick.pdf) by Viviane Moreira Orengo Christian Huyck.

The idea of the stemmer is very weel explained in the following schema.

![Schema](README-schema.PNG)

Installing
----------

To install the package you can use the following:

``` r
devtools::install_github("dfalbel/rslp")
```

Using
-----

The only important function of the package is the `rslp` function. You can call it on a vector of characters like this:

``` r
library(rslp)
words <- c("balões", "aviões", "avião", "gostou", "gosto", "gostaram")
rslp(words)
#> [1] "bal"  "avi"  "avi"  "gost" "gost" "gost"
```
