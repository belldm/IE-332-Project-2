pixel10th <- function(input_path, output_path, pattern = "\\.jpg$") {
  # list all JPG files in the input folder
  file_list <- list.files(path = input_path, pattern = pattern, full.names = TRUE)
  
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
    
    # Write the modified image to a new file in the output folder
    new_file <- file.path(output_path, basename(sub(pattern, "_modified.jpg", file)))
    writeJPEG(image, quality = 100, new_file)
  }
}

# change all dandelion pictures
dandelionPath <- "dandelions_originals"
dandelionOutputPath <- "dandelions_modified"
dir.create(dandelionOutputPath)
pixel10th(dandelionPath, dandelionOutputPath, pattern = "\\.jpg$")

# change all grass pictures
grassPath <- "grass_originals"
grassOutputPath <- "grass_modified"
dir.create(grassOutputPath)
pixel10th(grassPath, grassOutputPath, pattern = "\\.jpg$")
