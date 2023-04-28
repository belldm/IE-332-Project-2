library(jpeg)

centered_black_box <- function(file_list, output_path) {
  # create the output directory if it does not exist
  dir.create(output_path, recursive = TRUE, showWarnings = FALSE)
  
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
    
    # Write the modified image to a new file in the output folder
    new_file <- file.path(output_path, paste0(tools::file_path_sans_ext(basename(file)), "_modified.jpg"))
    writeJPEG(image, new_file)
  }
}
# Define input and output paths for dandelion images
dandelionPath <- "dandelions_originals"
dandelionOutputPath <- "dandelions_blackbox"

# Get list of dandelion files and run function
filesDandelions <- list.files(path = dandelionPath, pattern = "\\.jpg$", full.names = TRUE)
centered_black_box(filesDandelions, output_path = dandelionOutputPath)

# Define input and output paths for grass images
grassPath <- "grass_originals"
grassOutputPath <- "grass_blackbox"

# Get list of grass files and run function
filesGrass <- list.files(path = grassPath, pattern = "\\.jpg$", full.names = TRUE)
centered_black_box(filesGrass, output_path = grassOutputPath)
