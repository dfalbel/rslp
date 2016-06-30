#' Extract Rules from file
#'
#'
extract_rules <- function(){
  rules_raw <- paste(readLines("data-raw/steprules.txt"), collapse = " ")
  rules <- extract_rules(rules)
  rules_proc <- extract_rules_info(rules)
  return(rules_proc)
}



#' Extract raw rules
#'
#' @importFrom  magrittr `%>%`
extract_raw_rules <- function(raw_rules){
  rules <- stringr::str_extract_all(rules_raw, "\\{(.*?)\\};") %>%
    unlist()
}

#' Extract Rules Info
#'
#'
extract_rules_info <- function(rules){
  rules_p <- plyr::llply(rules, extract_rule_info)
  nam <- plyr::laply(rules_p, function(x) {x$name})
  names(rules_p) <- nam
  return(rules_p)
}



#' Extract Rule Info
#'
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
  dplyr::mutate(repl_rules,
                min_stem_len = ifelse(is.na(min_stem_len), 0, min_stem_len),
                replacement = ifelse(is.na(replacement), "", replacement)
  )
}
