# This code populates the database with a table containing the data used by the app.
# Run it once before you start the app in app.R
# Note: This has to be run from within the SMU network!

library(DBI)
library(odbc)

source("credentials.R")

conn <- dbConnector(
  server   = getOption("database_server"),
  database = getOption("database_name"),
  uid      = getOption("database_userid"),
  pwd      = getOption("database_password"),
  port     = getOption("database_port")
)

### Populate database
data(faithful)
dbWriteTable(conn, "faithful", faithful)

### Query database to check that the table is there
rs <- dbGetQuery(conn, "SELECT waiting FROM faithful;")
head(rs)
hist(rs$waiting)

dbDisconnect(conn)
