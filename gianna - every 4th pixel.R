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
  
  # for loop to change the color of every 4th pixel
  for (i in seq(1, width, by=10)) {
    for (j in seq(1, height, by=10)) {
      #change color to white in rgb
      image[i, j, ] <- c(1, 1, 1) 
    }
  }
  
  # Write the modified image to a new file
  writeJPEG(image, paste0(file, "_modified.jpg"))
}


library(jpeg)

# Get a list of all JPG files in the "grass" folder
file_list2 <- list.files(path = "grass", pattern = "\\.jpg$", full.names = TRUE)

# Loop over each file in the list
for (file in file_list2) {
  # Read the image
  image <- readJPEG(file)
  
  # dimensions of jpg
  width <- dim(image)[1]
  height <- dim(image)[2]
  
  # for loop to change the color of every 4th pixel
  for (i in seq(1, width, by=4)) {
    for (j in seq(1, height, by=4)) {
      #change color to white in rgb
      image[i, j, ] <- c(1, 1, 1) 
    }
  }
  
  # Write the modified image to a new file
  writeJPEG(image, paste0(file, "_modified.jpg"))
}
