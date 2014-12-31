require(quantstrat)
require(shiny)
rm(list=ls())

# options
options("getSymbols.warning4.0"=FALSE)
options(shiny.trace=FALSE)

runApp()

# if some packages is not found, e.g. 'digest', then go to packages window to search and download 'digest' package. then re-run this file, then everything should be fine.
