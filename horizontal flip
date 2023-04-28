library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(magick)
library(jpeg)


install_tensorflow(extra_packages="pillow")
install_keras()

path <- "dandelions"
filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)

for (file in filelist) {
  img <- image_read(file)
  horz_flip <- image_flop(img)
  
  new_file <- sub(".jpg", "_horzflip.jpg", file)
  image_write(horz_flip, new_file)
}

path2 <- "grass"
filelist2 <- list.files(path2, pattern = ".jpg", full.names = TRUE)

for(file in filelist2){
  img2 <- image_read(file)
  horz_flip2 <- image_flop(img2)
  
  new_file2 <- sub(".jpg", "_horzflip.jpg", file)
  image_write(horz_flip2, new_file2)
}
