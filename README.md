Insights
=======
A Shiny application to analyse transaction-oriented trading systems based on the [blotter project](https://r-forge.r-project.org/projects/blotter/) 

How to use
-----------
The code has been tested with quantstrat's faber and bbands demo on a fresh R installation using RStudio. The demos are committed and saved in the `./data` directory. To get started open [main.R](./main.R) and run the code. Please update your packages first if something doesn't work.

To process your trades you'll have to write a script or adapt [RightEdgeToBlotter.R](./R/RightEdgeToBlotter.R). The important piece of code to process the transactions for the blotter portfolio is below. The required fields for each transaction are the symbol, date/time, quantity and the price. Export the data from your favourite platform or the broker. Make sure to use the same data source in R as you use for modelling/trading or the prices might not match and thus the resulting portfolio won't be correct.
```
# process transactions
for(i in 1 : nrow(execs))
  addTxn(ptfName, Symbol=execs$Symbol[i], TxnDate=execs$Transaction.Date[i],
         TxnQty=execs$Shares[i], TxnPrice=execs$Price[i], TxnFees=0)
```

References
-----------
* [SuperZIP demo](https://github.com/rstudio/shiny-examples/tree/master/063-superzip-example)
* [Blotter project](https://r-forge.r-project.org/projects/blotter/) 
