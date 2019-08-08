#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

# Steps:
# 1. Open this file in RStudio.
# 2. Install the used R packages (shiny, DBI, odbc) using Tools>Install Packages...
# 3. Install needed drivers. On Windows you should be fine. On Linux you will need to install with your package manager odbc support (unixodbc-dev) and the SQLServer driver (tdsodbc).
# 4. Add your database credentials to credentials.R
# 5. Run the populateDB.R script once to add the data used by this app to the database.

# Local testing:
# * Run the App locally by clicking the Run App button (green start button) when you open the app.R file.

# Deployment
# * Create a free tier account on shinyapps.io (https://www.shinyapps.io/).
# * Connect the account with RStudio under Tools>Global Options>Publishing.
# * Publish to shinyapps.io (blue symbol next to Run App). Note: This will take a while!
# * You can manage your deployed apps, check log files, etc. by logging into your dashboard on https://www.shinyapps.io 



# App Code

# Load required libraries
library(shiny)
library(DBI)
library(odbc)

# Read database credentials
source("credentials.R")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data (From Remote Database)"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        # open DB connection
        conn <- dbConnector(
            server   = getOption("database_server"),
            database = getOption("database_name"),
            uid      = getOption("database_userid"),
            pwd      = getOption("database_password"),
            port     = getOption("database_port")
        )
        on.exit(dbDisconnect(conn), add = TRUE)
        
        x <- dbGetQuery(conn, "SELECT * FROM faithful;")[, 2]
        
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
