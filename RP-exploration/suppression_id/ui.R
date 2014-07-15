shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Identifying suppression events in tree ring series"),
  
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
        
        # Select year
        uiOutput("year_list"),
        
        # Show plot
        plotOutput("series_plot"),

        # Flag suppression start
        actionButton("flag_suppression", "Flag start of suppression"),
        
        # Flag release event (suppression end)
        actionButton("flag_release", "Flag end of suppression (release)"),
        
        # Remove all flags
        actionButton("clear_flags", "Clear flags for this series"),
        
        # Simple counters for flag buttons
        textOutput("suppression_counter"),
        textOutput("release_counter"),
        textOutput("clear_counter"),
        
        # Show current flags for series
        dataTableOutput("series_flags")
        
      ),
      
      # View entire dataset of flagged suppression events
      tabPanel("Suppression events", dataTableOutput("suppression_data_table")),
      
      # View original dataset of tree rings
      tabPanel("Tree ring data", dataTableOutput("tree_ring_data_table"))
    ) 
  )
))