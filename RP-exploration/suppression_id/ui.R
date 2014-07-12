shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Identifying suppression in tree ring series"),
  
  # Sidebar with a slider input
  sidebarPanel(
    fileInput("series_file", "Upload tree ring series (.csv)"),
    
    fileInput("old_suppression_data_file", "Upload previous suppression event data to resume work"),
    
    downloadButton("suppression_data_download", "Download suppression event data")
  ),
  
  # Main panels
  mainPanel(
    tabsetPanel(
      
      # View and mark each series
      tabPanel("Series",
        
        # Select series
        uiOutput("series_list"),
        
        # Show plot
        plotOutput("series_plot"),
        
        # Select year
        uiOutput("year_list"),
        
        # Flag suppression start
        actionButton("flag_suppression", "Flag start of suppression"),
        
        # Flag release event (suppression end)
        actionButton("flag_release", "Flag end of suppression (release)"),
        
        # Remove all flags
        actionButton("clear_flags", "Clear flags for this series"),
        
        # Show current flags for series
        dataTableOutput("series_flags")
        
      ),
      
      # View entire dataset of flagged suppression events
      tabPanel("Suppression events", dataTableOutput("suppression_data_table"))
    ) 
  )
))