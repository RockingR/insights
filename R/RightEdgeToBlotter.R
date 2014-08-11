
RightEdgeToBlotter <- function(strName, ptfName, accName, initEq=1e5, inFile, pathOut) {
  if(missing(ptfName))
    ptfName <- strName
  if(missing(accName))
    accName <- ptfName
  
  # read in the data file
  tbl <- read.csv(inFile, header=TRUE, stringsAsFactors=FALSE)
  
  # executions
  executions <- function(x_df) {
    tradeSide <- function(x) {
      switch(x,
             Buy=1,
             Sell=-1,
             Cover=1,
             Short=-1)
    }
    side <- sapply(x_df$Type, tradeSide)
    x_df$Transaction.Date <- as.character(as.Date(substr(x_df$Transaction.Date, 1, 10), format="%m/%d/%Y"))
    x_df$Shares <- x_df$Shares * side
    return(x_df)
  }
  execs <- executions(tbl)
  
  # symbols
  symbols <- sort(unique(execs$Symbol))
  
  # init portfolio, account and orders
  initDate <- min(as.Date(execs[1, "Transaction.Date"])) - 1
  initAcct(accName, portfolios=ptfName, initDate=initDate, initEq=initEq)
  initPortf(ptfName, symbols=symbols, initDate=initDate)
  initOrders(ptfName, initDate=initDate)
  
  # download symbols
  # TODO: make dynamic
  currency("USD")
  stock(symbols, "USD")
  getSymbols(symbols, from=as.Date(initDate), adjust=FALSE)
  for(sym in symbols)
    assign(sym, value=adjustOHLC(get(sym), use.Adjusted=TRUE), envir=.GlobalEnv)
  # process transactions
  for(i in 1 : nrow(execs))
    addTxn(ptfName, Symbol=execs$Symbol[i], TxnDate=execs$Transaction.Date[i],
           TxnQty=execs$Shares[i], TxnPrice=execs$Price[i], TxnFees=0)
  #browser()
  updatePortf(ptfName, Dates=paste0("::", as.Date(Sys.time())))
  updateAcct(accName)
  updateEndEq(accName)
  
  # save blotter environment and instruments
  save(.blotter, file=paste0(pathOut, strName, "Env.Rdata"))
  saveInstruments(paste0(pathOut, strName, "Instr.Rdata"))
  
  # clean up
  rm.strat(strName)
  rm_instruments(symbols, keep.currencies=FALSE)
  rm(list=symbols, envir=.GlobalEnv)
}
