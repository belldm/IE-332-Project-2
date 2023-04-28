add_noise_to_images <- function(input_path, output_path) {
  library(jpeg)
  library(magick)
  
  # get the list of all JPEG files in the input folder
  filelist <- list.files(input_path, pattern = ".jpg", full.names = TRUE)
  
  # create the output folder if it doesn't exist
  if (!dir.exists(output_path)) {
    dir.create(output_path)
  }
  
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
    
    # write the filtered image to a new file in the output folder
    new_file <- file.path(output_path, basename(sub(".jpg", "_noisy1%.jpg", file)))
    writeJPEG(noisy_matrix, quality = 100, new_file)
  }
}

ignore_patterns <- paste("_vertflip|_noisy1%|_noise|gray", collapse = "|")

# Get a list of all jpgs in dandelion folder
all_files <- list.files(path = "dandelions_originals", pattern = "\\.jpg$", full.names = TRUE)
files_dandelions <- all_files[!grepl(ignore_patterns, all_files)]

add_noise_to_images("dandelions_originals", "dandelions_noisy")

# Get a list of all jpgs in grass folder
all_files <- list.files(path = "grass_originals", pattern = "\\.jpg$", full.names = TRUE)
files_grass <- all_files[!grepl(ignore_patterns, all_files)]

add_noise_to_images("grass_originals", "grass_noisy")