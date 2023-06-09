reticulate:: py_install("pillow", force = TRUE)

library(keras)
res1=c("","")
f=list.files("./grass")
target_size <- c(224, 224)
for (w in f){
  test_image <- image_load(paste("./grass/",w,sep=""),
                           target_size = target_size)
  x <- image_to_array(test_image)
  x <- array_reshape(x, c(1, dim(x)))
  x <- x/255
  pred <- model %>% predict(x)
  if(pred[1,2]<0.50){
    print(w)
  }
}
print(res1)

