install.packages("imager")
install.packages("magick")
library(imager)
library(magick)

# set the path to the folder containing the images
path <- "dandelions"

# get the list of all JPEG files in the folder
filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)

# iterate over each file in the folder
for (file in filelist) {
  # read the image as an imager object
  img <- image_read(file)
  
  # convert the imager object to a magick object
  img_magick <- as.magick(img)
  
  # apply a box blur filter with a radius of 3 pixels in x and y directions
  image_blur <- image_blur(img_magick, "box", radius = "3x3") 
  
  # convert the magick object back to an imager object
  image_blur_imager <- as.imager(image_blur)
  
  # write the filtered image to a new file
  new_file <- sub(".jpg", "_blur.jpg", file)
  save.image(image_blur_imager, new_file, quality = 100)
}

# set the path to the folder containing the images
path2 <- "grass"

# get the list of all JPEG files in the folder
filelist2 <- list.files(path2, pattern = ".jpg", full.names = TRUE)

# iterate over each file in the folder
for (file in filelist2) {
  # read the image as an imager object
  img2 <- image_read(file)
  
  # convert the imager object to a magick object
  img2_magick <- as.magick(img2)
  
  # apply an anisotropic Gaussian blur filter with a radius of 3 pixels
  image_blur <- image_blur(img2_magick, "gaussian", sigma = "3") 
  
  # convert the magick object back to an imager object
  image_blur_imager <- as.imager(image_blur)
  
  # write the filtered image to a new file
  new_file2 <- sub(".jpg", "_gray.jpg", file)
  save.image(image_blur_imager, new_file2, quality = 100)
}
