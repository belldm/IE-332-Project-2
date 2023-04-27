library(magick)

convert_to_grayscale <- function(path) {
  # get the list of all JPEG files in the folder
  filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)
  
  # iterate over each file in the folder
  for (file in filelist) {
    # check if the file name already ends in "_gray.jpg"
    if (!grepl("_gray.jpg", file)) {
      # read the image
      img <- image_read(file)
      
      # convert the image to grayscale
      gray <- image_convert(img, colorspace = "gray")
      
      # write the filtered image to a new file
      new_file <- sub(".jpg", "_gray.jpg", file)
      image_write(gray, new_file)
    }
  }
}

# call the function with the path to the folder containing the dandelion images
convert_to_grayscale("dandelions")

# call the function with the path to the folder containing the grass images
convert_to_grayscale("grass")
