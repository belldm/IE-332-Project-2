pixel10th <- function(folder_path, pattern = "\\.jpg$") {
  # list all JPG files in the folder folder
  file_list <- list.files(path = folder_path, pattern = pattern, full.names = TRUE)
  
  # loop over each file in the list
  for (file in file_list) {
    # read image
    image <- readJPEG(file)
    
    # dimensions of jpg
    width <- dim(image)[1]
    height <- dim(image)[2]
    
    # for loop changes every 100th pixel to white
    for (i in seq(1, width, by=100)) {
      for (j in seq(1, height, by=100)) {
        #change color to white in rgb
        image[i, j, ] <- c(1, 1, 1) 
      }
    }
    
    # Write the modified image to a new file
    writeJPEG(image, paste0(file, "_modified.jpg"))
  }
}

# change all dandelion pictures
dandelionPath <- "C:/Users/giann/Documents/ie332/dandelions"
pixel10th(dandelionPath, pattern = "\\.jpg$")

# change all grass pictures
grassPath <- "C:/Users/giann/Documents/ie332/grass"
pixel10th(grassPath, pattern = "\\.jpg$")
