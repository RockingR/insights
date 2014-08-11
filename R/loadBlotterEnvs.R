
#' Load Blotter Environments
#'
#' Loads multiple saved blotter environments
#'
#' @param path string a character vector of a full path name; the default 
#' corresponds to the working directory, \code{getwd()}
#' @param pattern string an optional regular expression. Only file names which 
#' match the regular expression will be returned
#'
#' @author Simon Otziger
#' @export
loadBlotterEnvs <- function(path=".", pattern="Env") {
  files <- list.files(path, pattern=pattern, full.names=TRUE, recursive=TRUE)
  loadEnv <- new.env()
  for(f in files) {
    load(f)
    for(obj in ls(.blotter))
      loadEnv[[obj]] <- get(obj, env=.blotter)
  }
  for(obj in ls(loadEnv))
    .blotter[[obj]] <<- get(obj, env=loadEnv)  
}
