library(jpeg)

# Get a list of all JPG files in the directory
all_files <- list.files(pattern = "\\.jpg$")

# Find the files that don't match the pattern "modified_"
files_to_process <- all_files[!grepl("modified_", all_files)]

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

pixel10th(files_to_process)
