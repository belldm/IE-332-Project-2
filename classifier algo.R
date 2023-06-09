install.packages("keras")
library(keras)
library(reticulate)
reticulate:: py_install("pillow", force = TRUE)


res1 <- c("", "")
f <- list.files("./grass")
target_size <- c(224, 224)

# Load the model
model <- load_model_hdf5("dandelion_model")

for (w in f) {
  test_image <- image_load(paste("./grass/", w, sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  
  # Use the standard pipe operator
  pred <- model %>% predict(x)
  
  if (pred[1, 1] < 0.50) {
    print(w)
  }
}

print(res1)

res2=c("","")
f=list.files("./dandelions")
for (i in f){
  test_image <- image_load(paste("./dandelions/",i,sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
  if(pred[1,1]<0.50){
    print(i)
  }
}
print(res2)