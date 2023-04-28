#1
library(imager)

# Set the path to your image folder
img_folder <- "kylewilson/Desktop/332 Project 2/dandelions"

# Loop over all files in the folder with the .jpg extension
for (file in list.files(img_folder, pattern = "\\.jpg$")) {
  
  # Read in the image
  img <- imager::load.image(file.path(img_folder, file))
  
  # Apply Gaussian blur with a radius of 5 pixels
  blurred_img <- imager::gaussian.blur(img, sigma = 5)
  
  # Write the blurred image back to the same file
  imager::save.image(blurred_img, file.path(img_folder, file))
}


# 2
library(imager)

isoblurFunction <- function(files, folder_path) {
  # Loop over all files in the folder with the .jpg extension
  for (file in files) {
    
    # read in the image
    img_int <- imager::load.image(file.path(folder_path, file))
    
    # apply blur, radius = 5 pixels
    blurred_img_int <- imager::isoblur(img_int, sigma = 5)
    
    # create new filename and save blurred image
    new_file <- gsub("\\.jpg$", "_blurred.jpg", file)
    imager::save.image(blurred_img_int, file.path(folder_path, new_file))
  }
}

# change dandelion pictures
dandelionPath <- list.files("dandelions", pattern = "\\.jpg$")
isoblurFunction(dandelionPath, "dandelions")

# change grass pictures
grassPath <- list.files("grass", pattern = "\\.jpg$")
isoblurFunction(grassPath, "grass")
