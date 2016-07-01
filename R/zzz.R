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
#' @param s the string you want to remove accents
#'
remove_accents <- function(s){
  enc <- rvest::guess_encoding(s)
  enc <- enc$encoding[1]
  iconv(s, from = enc, to = 'ASCII//TRANSLIT')
}

globalVariables(c("min_stem_len", "replacement", "sufix", "exceptions"))
