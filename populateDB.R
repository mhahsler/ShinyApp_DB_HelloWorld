# This code populates the database with a table containing the data used by the app.
# Run it once before you start the app in app.R
# Note: This has to be run from within the SMU network!

library(DBI)
library(odbc)

source("credentials.R")

conn <- dbConnect(odbc::odbc(),
  Driver   = "FreeTDS",
  Server   = getOption("database_server"),
  Database = getOption("database_name"),
  UID      = getOption("database_userid"),
  PWD      = getOption("database_password"),
  Port     = getOption("database_port"),
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
