#  Libraries ####
library(shiny)
library(ggplot2)

# Utilities ####

# Find years listed in series, return sorted list
get_years <- function(tree, all_series){
  
  tree_data <- all_series[all_series$Tree==tree, ]
    
  years <- unique(tree_data$Time)
  
  years <- sort(as.numeric(years))
    
  return(years)
}

# Plotting ####

series_flag_plot <- function(tree, year, all_series, flags){
  
  print(year)
  
  tree_data <- all_series[all_series$Tree==tree, ]
  
  series_plot <- ggplot(tree_data, aes(x=Time, y=Growth)) + geom_line() + theme_bw() + xlab("Year") + geom_hline(y=mean(tree_data$Growth)) + geom_vline(x=as.numeric(year))
  
  return(series_plot)
}

# Server ####

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
    output$suppression_data_download <- downloadHandler(
      filename = function() {
        paste('suppression-', Sys.Date(), '.csv', sep='')
      },
      content = function(file) {
        write.csv(suppression_data, file)
      }
    )
  }
  
  # Reactive UI for selecting series and years ####
  {
    output$series_list <- renderUI(      
      selectizeInput("series_selected", strong("Select series"), choices=unique(series()$Tree), series())
    )
    
    output$year_list <- renderUI(      
      selectizeInput("year_selected", strong("Select year"), choices=get_years(input$series_selected, series()))
    )
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
    output$series_plot <- renderPlot(series_flag_plot(input$series_selected, input$year_selected, series(), suppression_data))
  }
  
  # Tables of suppression results #### 
  {
#     output$series_flags <- renderDataTable()
    
#     output$suppression_data_table <- renderDataTable()
    
  }

  # Table of original ring width data #### 
  {
    output$tree_ring_data_table <- renderDataTable(series())
  }
})