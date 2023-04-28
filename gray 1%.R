library(magick)
library(jpeg)

# set the path to the folder containing the images
path <- "dandelions"

# get the list of all JPEG files in the folder
filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)

# iterate over each file in the folder
for (file in filelist) {
  # read the image
  img <- image_read(file)
  
  # get the dimensions of the image
  dim <- dim(img)
  
  # calculate the number of pixels to convert
  num_pixels <- ceiling(0.01 * prod(dim))
  
  # randomly select 1% of the pixels in the image
  pixels_to_convert <- sample(prod(dim), num_pixels)
  
  # create a mask for the pixels to convert
  mask <- matrix(0, nrow = dim[1], ncol = dim[2])
  mask[pixels_to_convert] <- 1
  
  # convert the selected pixels to grayscale
  gray_pixels <- image_convert(img, colorspace = "gray", clip = "mask", clippath = mask)
  
  # combine the grayscale pixels with the original image
  img_new <- img * (1 - mask) + gray_pixels * mask
  
  # write the filtered image to a new file
  new_file <- sub(".jpg", "_gray.jpg", file)
  image_write(img_new, new_file)
}
