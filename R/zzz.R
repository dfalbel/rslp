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

#' Remove Acccents
#'
#' Copied from PTtextmining.
#'
remove_acccents <- function(s){
  enc <- rvest::guess_encoding(s)
  enc <- enc$encoding[1]
  iconv(s, from = enc, to='ASCII//TRANSLIT')
}
