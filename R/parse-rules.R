#' Extract Rules from file
#'
#' This function parse the rules that are disponible in the RLSP package
#' disponible in the this \url{http://www.inf.ufrgs.br/~arcoelho/rslp/integrando_rslp.html}
#' This file has been downloaded and is installed with the package. It's path
#' can be found using system.file("steprules.txt", package = "rslp")
#' A parsed version is saved is also installed with the package and its path
#' can be found using system.file("steprules.rds", package = "rslp").
#'
#' @param path path to the raw steprules. Most of the times you don't have to change it.
#'
#' @export
extract_rules <- function(path = system.file("steprules.txt", package = "rslp")){
  rules_raw <- paste(readLines(path), collapse = " ")
  rules <- extract_raw_rules(rules_raw)
  rules_proc <- extract_rules_info(rules)
  return(rules_proc)
}


#' Extract raw rules
#'
#' Separate the seven kinds of rules
#'
#' @param raw_rules a charcter with the raw rules.
#'
extract_raw_rules <- function(raw_rules){
  rules <- stringr::str_extract_all(raw_rules, "\\{(.*?)\\};") %>%
    unlist()
}

#' Extract Rules Info
#'
#' Extract all info from all rules
#'
#' @param rules rules parsed before by \link{extract_rule_info}
#'
extract_rules_info <- function(rules){
  rules_p <- plyr::llply(rules, extract_rule_info)
  nam <- plyr::laply(rules_p, function(x) {x$name})
  names(rules_p) <- nam
  return(rules_p)
}



#' Extract Rule Info
#'
#' Extract all info for one rule
#'
#' @param rule the rule you want to extract infos
#'
extract_rule_info <- function(rule){
  sep <- stringr::str_split_fixed(rule, ",", 4)[1,]
  list(
    name = stringr::str_extract(sep[1], "[:alpha:]{1,}"),
    min_word_len = as.integer(stringr::str_extract(sep[2], "[:digit:]{1,}")),
    flag_compare = as.integer(stringr::str_extract(sep[3], "[:digit:]{1}")),
    replacement_rule = extract_replacement_rules(sep[4])
  )
}

#' Extract replacement rules
#'
#' Parses the the raw replacement rules.
#'
#' @param raw_repl the part with replacement rules for each step rule.
#'
extract_replacement_rules <- function(raw_repl){

  repl <- unlist(stringr::str_extract_all(raw_repl, "\\{(.*?)\\}"))
  sep <- stringr::str_split_fixed(repl, ",", 4)

  repl_rules <- plyr::adply(sep, 1, function(s){
    dplyr::data_frame(
    sufix = stringr::str_extract(s[1], "[:alpha:]{1,}"),
    min_stem_len = as.integer(stringr::str_extract(s[2], "[:digit:]{1,}")),
    replacement = stringr::str_extract(s[3], "[:alpha:]{1,}"),
    exceptions = list(unlist(stringr::str_extract_all(s[4], "\\w+")))
    )
  }, .id = NULL)
  dplyr::mutate(
    repl_rules,
    min_stem_len = ifelse(is.na(min_stem_len), 0, min_stem_len),
    replacement = ifelse(is.na(replacement), "", replacement)
  ) %>%
    dplyr::group_by(sufix) %>%
    dplyr::summarise(min_stem_len = max(min_stem_len),
                     replacement = dplyr::first(replacement),
                     exceptions = list(unlist(exceptions))

    ) %>%
    dplyr::filter(min_stem_len > 0)
}
