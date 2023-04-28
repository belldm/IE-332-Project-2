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

ignore_patterns <- paste("_vertflip|_noisy1%|_noise|gray", collapse = "|")

# Get a list of all jpgs in dandelion folder
all_files <- list.files(path = "dandelions", pattern = "\\.jpg$", full.names = TRUE)
files_dandelions <- all_files[!grepl(ignore_patterns, all_files)]

add_noise_to_images("dandelions")

# Get a list of all jpgs in grass folder
all_files <- list.files(path = "grass", pattern = "\\.jpg$", full.names = TRUE)
files_grass <- all_files[!grepl(ignore_patterns, all_files)]

add_noise_to_images("grass")

