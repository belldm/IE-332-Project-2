library(imager)

isoblurFunction <- function(files, input_folder, output_folder) {
  # create the output folder if it does not exist
  if (!file.exists(output_folder)) {
    dir.create(output_folder)
  }
  
  # Loop over all files in the folder with the .jpg extension
  for (file in files) {
    
    # read in the image
    img_int <- imager::load.image(file.path(input_folder, file))
    
    # apply blur, radius = 5 pixels
    blurred_img_int <- imager::isoblur(img_int, sigma = 5)
    
    # create new filename and save blurred image
    new_file <- gsub("\\.jpg$", "_blurred.jpg", file)
    imager::save.image(blurred_img_int, file.path(output_folder, new_file))
  }
}


# change dandelion pictures
dandelionPath <- list.files("dandelions_originals", pattern = "\\.jpg$")
isoblurFunction(dandelionPath, "dandelions_originals", "dandelions_blurred")

# change grass pictures
grassPath <- list.files("grass_originals", pattern = "\\.jpg$")
isoblurFunction(grassPath, "grass_originals", "grass_blurred")
