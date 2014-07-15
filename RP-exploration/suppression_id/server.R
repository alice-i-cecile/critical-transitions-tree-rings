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

# Storing flags ###

save_counters <- function(counters){
  write.csv(counters, file="temp_suppression_counters.csv")
}

load_counters <- function(){
  counters <- read.csv(file="temp_suppression_counters.csv")
  
  return(counters)
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

  # Plot of series with flags ####
  {
    output$series_plot <- renderPlot(series_flag_plot(input$series_selected, input$year_selected, series(), suppression_data))
  }

# Flagging suppression and release events ####
{
      suppression_counters <- reactive({
        
        counters <- c(Suppression=input$flag_suppression, Release=input$flag_release, Clear=input$clear_flags)
        save_counters(counters)

        return (counters)
      })
      
      suppression_data <- reactive({
          input$flag_suppression
          
          suppression_df <- isolate({
            data.frame(Event="Suppression", Tree=input$series_selected, Year=input$year_selected)
          })
          
          return(suppression_df)
        
#         new_counters <- suppression_counters()
#         
#         old_counters <- load_counters()
#         
#         if (new_counters$Suppression != old_counters$Suppression){
#           rbind
#         }
      })
      
      output$suppression_counter <- renderText(input$flag_suppression)
      output$release_counter <- renderText(input$flag_release)
      output$clear_counter <- renderText(input$clear_flags)
      
      
}

  # Tables of suppression results #### 
  {
#     output$series_flags <- renderDataTable()
    
    output$suppression_data_table <- renderDataTable(suppression_data())
    
  }

  # Table of original ring width data #### 
  {
    output$tree_ring_data_table <- renderDataTable(series())
  }
})