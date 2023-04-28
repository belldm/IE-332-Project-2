library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(magick)
library(jpeg)
reticulate::py_install("pillow", force = TRUE)

vertical_flip <- function(filelist, output_path) {
  # create the output directory if it does not exist
  dir.create(output_path, recursive = TRUE, showWarnings = FALSE)
  
  # for loop to run through each image
  for (file in filelist) {
    img <- image_read(file)
    vert_flip <- image_flip(img)
    
    # create the new file path in the output folder
    file_name <- tools::file_path_sans_ext(basename(file))
    new_file <- file.path(output_path, paste0(file_name, "_vertflip.jpg"))
    
    image_write(vert_flip, new_file)
  }
}


# dandelion picture change
dandelionPath <- list.files("dandelion_original", pattern = "\\.jpg$", full.names = TRUE)
dandelionOutputPath <- "dandelion_vertflip"
vertical_flip(dandelionPath, output_path = dandelionOutputPath)

# grass picture change
grassPath <- list.files("grass_original", pattern = "\\.jpg$", full.names = TRUE)
grassOutputPath <- "grass_vertflip"
vertical_flip(grassPath, output_path = grassOutputPath)
