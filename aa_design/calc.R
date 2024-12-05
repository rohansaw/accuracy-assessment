####################################################################################
#######          Design for stratified area estimator           ####################
####################################################################################

# Inputs
expected_overall_accuracy <- 0.85 # Target overall accuracy
minimum_sample_size <- 50         # Minimum sample size per stratum
expected_ua_high <- 0.95          # Expected user accuracy for high-confidence classes
expected_ua_low <- 0.75           # Expected user accuracy for low-confidence classes

# Area data: Replace this with actual data
maparea <- data.frame(
  map_code = c(1, 2, 3),                 # Unique codes for strata
  map_area = c(10000, 5000, 15000),      # Area of each stratum
  map_edited_class = c("Forest", "Grassland", "Urban") # Stratum names
)

# Categories for high and low confidence
categories_high <- c("Forest")
categories_low <- c("Grassland", "Urban")

# Calculate weights and expected user accuracy
maparea$wi <- maparea$map_area / sum(maparea$map_area) # Proportional weight by area
maparea$eua <- ifelse(maparea$map_edited_class %in% categories_high, 
                      expected_ua_high, 
                      expected_ua_low) # Assign expected accuracy

# Calculate standard error and weighted SE
maparea$si <- sqrt(maparea$eua * (1 - maparea$eua))  # Standard error
maparea$wisi <- maparea$wi * maparea$si              # Weighted standard error

# Overall sample size calculation
sum_wisi <- sum(maparea$wisi)
overall_sample_size <- (sum_wisi / expected_overall_accuracy)^2

# Sampling strategies: equal, proportional, adjusted
maparea$equal <- floor(overall_sample_size / nrow(maparea)) # Equal distribution
maparea$proportional <- floor(maparea$wi * overall_sample_size) # Proportional to area
maparea$adjusted <- maparea$proportional

# Ensure minimum sample size is met
maparea$adjusted[maparea$adjusted < minimum_sample_size] <- minimum_sample_size
maparea$final <- maparea$adjusted # Final sample size for each stratum

# Output the final sample size distribution
maparea_final <- maparea[, c("map_edited_class", "map_area", "wi", "eua", "final")]
print(maparea_final)
