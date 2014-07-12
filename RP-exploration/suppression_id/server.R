#  Libraries ####
library(shiny)

shinyServer(function(input, output) {
  
  # Uploading data ####
  {
  series <- reactive({
    if(is.null(input$series_file)){
      return(NULL)
    }
    
    read.csv(input$series_file$datapath)
    
  })

  old_suppression_data <- reactive({
    if(is.null(input$old_suppression_data_file
)){
      return(NULL)
    }
    
    read.csv(input$old_suppression_data_file
$datapath)
    
  })
  
  }
  
  # Downloading results ####
  {
#     output$suppression_data_download <- downloadHandler()
  }
  
  # Reactive UI for selecting series and years ####
  {
#     output$series_list <- renderUI()
    
#     output$year_list <- renderUI()
  }
  
  # Flagging suppression and release events ####
  {
#     suppression_data <- reactive({
#       input$flag_suppression
#       
#       input$flag_release
#       
#       input$clear_flags
#     })
  }
  
  # Plot of series with flags ####
  {
#     output$series_plot <- renderPlot()
  }
  
  # Tables of suppression results #### 
  {
#     output$series_flags <- renderDataTable()
    
#     output$suppression_data_table <- renderDataTable()
    
  }
})