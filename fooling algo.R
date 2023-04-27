install.packages("tensorflow")
install.packages("keras")
reticulate:: py_install("pillow", force = TRUE)

library(tidyverse)
library(reticulate)
library(keras)
library(tensorflow)
use_backend("tensorflow")
library(purrr)

# Load and preprocess an image to attack
img_path <- "dandelions/636597665741397587-dandelion-1097518082.jpg"
img <- keras::image_load(img_path, target_size = c(224, 224))
img <- keras::image_to_array(img)
img <- array_reshape(img, c(1, dim(img)))

# Load the binary image classifier model
model <- load_model_tf("./dandelion_model")

# Define the attack parameters
epsilon <- 0.1
loss_object <- keras::losses$BinaryCrossentropy()
grad <- keras::backend$gradients(loss_object(model$inputs, model$outputs),
                                 model$inputs)

# Compute the perturbation based on the gradient and epsilon value
perturbation <- epsilon * sign(grad[[1]])

# Add the perturbation to the input image and clip it to ensure valid pixel values
adv_img <- img + perturbation
adv_img <- pmin(1, pmax(0, adv_img))

# Evaluate the adversarial image with the binary image classifier model
pred <- model %>% predict(adv_img)

# Get the predicted class and percentage confidence
class_index <- which.max(pred)
confidence <- round(100 * pred[1,class_index], 2)

# Print the predicted class and percentage confidence
cat("The adversarial image is classified as", 
    ifelse(class_index == 1, "dandelion", "non-dandelion"), 
    "with", confidence, "% confidence.")
