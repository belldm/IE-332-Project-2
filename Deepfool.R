install.packages("tensorflow", version = "2.3.1")
install.packages("keras", version = "2.4.3")
reticulate:: py_install("pillow", force = TRUE)

library(tidyverse)
library(reticulate)
library(keras)
library(tensorflow)
reticulate:: py_install("cleverhans", force = TRUE)
use_backend("tensorflow")
library(purrr)

# Load and preprocess an image to attack
img_path <- "dandelions/636597665741397587-dandelion-1097518082.jpg"
img <- keras::image_load(img_path, target_size = c(224, 224))
img <- keras::image_to_array(img)
img <- array_reshape(img, c(1, dim(img)))

# Load the binary image classifier model
model <- load_model_tf("./dandelion_model")

# Define a function to generate adversarial images using DeepFool
deepfool_attack <- function(model, image, max_iter = 50, epsilon = 0.02, clip_min = 0, clip_max = 1) {
  # Convert image to a tensor
  image_tensor <- array_reshape(image, dim = c(1, dim(image)))
  image_tensor <- tf$constant(image_tensor)
  
  # Remove the first dimension of the image tensor
  image_tensor <- tf$squeeze(image_tensor, axis = 0)
  
  # Predict the class probabilities for the input image
  preds <- model(image_tensor)
  
  
  # Create a copy of the input image for perturbation
  x_adv <- tf$Variable(image_tensor)
  
  # Get the number of classes in the model
  num_classes <- dim(model$output_shape)[2]
  
  # Iterate until the maximum number of iterations or until an adversarial image is found
  for (iter in 1:max_iter) {
    with(tf$GradientTape() %as% tape, {
      tape$watch(x_adv)
      preds <- model(x_adv)
      pred_class <- tf$argmax(preds, axis = 1)
      y_true <- tf$one_hot(tf$cast(pred_class, dtype=tf$int64), num_classes)
      y_true <- tf$reshape(y_true, shape = c(1, num_classes))
      loss <- keras$backend$categorical_crossentropy(y_true, preds)
      grads <- tape$gradient(loss, x_adv)
    })
    
    # Find the direction of greatest sensitivity to the decision boundary
    w_norm <- tf$linalg$norm(tf$reshape(grads, shape = c(-1, num_classes)), axis = 1)
    f_xw <- model(x_adv)
    f_xw_argmax <- tf$argmax(f_xw, axis = 1)
    
    min_dist <- tf$ones(shape = c(1)) * tf$cast(Inf, dtype = tf$float32)
    min_perturbation <- tf$zeros(shape = dim(image_tensor), dtype = tf$float32)
    
    for (k in 1:(num_classes - 1)) {
      mask <- tf$not_equal(f_xw_argmax, k)
      w_k_norm <- tf$boolean_mask(w_norm, mask)
      f_k_xw <- tf$boolean_mask(f_xw, mask)
      perturbation_k <- (w_k_norm / tf$linalg$norm(w_k_norm)) * (tf$abs(f_k_xw - f_xw[,k]) / w_k_norm)
      perturbation_k <- tf$expand_dims(perturbation_k, axis = 1)
      perturbation_k <- tf$reshape(perturbation_k, shape = dim(image_tensor))
      
      # Keep track of the perturbation with the smallest l2 distance
      dist_k <- tf$linalg$norm(perturbation_k)
      is_smaller_dist <- tf$less(dist_k, min_dist)
      min_dist <- tf$where(is_smaller_dist, dist_k, min_dist)
      min_perturbation <- tf$where(is_smaller_dist, perturbation_k, min_perturbation)
    }
    
    # Apply the perturbation to the image
    x_adv <- tf$clip_by_value(x_adv + min_perturbation, clip_min, clip_max)
    
    # Check if the perturbed image is adversarial
    preds_adv <- model(x_adv)
    pred_class_adv <- tf$cast(tf$argmax(preds_adv, axis = 1), dtype = tf$int32)
    if (tf$equal(pred_class, pred_class_adv)$numpy()) {
      # If the perturbed image is not adversarial, continue to the next iteration
      next
    } else {
      # If the perturbed image is adversarial, stop iterating and return the adversarial image
      adv_image <- keras::array_to_img(x_adv$numpy(), scale = TRUE)
      adv_path <- "dandelions/adv_dandelion.jpg"
      keras::save_img(adv_path, adv_image)
      message("Adversarial image generated and saved to ", adv_path)
      return(adv_image)
    }
  }
  
  # If the maximum number of iterations is reached and no adversarial image is found, return NULL
  message("Maximum number of iterations reached. Failed to generate an adversarial image.")
  return(NULL)
}

# Generate an adversarial image using the DeepFool algorithm
adv_image <- deepfool_attack(model, img)

# Show the original image and the adversarial image side by side
original_image <- keras::array_to_img(img, scale = TRUE)
grid.arrange(original_image, adv_image, ncol = 2, widths = c(1, 1))

        