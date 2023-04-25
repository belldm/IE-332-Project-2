library(png)

image <- readPNG("dandelionPNG.png")

# dimensions of png
width <- dim(image)[1]
height <- dim(image)[2]

# for loop to change the color of every 4th pixel
for (i in seq(1, width, by=4)) {
  for (j in seq(1, height, by=4)) {
    #change color to white in rgb
    image[i, j, ] <- c(1, 1, 1, 1) 
  }
}

writePNG(image, "4thPixel.png")
