
# source functions
sourceDir <- list.files("./R", pattern="[.][Rr]$", full.names=TRUE, recursive=TRUE)
sourceDir <- sapply(sourceDir, source)

# load blotter envs
loadBlotterEnvs("./data", pattern="Env")

# load instruments
loadInstrumentsEnvs("./data", pattern="Instr")

# start and end date for the date slider
dateRange <- NULL

# load data
accounts <- getAccounts()
for(account in accounts) {
  portfolios <- names(getAccount(account)$portfolios)
  for(portfolio in portfolios) {
    ptf <- getPortfolio(portfolio)
    dateRange <- c(dateRange, as.numeric(as.Date(start(ptf$summary))), 
                   as.numeric(as.Date(end(ptf$summary))))
    symbols <- names(ptf$symbols)
    symbols <- symbols[!sapply(symbols, exists, where=.GlobalEnv)]
    getSymbols(symbols, env=.GlobalEnv, from=start(ptf$summary), auto.assign=TRUE)
  }
}
dateRange <- c(min(dateRange), max(dateRange))

# clean up
rm(sourceDir, account, portfolios, portfolio, ptf, symbols)
