
library(shiny)
library(pool)
library(yaml)

credentials <- yaml.load_file("../db.yml")

function(input, output) {
  pool <- NULL
  
  createPool <- function() {
    try( pool <<- dbPool(
      drv = RMySQL::MySQL(),
      dbname = credentials$dbname,
      host = credentials$host,
      username = credentials$username,
      password = credentials$password
    ))
  }
  
  # show pool
  output$dataInfo <- renderPrint({
    createPool()
    if (!is.null(pool)) dbGetInfo(pool)
    else "You do NOT have access to this database"
  })
}