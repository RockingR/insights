#' Chart Cumulated Equity Curve Close to Close
#'
#' Produces a lineplot with one point per trade, with x-axis: trade number 
#' and y-axis: cumulated equity curve close to close
#'
#' @param Portfolio string identifying the portfolio to chart
#' @param Symbol string identifying the symbol to chart. If missing, the first symbol found in the \code{Portfolio} portfolio will be used
#' @param scale string specifying 'cash' or 'tick'
#' @param \dots any other passthrough parameters, in particular includeOpenTrades (see perTradeStats())
#'
#' @author Jan Humme, Simon Otziger
#' @seealso \code{\link{perTradeStats}} for the calculations used by this chart, 
#' and \code{\link{tradeStats}} for a summary view of the performance
#' @export
chart.EquityCurve <- function(Portfolio, Symbol, scale=c('cash','tick'), ...)
{ # @author Jan Humme, Simon Otziger
  pname <- Portfolio
  Portfolio <- getPortfolio(pname)
  if (missing(Symbol))
    Symbol <- ls(Portfolio$symbols)[[1]]
  else 
    Symbol <- Symbol[1]

  # can only take the first if the user doesn't specify
  scale <- scale[1] 
  
  trades <- perTradeStats(pname, Symbol, ...)
  
  switch(scale,
         cash = {
           .ylab <- 'Equity (cash)'
           .cols <- "Net.Trading.PL"
         },
         tick = {
           .ylab <- 'Equity (ticks)'
           .cols <- "tick.Net.Trading.PL"
         }
  )
  
  .xlab <- "Trade Number"
  .main <- paste(Symbol, trades$Start[1], " / ", trades$End[nrow(trades)])

  cumPNL <- cumsum(trades[, .cols])
  hwm <- c(cumPNL[1] > 0, diff(cummax(cumPNL)) > 0)
  
  plot(cumPNL, type='n', xlab=.xlab, ylab=.ylab, main=.main)
  grid()
  lines(cumPNL)
  points(cbind(1 : length(cumPNL), cumPNL)[hwm, ], pch=19, col='green', cex=0.6)
  
  legend(
    x='bottomright', inset=0.1,
    legend=c('Net Profit','Peaks'),
    lty=c(1, NA), pch=c(NA, 19),
    col=c('black','green')
  )
}
