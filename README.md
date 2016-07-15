
<!-- README.md is generated from README.Rmd. Please edit that file -->
RSLP
====

> Removedor de Sufixos da Língua Portuguesa

[![Travis-CI Build Status](https://travis-ci.org/dfalbel/rslp.svg?branch=master)](https://travis-ci.org/dfalbel/rslp) [![codecov](https://codecov.io/gh/dfalbel/rslp/branch/master/graph/badge.svg)](https://codecov.io/gh/dfalbel/rslp) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rslp)](https://cran.r-project.org/package=rslp)

This package uses the algorithm *Stemming Algorithm for the Portuguese Language* described in [this article](http://homes.dcc.ufba.br/~dclaro/download/mate04/Artigo%20Erick.pdf) by Viviane Moreira Orengo and Christian Huyck.

The idea of the stemmer is very well explained by the following schema.

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

It works with vector of texts too, using the `rslp_doc` function.

``` r
docs <- c(
  "coma frutas pois elas fazem bem para a saúde.",
  "não coma doces, eles fazem mal para os dentes."
  )
rslp_doc(docs)
#> [1] "com frut poi el faz bem par a saud."  
#> [2] "nao com doc, ele faz mal par os dent."
```
