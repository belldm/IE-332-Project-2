install.packages("tensorflow")
tensorflow::install_tensorflow()
install.packages("keras")
install.packages("applications")
library(reticulate)
reticulate:: py_install("pillow", force = TRUE)
reticulate:: py_install("cleverhans", force = TRUE)
library(tidyverse)
library(applications)
library(keras)
library(tensorflow)
use_backend("tensorflow")
library(purrr)

# Load the binary image classifier model
model <- load_model_tf("./dandelion_model")

#load and preprocess a range of sample images from the folder dandelion
img_path <- "./dandelions/"
img <- list.files(img_path, full.names = TRUE)
img <- map(img, ~ keras::image_load(.x, target_size = c(224, 224)))
img <- map(img, keras::image_to_array)
img <- map(img, function(x) x / 255)  # scale pixel values to [0, 1]
img <- map(img, array_reshape, c(1, 224, 224, 3)) # reshape images to expected shape
img <- do.call(rbind, img)

#load and preprocess a range of sample images from the folder grass
img_path2 <- "./grass/"
img2 <- list.files(img_path2, full.names = TRUE)
img2 <- map(img2, ~ keras::image_load(.x, target_size = c(224, 224)))
img2 <- map(img2, keras::image_to_array)
img2 <- map(img2, function(x) x / 255)  # scale pixel values to [0, 1]
img2 <- map(img2, array_reshape, c(1, 224, 224, 3)) # reshape images to expected shape
img2 <- do.call(rbind, img2)



# use fgsm to change something of this image that will fool the classifier model
fgsm_attack <- function(model, x, epsilon) {
  # Preprocess the image data
  x <- keras::preprocess_input(x)
  # Compute the gradient of the loss function with respect to the input image
  grad <- k_gradient(model$output, model$input)
  # Compute the sign of the gradient
  sign_grad <- sign(grad)
  # Compute the perturbed image by adding a small epsilon to the sign of the gradient
  x_adv <- x + epsilon * sign_grad
  # Clip the perturbed image to ensure that pixel values remain within [-1, 1]
  x_adv <- clip(x_adv, -1, 1)
  # Reverse the preprocessing step to obtain the perturbed image in its original format
  x_adv <- keras::preprocess_input(x_adv, mode = "tf")
  # Return the perturbed image
  return(x_adv)
}

# generate adversarial examples using FGSM and evaluate the model's accuracy
epsilon <- 0.05 # adjust the value of epsilon to control the strength of the attack
adv_img <- map(img, ~ fgsm_attack(model, .x, epsilon))
adv_img2 <- map(img2, ~ fgsm_attack(model, .x, epsilon))
pred_adv <- predict(model, adv_img)
pred_adv2 <- predict(model, adv_img2)

# calculate the accuracy of the model on original vs. adversarial examples
acc_orig <- mean(as.numeric(pred1 > 0.5))
acc_adv <- mean(as.numeric(pred_adv > 0.5))
cat(paste0("Accuracy on original dandelion images: ", acc_orig, "\n"))
cat(paste0("Accuracy on adversarial dandelion images: ", acc_adv, "\n"))




