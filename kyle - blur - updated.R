install.packages("imager")
update.packages("imager")
install.packages("jpeg")
library(imager)
library(jpeg)
library(magick)

# set the path to the folder containing the images
path <- "dandelions"

# get the list of all JPEG files in the folder
filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)

# iterate over each file in the folder
for (file in filelist) {
  # read the image
  img <- imager::load.image(file)
  
  # apply a box blur filter with a radius of 3 pixels in x and y directions
  image_blur <- boxblur_xy(img, sx = 3, sy = 3) 
  # convert the image to a matrix
  image_matrix <- imager::as.array(image_blur)
  
  # write the filtered image to a new file
  new_file <- sub(".jpg", "_blur.jpg", file)
  writeJPEG(image_matrix, new_file, quality = 100)
}

# set the path to the folder containing the images
path2 <- "grass"

# get the list of all JPEG files in the folder
filelist2 <- list.files(path2, pattern = ".jpg", full.names = TRUE)

# iterate over each file in the folder
for (file in filelist2) {
  # read the image
  img2 <- image_read(file)
  
  # apply an anisotropic Gaussian blur filter with a radius of 3 pixels
  image_blur <- blur_anisotropic(img2, "gaussian", sigma = 3)
  
  # write the filtered image to a new file
  new_file2 <- sub(".jpg", "_gray.jpg", file)
  writeJPEG(image_blur, new_file2, quality = 100)
}