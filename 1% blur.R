library(imager)

# Set the path to your image folder
img_folder <- "dandelions"

# Loop over all files in the folder with the .jpg extension
for (file in list.files(img_folder, pattern = "\\.jpg$")) {
  
  # Read in the image
  img <- imager::load.image(file.path(img_folder, file))
  
  # Get the dimensions of the image
  img_dims <- dim(img)
  
  # Calculate the number of pixels in the image
  num_pixels <- img_dims[1] * img_dims[2]
  
  # Calculate the number of pixels to blur (1% of total pixels)
  num_blur_pixels <- round(0.01 * num_pixels)
  
  # Randomly select 1% of the pixels
  blur_pixels <- sample(num_pixels, num_blur_pixels)
  
  # Convert the 1D index to 2D coordinates
  blur_coords <- arrayInd(blur_pixels, img_dims)
  
  # Convert the image to integer format
  img_int <- as.integer(img)
  
  # Apply Gaussian blur with a radius of 5 pixels to the selected pixels only
  img_int[blur_coords] <- imager::isoblur(img_int[blur_coords], sigma = 5)
  
  # Convert the image back to floating-point format
  img <- imager::as.cimg(img_int)
  
  # Construct the new file name with "_blurry" appended before the file extension
  new_file <- gsub("\\.jpg$", "_blurry.jpg", file)
  
  # Write the blurred image to a new file with the modified name
  imager::save.image(img, file.path(img_folder, new_file))
}


# Set the path to your image folder
img_folder2 <- "grass"

# Loop over all files in the folder with the .jpg extension
for (file in list.files(img_folder2, pattern = "\\.jpg$")) {
  
  # Read in the image
  img2 <- imager::load.image(file.path(img_folder2, file))
  
  # Apply Gaussian blur with a radius of 5 pixels
  blurred_img2 <- imager::isoblur(img2, sigma = 5)
  
  # Construct the new file name with "_blurry" appended before the file extension
  new_file <- gsub("\\.jpg$", "_blurry.jpg", file)
  
  # Write the blurred image to a new file with the modified name
  imager::save.image(blurred_img2, file.path(img_folder2, new_file))
}