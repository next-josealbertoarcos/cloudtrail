# Script to recover all the event names in our data set

library(purrr)
library(stringr)
library(R.utils)
library(glue)
library(jsonlite)

# Get folders
folders <- list.dirs()

pb <- progress_estimated(n = length(folders))
for(folder in folders){
  files <- list.files(path = folder, full.names = T)
  files <- files[str_detect(files, ".json")]
  event_names <- c(event_names, 
             map(.x = files, function(file) {
               read_json(file) %>% unlist(recursive = FALSE) %>% 
                 map_chr(., function(event) event$eventName) %>% unlist()
             }))
  
  pb$tick()$print()
  
}

unlist_names <- unlist(event_names)
rm(event_names)

save(unlist_names, file = "event_names.RData")

table(unlist_names) %>% sort(decreasing = TRUE)
unlist_names %>% unique() %>% .[str_detect(., "luster")]

# Event names containing the word 'cluster':
# 
# [1] "DescribeClusters"               
# [2] "DescribeClusterSnapshots"       
# [3] "DescribeClusterSecurityGroups"  
# [4] "DescribeClusterSubnetGroups"    
# [5] "DescribeClusterParameters"      
# [6] "DescribeClusterParameterGroups" 
# [7] "DeleteCluster"                  
# [8] "DeleteClusterSnapshot"          
# [9] "RestoreFromClusterSnapshot"     
# [10] "ModifyCluster"                  
# [11] "DescribeCluster"                
# [12] "DescribeOrderableClusterOptions"
# [13] "ListClusters"                   
# [14] "CreateClusterSnapshot"          
# [15] "ModifyClusterIamRoles"