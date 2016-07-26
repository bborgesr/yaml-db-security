
library(shiny)
library(pool)

credentials <- yaml::yaml.load_file("../db.yml")

pool <- NULL
try( pool <- dbPool(
  drv = RMySQL::MySQL(),
  dbname = credentials$dbname,
  host = credentials$host,
  username = credentials$username,
  password = credentials$password
))

function(input, output) {
  output$dataInfo <- renderPrint({
    if (!is.null(pool)) dbGetInfo(pool)
    else "You do NOT have access to this database"
  })
}