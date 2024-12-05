# Define the strat_sample function
strat_sample <- function(maparea_final, list_categories_hi, list_categories_lo, exp_overall, minimum_ssize, expected_ua_hi, expected_ua_lo) {
  print('Check: strat_sample')
  
  maparea <- as.data.frame(maparea_final)
  
  ############### Combine high and low confidence categories
  list_categories <- append(list_categories_hi, list_categories_lo)
  
  ############### Select only samples in selected list
  maparea$map_edited_class <- as.character(maparea$map_edited_class)
  df <- maparea[maparea$map_edited_class %in% list_categories, ]
  
  sumofmapcategories <- sum(as.numeric(df$map_area))
  df$map_area <- as.numeric(df$map_area)
  
  ############### Add a column for Weight (wi) and expected User's Accuracy (eua)
  df$wi <- df$map_area / sumofmapcategories
  df$eua <- 0
  
  ############### Account for null values in the EUA
  if (!is.null(list_categories_hi)) {
    df[df$map_edited_class %in% list_categories_hi, ]$eua <- expected_ua_hi
  }
  if (!is.null(list_categories_lo)) {
    df[df$map_edited_class %in% list_categories_lo, ]$eua <- expected_ua_lo
  }
  
  ############### Add a column for Standard Error and Weighted SE
  df$si <- sqrt(df$eua * (1 - df$eua))
  df$wisi <- df$wi * df$si
  
  ############### Compute overall sampling size
  sum.wi.si <- sum(df$wisi)
  overallsample <- (sum.wi.si / exp_overall) ^ 2
  
  ############### Compute equal, proportional, and adjusted sampling distribution
  df$equal <- floor(overallsample / nrow(df))
  df$proportional <- floor(df$wi * overallsample)
  df$min <- NA  # Initialize the column
  df$min[df$proportional < minimum_ssize] <- minimum_ssize
  df$adjprop <- df$map_area / (sum(df$map_area[df$proportional >= minimum_ssize], na.rm = TRUE))
  df$adjusted <- df$adjprop * (overallsample - sum(df$min, na.rm = TRUE))
  df$adjusted[df$adjusted < minimum_ssize] <- minimum_ssize
  df$adjusted <- floor(df$adjusted)
  df$final <- df$adjusted
  
  ############### Print outputs
  print("Sampling Data Frame:")
  print(df)
  print("Manual Sampling Data Frame:")
  print(df[, c(1, 2, 3, 8, 9, 12, 13)])
  
  ############### Return the data frame
  return(df)
}

# Define the compute_overall_sampling_size function
compute_overall_sampling_size <- function(strat_sample_func, ...) {
  print('Check: compute_overall_sampling_size')
  
  df <- strat_sample_func(...)
  size <- floor(sum(as.numeric(df$final), na.rm = TRUE))
  return(size)
}

# Example Inputs
maparea <- data.frame(  # Example format; replace with your actual data
  map_edited_class = c("class1", "class2", "class3"),
  map_area = c(27398756.84, 3164933.66, 22046348.33)
)

list_categories_hi <- c("class1")  # High-confidence categories
list_categories_lo <- c("class2", "class3")  # Low-confidence categories
exp_overall <- 0.01  # Expected overall accuracy
minimum_ssize <- 0  # Minimum sample size
expected_ua_hi <- 0.95  # Expected user's accuracy for high-confidence categories
expected_ua_lo <- 0.85  # Expected user's accuracy for low-confidence categories

# Call the stratified sampling function
df <- strat_sample(
  maparea_final = maparea, 
  list_categories_hi = list_categories_hi, 
  list_categories_lo = list_categories_lo, 
  exp_overall = exp_overall, 
  minimum_ssize = minimum_ssize, 
  expected_ua_hi = expected_ua_hi, 
  expected_ua_lo = expected_ua_lo
)

# Call the function to compute the overall sampling size
total_sample_size <- compute_overall_sampling_size(strat_sample, 
                                                   maparea_final = maparea, 
                                                   list_categories_hi = list_categories_hi, 
                                                   list_categories_lo = list_categories_lo, 
                                                   exp_overall = exp_overall, 
                                                   minimum_ssize = minimum_ssize, 
                                                   expected_ua_hi = expected_ua_hi, 
                                                   expected_ua_lo = expected_ua_lo)

# Print the total sample size
cat("Total sample size:", total_sample_size, "\n")

