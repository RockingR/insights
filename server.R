
shinyServer(function(input, output, session) {
  
  ### inputs
  #
  ## chart.Posn
  #
  # portfolios
  observe({
    portfolios <- if (is.null(input$account) || input$account == "") {
      character(0) 
    } else {
      sort(names(getAccount(input$account)$portfolios))
    }
    stillSelected <- isolate(input$portfolio[input$portfolio %in% portfolios])
    updateSelectInput(session, inputId="portfolio", choices=portfolios,
                      selected=stillSelected)
  })
  
  # symbols
  observe({
    symbols <- if (is.null(input$portfolio) || input$portfolio == "") {
      character(0)
    } else {
      sort(names(getPortfolio(input$portfolio)$symbols))
    }
    stillSelected <- isolate(input$symbol[input$symbol %in% symbols])
    updateSelectInput(session, inputId="symbol", choices=symbols,
                      selected=stillSelected)
  })
  
  # dates
  observe({
    dates <- if (is.null(input$portfolio) || input$portfolio == "") {
      dateRange
    } else {
      as.numeric(c(as.Date(start(getPortfolio(input$portfolio)$summary)), 
                   as.Date(end(getPortfolio(input$portfolio)$summary))))
    }
    updateSliderInput(session, inputId="dateRange", value=dates)
  })
  
  
  ## trade stats
  #
  # portfolios
  observe({
    portfolios <- if (is.null(input$account_ts) || input$account_ts == "") {
      character(0) 
    } else {
      sort(names(getAccount(input$account_ts)$portfolios))
    }
    stillSelected <- isolate(input$portfolio_ts[input$portfolio_ts %in% portfolios])
    updateSelectInput(session, inputId="portfolio_ts", choices=portfolios,
                      selected=stillSelected)
  })
  
  
  ## per trade stats
  #
  # portfolios
  observe({
    portfolios <- if (is.null(input$account_pts) || input$account_pts == "") {
      character(0) 
    } else {
      sort(names(getAccount(input$account_pts)$portfolios))
    }
    stillSelected <- isolate(input$portfolio_pts[input$portfolio_pts %in% portfolios])
    updateSelectInput(session, inputId="portfolio_pts", choices=portfolios,
                      selected=stillSelected)
  })
  
  # symbols
  # TODO: fix that a symbol is displayed even though the user hasn't selected yet
  #       a portfolio and symbol
  observe({
    symbols <- if (is.null(input$portfolio_pts) || input$portfolio_pts == "") {
      character(0)
    } else {
      sort(names(getPortfolio(input$portfolio_pts)$symbols))
    }
    stillSelected <- isolate(input$symbol_pts[input$symbol_pts %in% symbols])
    updateSelectInput(session, inputId="symbol_pts", choices=symbols,
                      selected=stillSelected)
  })


  ## MAE/MFE
  #
  # portfolios
  observe({
    portfolios <- if (is.null(input$account_me) || input$account_me == "") {
      character(0)
    } else {
      sort(names(getAccount(input$account_me)$portfolios))
    }
    stillSelected <- isolate(input$portfolio_me[input$portfolio_me %in% portfolios])
    updateSelectInput(session, inputId="portfolio_me", choices=portfolios,
                      selected=stillSelected)
  })

  # symbols
  observe({
    symbols <- if (is.null(input$portfolio_me) || input$portfolio_me == "") {
      character(0)
    } else {
      sort(names(getPortfolio(input$portfolio_me)$symbols))
    }
    stillSelected <- isolate(input$symbol_me[input$symbol_me %in% symbols])
    updateSelectInput(session, inputId="symbol_me", choices=symbols,
                      selected=stillSelected)
  })


  ## chart.EquityCurve
  #
  # portfolios
  observe({
    portfolios <- if (is.null(input$account_eqc) || input$account_eqc == "") {
      character(0)
    } else {
      sort(names(getAccount(input$account_eqc)$portfolios))
    }
    stillSelected <- isolate(input$portfolio_eqc[input$portfolio_eqc %in% portfolios])
    updateSelectInput(session, inputId="portfolio_eqc", choices=portfolios,
                      selected=stillSelected)
  })

  # symbols
  observe({
    symbols <- if (is.null(input$portfolio_eqc) || input$portfolio_eqc == "") {
      character(0)
    } else {
      sort(names(getPortfolio(input$portfolio_eqc)$symbols))
    }
    stillSelected <- isolate(input$symbol_eqc[input$symbol_eqc %in% symbols])
    updateSelectInput(session, inputId="symbol_eqc", choices=symbols,
                      selected=stillSelected)
  })
  
  
  ### outputs
  #
  # chart.Posn
  output$chartPosn <- renderPlot({
    if(!is.null(input$symbol) && input$symbol[1] != "") {
      dateSubset <- format(as.Date(input$dateRange), format="%Y%m%d")
      dateSubset <- paste(dateSubset, collapse="/")
      par(mfrow=c(length(input$symbol), 1))
      for(symbol in input$symbol)
        chart.Posn(input$portfolio, Symbol=symbol, Dates=dateSubset)
    }
  }, res=100)
  
  # trade stats
  output$tradeStatsTable <- renderDataTable({
    if(!is.null(input$portfolio_ts) && input$portfolio_ts[1] != "") {
      tbl <- tradeStats(input$portfolio_ts, use=input$use_ts, tradeDef=input$tradeDef_ts,
                        inclZeroDays=input$inclZeroDays_ts)[, -1]
      tbl[, -1] <- round(tbl[, -1], digits=input$digits_ts)
      if(input$transpose_ts)
        tbl <- cbind(Statistic=colnames(tbl)[-1], t(tbl)[-1, ])
      return(tbl)
    }
  }, options=list(iDisplayLength="50"))
  
  # per trade stats
  output$perTradeStatsTable <- renderDataTable({
    if(!is.null(input$symbol_pts) && input$symbol_pts[1] != "") {
      tbl <- perTradeStats(input$portfolio_pts, Symbol=input$symbol_pts,
                           includeOpenTrade=input$includeOpenTrade_pts,
                           tradeDef=input$tradeDef_pts)
      tbl[, -(1 : 2)] <- round(tbl[, -(1 : 2)], digits=input$digits_pts)
      return(tbl)
    }
  })
  
  # chart.ME
  output$chartME <- renderPlot({
    if(!is.null(input$symbol_me) && input$symbol_me[1] != "") {
      len <- length(input$symbol_me)
      par(mfrow=c(round(sqrt(len), digits=0), ceiling(sqrt(len))))
      for(symbol in input$symbol_me)
        chart.ME(input$portfolio_me, Symbol=symbol, type=input$type_me, scale=input$scale_me)
    }
  }, res=100)
  
  # chart.EquityCurve
  output$chartEquityCurve <- renderPlot({
    if(!is.null(input$symbol_eqc) && input$symbol_eqc[1] != "") {
      len <- length(input$symbol_eqc)
      par(mfrow=c(round(sqrt(len), digits=0), ceiling(sqrt(len))))
      for(symbol in input$symbol_eqc)
        chart.EquityCurve(input$portfolio_eqc, Symbol=symbol, scale=input$scale_eqc)
    }
  }, res=100)
})
