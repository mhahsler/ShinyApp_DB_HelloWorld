# Add the database credentials here.

options(database_server = "classroomdb.smu.edu")
options(database_port = 55433)
options(database_name = "your_dbname")
options(database_userid = "your_userid")
options(database_password = "your_password")

# database connector (edit at your own risk!)

dbConnector <- function(server, database, uid, pwd, port){
  
  ### run app locally
  if(Sys.getenv('SHINY_PORT') == ""){
    os <- Sys.info()['sysname']
    cat("You are running the app locally on", os, "\n")
    cat("You need to be in the SMU network.\n")
    
    if(os == "Linux") {
      cat("Using the FreeTDS database driver. You may need to install the driver.\n")
      DBI::dbConnect(odbc::odbc(),
        Driver   = "FreeTDS",
        Database = database,
        Uid      = uid,
        Pwd      = pwd,
        Server   = server,
        Port     = port,
        TDS_Version="7.2"
      )
      
    } else if(os == "Windows") {
      DBI::dbConnect(odbc::odbc(), 
        driver = "ODBC Driver 13 for SQL Server",
        server = server, 
        database = database, 
        uid = uid, 
        pwd = pwd,
        port = port
      )
      
    } else {
      cat("Unsupported OS. Please install Windows.")
      
    }
  
  ### run on Shinyapps.io (Uses FreeTDS)
  }else{
    DBI::dbConnect(odbc::odbc(),
      Driver   = "FreeTDS",
      Database = database,
      Uid      = uid,
      Pwd      = pwd,
      Server   = server,
      Port     = port,
      TDS_Version="7.2"
    )
  }
}