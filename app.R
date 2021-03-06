library(shiny)
library(shinythemes)
library(readr)
library(dplyr)
library(coach)

source("modules/title.R")
source("modules/tab-import.R")
source("modules/tab-optimize.R")
source("modules/tab-export.R")
source("modules/tab-instructions.R")

# Define UI for application 
ui <- fluidPage(
  # Theme
  theme = shinythemes::shinytheme("cosmo"),
  
  # Title Bar
  titleBarUI("title", "Coach | DFS Lineup Optimizer", 
             github = "dfs-with-r/shinycoach", email = "robert@dfswithr.com"),

  # Sidebar layout with sidebar and main panels
  tabsetPanel(
    tabImportUI("import"),
    tabOptimizeUI("optimize"),
    tabExportUI("export"),
    tabInstructionsUI("instructions")
  )
)

# Define server logic
server <- function(input, output) {
  
  # import module
  import_reactives <- callModule(tabImport, "import")
  pool <- import_reactives[["pool"]]
  model <- import_reactives[["model"]]
  siteChoices <- import_reactives[["siteChoices"]]
  sportChoices <- import_reactives[["sportChoices"]]
  
  # optimization results
  optimize_reactives <- callModule(tabOptimize, "optimize", pool, model, siteChoices, sportChoices)
  lineups <- optimize_reactives[["lineups"]]
  
  # export lineups
  export_reactives <- callModule(tabExport, "export", lineups, siteChoices, sportChoices)
}

# Run the application 
shinyApp(ui = ui, server = server)

