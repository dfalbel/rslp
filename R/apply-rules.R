#' Apply rules
#'
#' @param word word to which you want to apply the rules
#' @param name the rule name, possible values are: 'Plural', 'Feminine', 'Adverb',
#' 'Augmentative', 'Noun', 'Verb', 'Vowel' .
#' @param steprules steprules as obtained from the function extract_rules.
#'
#' @examples
#' steprules <- readRDS(system.file("steprules.rds", package = "rslp"))
#' rslp:::apply_rules("balões", name = "Plural", steprules)
#' rslp:::apply_rules("lápis", name = "Plural", steprules)
#' rslp:::apply_rules("bolas", name = "Plural", steprules)
#'
apply_rules <- function(word, name, steprules) {
  rules <- steprules[[name]]
  word_len <- stringr::str_length(word)
  if (word_len >= rules$min_word_len) {
    rep_rules <- rules$replacement_rule[
      verify_sufix(word, rules$replacement_rule) &
        !is.na(rules$replacement_rule$sufix),
      ]
    if (nrow(rep_rules) > 0) {
      # select longest possible sufix
      rep_rules <-
        rep_rules[stringr::str_length(rep_rules$sufix) ==
                    max(stringr::str_length(rep_rules$sufix), na.rm = T),
                  ]
      stringr::str_sub(word, start = -stringr::str_length(rep_rules$sufix[1])) <-
        rep_rules$replacement[1]
    }
  }
  return(word)
}


#' Verify
#'
#' Given a list of suffixes, returns a vector of true or
#' false indicating if the word has each one of the suffixes.
#'
#' @param word word you which to verify replacement rules
#' @param rep_rules data.frame of rules as specified in steprules$replacement_rule
#'
verify_sufix <- function(word, rep_rules) {
  has_sufix <- stringr::str_sub(word, start = -stringr::str_length(rep_rules$sufix)) ==
    rep_rules$sufix
  has_min_len <- stringr::str_length(word) - stringr::str_length(rep_rules$sufix) +
    stringr::str_length(rep_rules$replacement) >= rep_rules$min_stem_len
  is_not_exception <- sapply(rep_rules$exceptions, function(x) {!word %in% unlist(x)})
  return(has_sufix & has_min_len & is_not_exception)
}
