library(magick)
library(jpeg)

# set the path to the folder containing the images
path <- "dandelions"

# get the list of all JPEG files in the folder
filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)

# iterate over each file in the folder
for (file in filelist) {
  # read the image
  img <- image_read(file)
  
  # convert the image to grayscale
  gray <- image_convert(img, colorspace = "gray")
  
  # write the filtered image to a new file
  new_file <- sub(".jpg", "_gray.jpg", file)
  image_write(gray, new_file)
}

# set the path to the folder containing the images
path2 <- "grass"

# get the list of all JPEG files in the folder
filelist2 <- list.files(path2, pattern = ".jpg", full.names = TRUE)

# iterate over each file in the folder
for (file in filelist2) {
  # read the image
  img <- image_read(file)
  
  # convert the image to grayscale
  gray <- image_convert(img, colorspace = "gray")
  
  # write the filtered image to a new file
  new_file2 <- sub(".jpg", "_gray.jpg", file)
  image_write(gray, new_file2)
}

