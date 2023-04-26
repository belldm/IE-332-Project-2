library(tensorflow)
library(keras)

# Define the paths to your dataset
grass_data_dir <- "path/to/grass"
dandelions_data_dir <- "path/to/dandelions"

# Create the data generators for each dataset
img_gen <- image_data_generator()
grass_data <- flow_images_from_directory(
  grass_data_dir,
  target_size = c(224, 224),
  batch_size = 32,
  class_mode = "binary",
  shuffle = TRUE
)
dandelions_data <- flow_images_from_directory(
  dandelions_data_dir,
  target_size = c(224, 224),
  batch_size = 32,
  class_mode = "binary",
  shuffle = TRUE
)

# Define the model you want to attack
# ...

# Define the parameters for the attack
nb_epochs <- 10
eps <- 0.2
batch_size <- 32
delta <- 0.2

# Create the UAP object
up <- universal_perturbation_fgsm(
  model=model,
  eps=eps,
  delta=delta,
  max_iter=nb_epochs,
  batch_size=batch_size
)

# Generate the UAP
up_fit <- fit_up_generator(grass_data, up)

# Apply the UAP to your datasets
X_grass <- grass_data$X
Y_grass <- grass_data$Y
X_grass_adv <- predict(up_fit, X_grass)

X_dandelions <- dandelions_data$X
Y_dandelions <- dandelions_data$Y
X_dandelions_adv <- predict(up_fit, X_dandelions)

