# This code populates the database with a table containing the data used by the app.
# Run it once before you start the app in app.R

library(DBI)
library(odbc)

source("credentials.R")

conn <- dbConnect(odbc::odbc(),
  Driver   = "FreeTDS",
  Server   = getOption("database_server"),
  Database = getOption("database_name"),
  UID      = getOption("database_userid"),
  PWD      = getOption("database_password"),
  Port     = 1433,
  TDS_Version="7.2"
)

### Populate database
data(faithful)
dbWriteTable(conn, "faithful", faithful)

### Query database to check that the table is there
rs <- dbGetQuery(conn, "SELECT waiting FROM faithful;")
head(rs)
hist(rs$waiting)

dbDisconnect(conn)
