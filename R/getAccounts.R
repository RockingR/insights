
#' Get all account names from the .blotter environment
#'
#' Retrieves all account names from the .blotter environment
#'
#' @author Simon Otziger
#' @export
getAccounts <- function() {
  out <- ls(.blotter)
  out <- gsub("account.", replacement="", x=out[grepl("account.", x=out)])
  return(out)
}
