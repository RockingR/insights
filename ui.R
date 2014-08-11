
shinyUI(
  navbarPage("Insights", id="nav",      
             
             tabPanel("Trade Charts",
                      div(class="outer",      
                          # Controls
                          absolutePanel(id="controls", class="modal", fixed=TRUE, draggable=TRUE,
                                        top=60, left="auto", right=20, bottom="auto", width=330, 
                                        height="auto",
                                        
                                        h2("Controls"),
                                        
                                        # account, portfolio, symbol
                                        fluidRow(
                                          column(width=4,
                                                 selectInput("account", label="Account", 
                                                             choices=c("Choose an account"="", accounts))
                                          ),
                                          column(width=4,
                                                 conditionalPanel("input.account",
                                                                  selectInput("portfolio", label="Portfolio", 
                                                                              choices=c("Choose a portfolio"=""))
                                                 )
                                          ),
                                          column(width=4,
                                                 conditionalPanel("input.portfolio",
                                                                  selectInput("symbol", label="Symbol(s)", 
                                                                              choices=c("Choose a symbol"=""), 
                                                                              multiple=TRUE)
                                                 )
                                          )
                                        ), #end fluidRow
                                        # date slider
                                        sliderInput("dateRange", label="Date range", min=dateRange[1], 
                                                    max=dateRange[2], value=dateRange, step=1)
                          ), #end absolutePanel
                          plotOutput("chartPosn", width="100%", height="100%")
                      ) #end div
             ), #end tabPanel
             
             tabPanel("Trade Stats",
                      # account, portfolio, symbol
                      fluidRow(
                        column(width=2,
                               selectInput("account_ts", label="Account", 
                                           choices=c("Choose an account"="", accounts))
                        ),
                        column(width=2,
                               conditionalPanel("input.account_ts",
                                                selectInput("portfolio_ts", label="Portfolio", 
                                                            choices=c("Choose a portfolio"=""))
                               )
                        )
                      ), #end fluidRow
                      # options
                      fluidRow(
                        column(width=2,
                               selectInput("use_ts", label="Calculation",
                                           choices=c("Transactions"="txns",
                                                     "Round-trip trades"="trades"))
                        ),
                        column(width=2,
                               selectInput("tradeDef_ts", label="Trade definition",
                                           choices=c("Flat to flat"="flat.to.flat",
                                                     "Flat to reduced"="flat.to.reduced"))
                        ),
                        column(width=2,
                               selectInput("inclZeroDays_ts", label="Include zero P&L days",
                                           choices=c("No"=FALSE, "Yes"=TRUE))
                        ),
                        column(width=2,
                               numericInput("digits_ts", label="Digits to display", 
                                            value=2, min=0, max=10)
                        ),
                        column(width=2,
                               selectInput("transpose_ts", label="Transpose table",
                                           choices=c("Yes"=TRUE, "No"=FALSE))
                        )
                      ), #end fluidRow
                      hr(),
                      dataTableOutput("tradeStatsTable")
             ), #end tabPanel

             tabPanel("Per Trade Stats",
                      # account, portfolio, symbol
                      fluidRow(
                        column(width=2,
                               selectInput("account_pts", label="Account",
                                           choices=c("Choose an account"="", accounts))
                        ),
                        column(width=2,
                               conditionalPanel("input.account_pts",
                                                selectInput("portfolio_pts", label="Portfolio",
                                                            choices=c("Choose a portfolio"=""))
                               )
                        ),
                        column(width=2,
                               conditionalPanel("input.portfolio_pts",
                                                selectInput("symbol_pts", label="Symbol",
                                                            choices=c("Choose a symbol"=""))
                               )
                        )
                      ), #end fluidRow
                      # options
                      fluidRow(
                        column(width=2,
                               selectInput("includeOpenTrade_pts", label="Include open trade",
                                           choices=c("Yes"=TRUE, "No"=FALSE))
                        ),
                        column(width=2,
                               selectInput("tradeDef_pts", label="Trade definition",
                                           choices=c("Flat to flat"="flat.to.flat",
                                                     "Flat to reduced"="flat.to.reduced"))
                        ),
                        column(width=2,
                               numericInput("digits_pts", label="Digits to display",
                                            value=2, min=0, max=10)
                        )
                      ), #end fluidRow
                      hr(),
                      dataTableOutput("perTradeStatsTable")
             ), #end tabPanel

             tabPanel("MAE/MFE",
                      div(class="outer",

                          # Include our custom CSS
                          tags$head(includeCSS("styles.css")),
                          tags$div(),

                          # Controls
                          absolutePanel(id="controls", class="modal", fixed=TRUE, draggable=TRUE,
                                        top=60, left="auto", right=20, bottom="auto", width=330,
                                        height="auto",

                                        h2("Controls"),

                                        # account, portfolio, symbol
                                        fluidRow(
                                          column(width=4,
                                                 selectInput("account_me", label="Account",
                                                             choices=c("Choose an account"="", accounts))
                                          ),
                                          column(width=4,
                                                 conditionalPanel("input.account_me",
                                                                  selectInput("portfolio_me", label="Portfolio",
                                                                              choices=c("Choose a portfolio"=""))
                                                 )
                                          ),
                                          column(width=4,
                                                 conditionalPanel("input.portfolio_me",
                                                                  selectInput("symbol_me", label="Symbol(s)",
                                                                              choices=c("Choose a symbol"=""),
                                                                              multiple=TRUE)
                                                 )
                                          )
                                        ), #end fluidRow
                                        # options
                                        fluidRow(
                                          column(width=4,
                                                 selectInput("type_me", label="Type",
                                                             choices=c("MAE"="MAE",
                                                                       "MFE"="MFE"))
                                          ),
                                          column(width=4,
                                                 selectInput("scale_me", label="Scale",
                                                             choices=c("Cash"="cash",
                                                                       "Percent"="percent",
                                                                       "Tick"="tick"))
                                          )
                                        ) #end fluidRow                
                          ), #end absolutePanel
                          plotOutput("chartME", width="100%", height="100%")
                      ) #end div
             ), #end tabPanel

             tabPanel("Equity Curve",
                      div(class="outer",

                          # Include our custom CSS
                          tags$head(includeCSS("styles.css")),
                          tags$div(),

                          # Controls
                          absolutePanel(id="controls", class="modal", fixed=TRUE, draggable=TRUE,
                                        top=60, left="auto", right=20, bottom="auto", width=330,
                                        height="auto",

                                        h2("Controls"),

                                        # account, portfolio, symbol
                                        fluidRow(
                                          column(width=4,
                                                 selectInput("account_eqc", label="Account",
                                                             choices=c("Choose an account"="", accounts))
                                          ),
                                          column(width=4,
                                                 conditionalPanel("input.account_eqc",
                                                                  selectInput("portfolio_eqc", label="Portfolio",
                                                                              choices=c("Choose a portfolio"=""))
                                                 )
                                          ),
                                          column(width=4,
                                                 conditionalPanel("input.portfolio_eqc",
                                                                  selectInput("symbol_eqc", label="Symbol(s)",
                                                                              choices=c("Choose a symbol"=""),
                                                                              multiple=TRUE)
                                                 )
                                          )
                                        ), #end fluidRow
                                        # options
                                        fluidRow(
                                          column(width=4,
                                                 selectInput("scale_eqc", label="Scale",
                                                             choices=c("Cash"="cash",
                                                                       "Tick"="tick"))
                                          )
                                        ) #end fluidRow
                          ), #end absolutePanel
                          plotOutput("chartEquityCurve", width="100%", height="100%")
                      ) #end div
             ), #end tabPanel           

             conditionalPanel("false", icon("crosshair"))
  ) #end navbarPage
) #end shinyUI
