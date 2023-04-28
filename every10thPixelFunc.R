library(jpeg)

pixel10th <- function (files_to_process) {
  # Process each file
  for (file in files_to_process) {
    # Read in the file
    img <- readJPEG(file)
    
    # dimensions of png
    width <- dim(img)[1]
    height <- dim(img)[2]
    
    # for loop to change the color of every 100th pixel
    for (i in seq(1, width, by=100)) {
      for (j in seq(1, height, by=100)) {
        #change color to white in rgb
        img[i, j, ] <- c(1, 1, 1)
      }
    }
    
    modified_file <- paste0("modified_", file)
    writeJPEG(img, modified_file)
  }
}

# Get a list of all jpgs in dandelion folder
all_files_d <- list.files(path = "dandelions", pattern = "\\.jpg$")
files_dandelions <- all_files_d[!grepl("modified_", all_files_d)]
pixel10th(files_dandelions)

# Get a list of all jpgs in grass folder
all_files_g <- list.files(path = "grass", pattern = "\\.jpg$")
files_grass <- all_files_g[!grepl("modified_", all_files_g)]
pixel10th(files_grass)
