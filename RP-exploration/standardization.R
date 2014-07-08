# Libraries ####
library(dplR)
library(dendrotoolkit)
library(stringr)
library(ggplot2)

# Configuration ####

data_directory <- "./RP-exploration/data/RWL"
tra_directory <- "./RP-exploration/data/TRA"

seperate_residuals_directory <- "./RP-exploration/residuals/seperate"
joint_residuals_directory <- "./RP-exploration/residuals/joint"

# Loading in list of data sets
file_names <- list.files(data_directory)

# Reading and merging all chronologies ####
rwl_list <- lapply(paste(data_directory, file_names, sep="/"), read.rwl)

tra_list <- lapply(rwl_list, rwl_to_tra)

site_id_list <- sapply(file_names, function(site){str_replace(site, pattern = "\\.rwl", replacement = "")})

for (site_num in 1:length(site_id_list)){
  tra_list[[site_num]]$Site <- site_id_list[site_num]
}

joint_tra <- Reduce(rbind, tra_list)
joint_tra$Time_Split <- joint_tra$Site

write.csv(joint_tra, file=paste(tra_directory, "Pr_joint.csv", sep="/"))

# Standardizing each data set seperately ####

for (site in file_names){
  
  # Identifying site name
  site_id <- str_replace(site, pattern = "\\.rwl", replacement = "")
  
  # Loading and converting data  
  rwl <- read.rwl(paste(data_directory, site, sep="/"))
  
  tra <- rwl_to_tra(rwl)
  
  # Standardizing (using ITA)
  std_output <- standardize_tra(tra, model = c("Time", "Age"), return_data = T, show_plots = F)
  
  # Show the age effect to check for issues
  # Pr03 has spike at end
  # Pr04 end is unclear
  # Pr05 shows increasing pattern after 50
  # Pr12 drops really low
  print(std_output$plots$age_effect_plot + xlab(site_id))
  
  # Saving the residuals
  write.csv(std_output$dat$residuals, file=paste0(seperate_residuals_directory, "/", site_id, "_sep_resid.csv"))
}

# Standardizing the chronologies together ####

standardize_tra(joint_tra, )


