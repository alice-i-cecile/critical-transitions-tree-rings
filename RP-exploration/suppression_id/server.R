#  Libraries ####
library(shiny)

shinyServer(function(input, output) {
  
  # Uploading data ####
  {
  input$series 
  
  input$old_suppression_data
  }
  
  # Downloading results ####
  {
    output$suppression_data
  }
  
  # Reactive UI for selecting series and years ####
  {
    output$series_list
    
    output$year_list
  }
  
  # Flagging suppression and release events ####
  {
    input$flag_suppression
    
    input$flag_release
    
    input$clear_flags
  }
  
  # Plot of series with flags ####
  {
    output$series_plot
  }
  
  # Tables of suppression results #### 
  {
    output$series_flags
    
    output$suppression_data_table
    
    
  }
})