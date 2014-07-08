# Libraries
library(stringr)
library(dplR)

# Finding data
data_directory <- "./RP-exploration/data/RWL_split"
output_directory <- "./RP-exploration/data/RWL"


file_names <- list.files(data_directory)

# Identifying site by file name
site_names <- sapply(file_names, function(x){
    rough_site <- str_extract(x, pattern=".*\\(")
    site <- substr(rough_site, 1, nchar(rough_site)-1)
    return(site)
})

site_list <- unique(site_names)

# Repackaging files for each site

for (site in site_list){
  site_files <- file_names[site_names==site]
  
  series_list <- lapply(paste(data_directory, site_files, sep="/"), function(x){print(x);read.rwl(x)})
  
  series <- combine.rwl(series_list)
  
  # Saving packaged series as a single file
  write.rwl(series, paste0(output_directory, "/", site, ".rwl"))
}