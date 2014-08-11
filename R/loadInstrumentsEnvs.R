
#' Load FinancialInstrument Environments
#'
#' Loads multiple saved FinancialInstrument environments
#'
#' @param path string a character vector of a full path name; the default 
#' corresponds to the working directory, \code{getwd()}
#' @param pattern string an optional regular expression. Only file names which 
#' match the regular expression will be returned
#'
#' @author Simon Otziger
#' @export
loadInstrumentsEnvs <- function(path=".", pattern="Instr") {
  files <- list.files(path, pattern=pattern, full.names=TRUE, recursive=TRUE)
  files <- sapply(files, loadInstruments)
}
