#' RSLP
#'
#' Apply the Stemming Algorithm for the Portuguese Language to
#' vector of words.
#'
#' @param words vector of words that you want to stem.
#' @param steprules as obtained from the function extract_rules. (only define if you are certain about it).
#' The default is to get the parsed versionof the rules installed with the package.
#'
#' @references
#' \href{http://homes.dcc.ufba.br/~dclaro/download/mate04/Artigo Erick.pdf}{Article by Viviane Moreira Orengo and Christian Huyck}
#'
#' @examples
#' words <- c("balões", "aviões", "avião", "gostou", "gosto", "gostaram")
#' rslp(words)
#'
#' @export
rslp <- function(
  words,
  steprules = readRDS(system.file("steprules.rds", package = "rslp"))
) {
  plyr::laply(words, rslp_, steprules = steprules)
}


#' RSLP Document
#'
#' Apply the Stemming Algorithm for the Portuguese Language to
#' vector of documents. It extracts words using the regex
#' "\\b[:alpha:]\\b"
#'
#' @param docs chr vector of documents
#' @param steprules as obtained from the function extract_rules. (only define if you are certain about it).
#' The default is to get the parsed versionof the rules installed with the package.
#'
#' @examples
#' docs <- c("coma frutas pois elas fazem bem para a saúde.",
#' "não coma doces, eles fazem mal para os dentes.")
#' rslp_doc(docs)
#'
#' @export
#'
#' @references
#' \href{http://homes.dcc.ufba.br/~dclaro/download/mate04/Artigo Erick.pdf}{Article by Viviane Moreira Orengo and Christian Huyck}
#'
rslp_doc <- function(docs, steprules){
  words <- stringr::str_extract_all(docs, "\\b[:alpha:]+\\b") %>%
    unlist %>% unique
  words_s <- rslp(words)
  names(words_s) <- sprintf("\\b%s\\b", words)
  docs <- stringr::str_replace_all(docs, words_s)
  return(docs)
}

#' RSLP_
#'
#' Apply the Stemming Algorithm for the Portuguese Language to a word.
#'
#' @param word word to be stemmed.
#' @param steprules as obtained from the function extract_rules.
#'
rslp_ <- function(word,
                  steprules = readRDS(system.file("steprules.rds", package = "rslp"))
                  ) {

  if (stringr::str_sub(word, start = -1) == "s") {
    word <- apply_rules(word, "Plural", steprules)
  }

  if (stringr::str_sub(word, start = -1) == "a") {
    word <- apply_rules(word, "Feminine", steprules)
  }

  word <- apply_rules(word, "Augmentative", steprules)
  word <- apply_rules(word, "Adverb", steprules)

  word_after_noun <- apply_rules(word, "Noun", steprules)

  if (word_after_noun == word) {
    word_after_verb <- apply_rules(word, "Verb", steprules)
    if (word_after_verb == word) {
      word <- apply_rules(word, "Vowel", steprules)
    } else {
      word <- word_after_verb
    }
  } else {
    word <- word_after_noun
  }

  word <- remove_accents(word)
  return(word)
}


