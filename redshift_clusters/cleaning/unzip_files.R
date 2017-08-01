library(purrr)
library(stringr)
library(R.utils)
library(glue)

# Get folders and uncompress files
folders <- list.dirs()

for(folder in folders){
  files <- list.files(path = folder, full.names = T)
  files <- files[str_detect(files, ".gz")]
  print(files)
  map(files, ~ system(glue("gunzip {.}")))
}
