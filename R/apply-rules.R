steprules <- readRDS(system.file("steprules.rds", package = "nlsp"))
#' Apply rules
#'
#'
apply_rules <- function(word, name, steprules) {
  rules <- steprules[[name]]
  word_len <- stringr::str_length(word)
  if (word_len < rules$min_word_len) {
    return(word)
  } else {
    rep_rules <- rules$replacement_rule[has_sufix(word, rules$replacement_rule$sufix),]
    suf_len <- stringr::str_length(rep_rules$sufix)
    for (s in order(-suf_len)) {
      exceptions <- unlist(rep_rules$exceptions)
      if (!word %in% exceptions) {
        stringr::str_sub(word, start = -stringr::str_length(rep_rules$sufix[s])) <-
          rep_rules$replacement[s]
        return(word)
      }
    }
    return(word)
  }
}

#' Has sufix?
#'
#' Given a list of suffixes, returns a vector of true or
#' false indicating if the word has each one of the suffixes.
#'
#'
has_sufix <- function(word, sufix){
  suf <- stringr::str_sub(word, start = -stringr::str_length(sufix))
  suf == sufix
}


apply_rules("balões", name = "Plural", steprules)

#' #' Plural reduction
#' #'
#' #' Runs the step 1 from the RNLS algorithm.
#' #'
#' #' @param word
#' #'
#' #' @return
#' #' word plural-reduced.
#' #'
#' #' @examples
#' #' words <- c("bons", "balões", "capitães", "normais", "papéis", "casas")
#' #' plural_reduction(words)
#' #'
#' #' @references
#' #' A Stemming Algorithm for the Portuguese Language
#' #' http://homes.dcc.ufba.br/~dclaro/download/mate04/Artigo%20Erick.pdf
#' #'
#' #' @rdname plural_reduction
#' #' @export
#' plural_reduction <- function(word){
#'   plyr::laply(word, plural_reduction_)
#' }
#'
#' #' @rdname plural_reduction
#' #' @export
#' plural_reduction_ <- function(word){
#'
#'   l <- stringr::str_length(word)
#'   rules <- plural_reduction_rules()
#'
#'   for (r in 1:nrow(rules)) {
#'
#'     sufix <- rules$sufix[r]
#'     minimum_stem_size <- rules$minimum_stem_size[r]
#'     replacement <- rules$replacement[r]
#'     len <- rules$lenght[r]
#'
#'     if (stringr::str_sub(word, start = -len) == sufix & (l - len) >= minimum_stem_size) {
#'       stringr::str_sub(word, start = -len) <- replacement
#'       break
#'     }
#'
#'   }
#'
#'   return(word)
#' }
#'
#' #' @rdname plural_reduction
#' #' @export
#' plural_reduction_rules <- function(){
#'   df <- data.frame(
#'     sufix = c("ns", "ões", "ães", "ais", "éis", "eis", "óis", "is", "les", "res", "s"),
#'     minimum_stem_size = c(1,3,1,1,2,2,2,2,3,3,2),
#'     replacement = c("m", "ão", "ão", "al", "el", "el", "ol", "il", "l", "r", ""),
#'     stringsAsFactors = F
#'   )
#'   df$lenght <- stringr::str_length(df$sufix)
#'   dplyr::arrange(df, dplyr::desc(lenght))
#' }
