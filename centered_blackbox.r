library(jpeg)

# Get a list of all JPG files in the "dandelions" folder
file_list <- list.files(path = "dandelions", pattern = "\\.jpg$", full.names = TRUE)

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

# Get a list of all JPG files in the "grass" folder
file_list2 <- list.files(path = "grass", pattern = "\\.jpg$", full.names = TRUE)

# Loop over each file in the list
for (file in file_list2) {
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
