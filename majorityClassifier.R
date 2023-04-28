# load required libraries
library(imager)
library(purrr)
library(keras)
library(tensorflow)
library(tidyverse)
library(reticulate)
library(jpeg)

install_tensorflow(extra_packages="pillow")
install_keras()

ignore_patterns <- paste("_modified|_vertflip|_blurred|_blackbox|_noisy1%", collapse = "|")

all_files_d <- list.files(path = "dandelions", pattern = "\\.jpg$", full.names = TRUE)
files_dandelions <- all_files_d[!grepl(ignore_patterns, all_files_d)]
all_files_g <- list.files(path = "dandelions", pattern = "\\.jpg$", full.names = TRUE)
files_grass <- all_files_g[!grepl(ignore_patterns, all_files_g)]

add_noise_to_images("grass")
add_noise_to_images("dandelions")


target_size <- c(224,224)
rgb <- 3
model=load_model_tf("./dandelion_model")

# define the image classifier and the image-changing algorithms
classifier <- function(image) {
  f=list.files("grass")
  for (i in f){
    test_image <- image_load(paste("grass/",i,sep=""),
                             target_size = target_size)
    x <- image_to_array(test_image)
    x <- array_reshape(x, c(1, dim(x)))
    x <- x/255
    pred <- model %>% predict(x)
    if(pred[1,2]<0.50){
      print(i)
    }
  }
  
  f=list.files("dandelions")
  for (i in f){
    test_image <- image_load(paste("dandelions",i,sep=""),
                             target_size = target_size)
    x <- image_to_array(test_image)
    x <- array_reshape(x, c(1, dim(x)))
    x <- x/255
    pred <- model %>% predict(x)
    if(pred[1,1]<0.50){
      print(i)
    }
  }
}

# change 100th pixel to white
pixel10th <- function(path) {
  # list all JPG files in the folder folder
  file_list <- list.files(path = path, pattern = "\\.jpg$", full.names = TRUE)
  
  # loop over each file in the list
  for (file in file_list) {
    # read image
    image <- readJPEG(file)
    
    # dimensions of jpg
    width <- dim(image)[1]
    height <- dim(image)[2]
    
    # for loop changes every 100th pixel to white
    for (i in seq(1, width, by=100)) {
      for (j in seq(1, height, by=100)) {
        #change color to white in rgb
        image[i, j, ] <- c(1, 1, 1) 
      }
    }
    
    # Write the modified image to a new file
    writeJPEG(image, paste0(file, "_modified.jpg"))
  }
}

# vertical flip algorithm
vertical_flip <- function(path) {
  reticulate::py_install("pillow", force = TRUE)
  filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)
  
  # for loop to run through each image
  for (file in filelist) {
    img <- image_read(file)
    vert_flip <- image_flip(img)
    
    #create the new image and save
    new_file <- sub(".jpg", "_vertflip.jpg", file)
    image_write(vert_flip, new_file)
  }
}

# blur the image
isoblurFunction <- function(path) {
  files <- list.files(path, pattern = ".jpg", full.names = TRUE)
  
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

# place a black box in the center of the image, covering 1% of pixels
centered_black_box <- function(path){
  file_list <- list.files(path, pattern = ".jpg", full.names = TRUE)
  
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
    writeJPEG(image, paste0(file, "_blackbox.jpg"))
  }
}

# add noise to 1% of the image
add_noise_to_images <- function(path) {
  library(jpeg)
  library(magick)
  
  # get the list of all JPEG files in the folder
  filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)
  
  # set the proportion of pixels to modify
  proportion <- 0.01
  
  # iterate over each file in the folder
  for (file in filelist) {
    # read the image
    img <- readJPEG(file)
    
    # identify random pixels to modify
    num_pixels <- length(img)
    num_to_modify <- round(num_pixels * proportion)
    idx_to_modify <- sample(num_pixels, num_to_modify)
    
    # modify the identified pixels
    noisy_matrix <- img
    noisy_matrix[idx_to_modify] <- noisy_matrix[idx_to_modify] + rnorm(num_to_modify, mean = 0, sd = 0.1)
    
    # write the filtered image to a new file
    new_file <- sub(".jpg", "_noisy1%.jpg", file)
    writeJPEG(noisy_matrix, quality = 100, new_file)
  }
}

# load the images from a folder
folder_grass <- "grass"
images_grass <- list.files(folder_grass, full.names = TRUE)
folder_dandelions <- "dandelions"
images_dandelions <- list.files(folder_dandelions, full.names = TRUE)

# define the weights for each algorithm based on their success rate in fooling the classifier
algorithm_weights <- c(0.075, 0.125, 0.2, 0.275, 0.325)

# apply the predictor on each image
best_func <- function(images1, images2) {
  
  # read the image
  image <- load.image(image_file)
  
  # apply each algorithm to the image and get the predicted class label for each modified image
  predictions <- map_dbl(list(pixel10th, vertical_flip, isoblurFunction, centered_black_box, add_noise_to_images), function(algorithm) {
    modified_image <- algorithm(image)
    classifier(modified_image)
  })
  
  # calculate the weighted sum of probabilities for each class label
  class_probs <- c(0,0,0)
  for (i in seq_along(predictions)) {
    class_probs[predictions[i]] <- class_probs[predictions[i]] + algorithm_weights[i]
  }
  
  # return the class label with the highest weighted sum of probabilities
  return(which.max(class_probs))
}

# apply the ensemble on all images in the folder and save the predictions
best_func <- map_int(images_grass, images_dandelions, best_func)
