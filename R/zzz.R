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
#' A wrappper for stringi package.
#'
#' @param s the string you want to remove accents
#'
remove_accents <- function(s){
  stringi::stri_trans_general(s, "Latin-ASCII")
}

globalVariables(c("min_stem_len", "replacement", "sufix", "exceptions"))
