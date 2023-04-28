library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(magick)
library(jpeg)
reticulate::py_install("pillow", force = TRUE)

vertical_flip <- function(filelist) {
 
  # for loop to run through each image
  for (file in filelist) {
    img <- image_read(file)
    vert_flip <- image_flip(img)
    
    #create the new image and save
    new_file <- sub(".jpg", "_vertflip.jpg", file)
    image_write(vert_flip, new_file)
  }
}

# dandelion picture change
dandelionPath <- list.files("dandelion", pattern = "\\.jpg$", full.names = TRUE)
vertical_flip(dandelionPath)

# grass picture change
grassPath <- list.files("grass", pattern = "\\.jpg$", full.names = TRUE)
vertical_flip(grassPath)
