library(jpeg)

centered_black_box <- function(file_list){
  # Loop over each file in the list
  for (file in file_list) {
    # Read the image
    image <- readJPEG(file)
    
    # dimensions of jpg
    width <- dim(image)[1]
    height <- dim(image)[2]
    
    # define the dimensions of the black box
    box_width <- floor(width / 10)
    box_height <- floor(height / 10)
    x_center <- floor(width / 2)
    y_center <- floor(height / 2)
    
    # set the pixels inside the black box to black
    for (i in seq(x_center - floor(box_width / 2), x_center + floor(box_width / 2))) {
      for (j in seq(y_center - floor(box_height / 2), y_center + floor(box_height / 2))) {
        image[i, j, ] <- c(0, 0, 0) 
      }
    }
    
    # Write the modified image to a new file
    writeJPEG(image, paste0(file, "_modified.jpg"))
  }
}

# lists all dandelion files and runs function
filesDandelions <- list.files(path = "dandelions", pattern = "\\.jpg$", full.names = TRUE)
centered_black_box(filesDandelions)

# lists all grass files and runs function
filesGrass <- list.files(path = "grass", pattern = "\\.jpg$", full.names = TRUE)
centered_black_box(filesGrass)

