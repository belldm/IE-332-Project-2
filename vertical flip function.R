library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(magick)
library(jpeg)
reticulate:: py_install("pillow", force = TRUE)

path <- "dandelions"
filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)

vertical_flip <- function(files)
for (file in filelist) {
  img <- image_read(file)
  vert_flip <- image_flip(img)
  
  new_file <- sub(".jpg", "_vertflip.jpg", file)
  image_write(vert_flip, new_file)
}

path2 <- "grass"
filelist2 <- list.files(path2, pattern = ".jpg", full.names = TRUE)

for(file in filelist2){
  img2 <- image_read(file)
  vert_flip2 <- image_flip(img2)
  
  new_file2 <- sub(".jpg", "_vertflip.jpg", file)
  image_write(vert_flip2, new_file2)
}
