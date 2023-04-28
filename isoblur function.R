library(imager)

# Set the path to your image folder
img_folder <- "C:/Users/giann/Documents/ie332/dandelions"

# Loop over all files in the folder with the .jpg extension
for (file in list.files(img_folder, pattern = "\\.jpg$")) {
  
  # Read in the image
  img_int <- imager::load.image(file.path(img_folder, file))
  
  # Apply Gaussian blur with a radius of 5 pixels
  blurred_img_int <- imager::isoblur(img, sigma = .01)
  
  # Create a new filename for the blurred image
  new_file <- gsub("\\.jpg$", "_blurred.jpg", file)
  
  # Write the blurred image to a new file
  imager::save.image(blurred_img, file.path(img_folder, new_file))
  
}