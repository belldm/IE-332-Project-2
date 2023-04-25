library(imager)

# read in the image file
image <- load.image("dandelionPNG.png")

# apply a Gaussian blur filter with a radius of 3 pixels
image_blur <- blur(image, "gaussian", radius = 3)

# save the blurred image as a new PNG file
save.image(image_blur, "blurred.png")
