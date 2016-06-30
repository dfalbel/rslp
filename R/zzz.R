#' Pipe operator
#'
#' See \code{\link[magrittr]{\%>\%}} for more details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' Remover acentos
#'
#' Essa função foi copiada do PTtextmining.
#'
remover_acentos <- function(s){
  enc <- rvest::guess_encoding(s)
  enc <- enc$encoding[1]
  iconv(s, from = enc, to='ASCII//TRANSLIT')
}
