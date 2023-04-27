library(imager)

# Set the path to your image folder
img_folder <- "kylewilson/Desktop/332 Project 2/dandelions"

# Loop over all files in the folder with the .jpg extension
for (file in list.files(img_folder, pattern = "\\.jpg$")) {
  
  # Read in the image
  img <- imager::load.image(file.path(img_folder, file))
  
  # Apply Gaussian blur with a radius of 5 pixels
  blurred_img <- imager::gaussian.blur(img, sigma = 5)
  
  # Write the blurred image back to the same file
  imager::save.image(blurred_img, file.path(img_folder, file))
}
