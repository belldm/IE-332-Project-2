library(tidyverse)
library(keras)
library(tensorflow)
library(reticulate)
library(magick)
library(jpeg)


install_tensorflow(extra_packages="pillow")
install_keras()

path <- "dandelions"
filelist <- list.files(path, pattern = ".jpg", full.names = TRUE)

for (file in filelist) {
  img <- image_read(file)
  vert_flip <- image_flip(img)
  
  new_file <- sub(".jpg", "_vertflip.jpg", file)
  image_write(vert_flip, new_file)
}

path2 <- "grass"
filelist2 <- list.files(path2, pattern = ".jpg", full.names = TRUE)

for(file in filelist2){
  img2 <- image_read(file)
  vert_flip2 <- image_flip(img2)
  
  new_file2 <- sub(".jpg", "_vertflip.jpg", file)
  image_write(vert_flip2, new_file2)
}
res=c("","")
f=list.files("grass")
for (i in f){
  test_image <- image_load(paste("grass",i,sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
  if(pred[1,2]<0.50){
    print(i)
  }
}

res=c("","")
f=list.files("dandelions")
for (i in f){
  test_image <- image_load(paste("dandelions",i,sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
  if(pred[1,1]<0.50){
    print(i)
  }
}
print(res)

