library(imager)

isoblurFunction <- function(files, folder_path) {
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

# change dandelion pictures
dandelionPath <- list.files("dandelions", pattern = "\\.jpg$")
isoblurFunction(dandelionPath, "dandelions")

# change grass pictures
grassPath <- list.files("grass", pattern = "\\.jpg$")
isoblurFunction(grassPath, "grass")
