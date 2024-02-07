##Static Report Functions

# 1. Define a function to round numeric values to specified digits
round.numerics <- function(x, digits){
  if(is.numeric(x)){
    x <- round(x = x, digits = digits)
  }
  return(x)
}

# 2. Define a function to find percentage distribution for respondent variables
find_percentage <- function(data, variable) {
  breaks <- NULL
  labels <- NULL
  
  # Set breaks and labels for Age and Income
  if (variable == Age.name) {
    breaks <- Age.Groups
    labels <- Age.Group.Labels
  } else if (variable == Income.name) {
    breaks <- Income.Groups
    labels <- Income.Group.Labels
  }
  
  # If breaks and labels are provided, create groups
  if (!is.null(breaks) && !is.null(labels)) {
    group_variable <- paste(variable, "Group", sep = "_")
    data[, (group_variable) := cut(get(variable), breaks = breaks, labels = labels, include.lowest = TRUE)]
  } else {
    # If no breaks and labels, use the variable itself
    group_variable <- variable
  }
  
  # Calculate percentage distribution
  percentage_distribution <- data[, .(Percentage = .N / nrow(data) * 100), by = .(Group = get(group_variable))]
  
  # Sort the result by the variable
  setorder(percentage_distribution, Group)
  
  # Print formatted table
  cat(paste("Percentage Distribution by", variable, "\n"))
  knitr::kable(percentage_distribution, caption = paste("Percentage Distribution by", variable))
}

# 3. Define a function to get top products by Awareness rates in a specific region
top_products_awareness <- function(data, region, top_n = 5) {
  # Filter data for the specified region
  region_data <- data[get(Region.name) == region]
  
  # Calculate Awareness rates for each product
  awareness_rates <- region_data[, .(Awareness_Rate = 100 * sum(get(Awareness.name) / .N)), by = Product.name]
  
  # Order by Awareness rates in descending order and rounding off
  top_products <- awareness_rates[order(-Awareness_Rate)][1:min(5, .N)][, .(Product = get(Product.name), Awareness_Rate = round.numerics(Awareness_Rate, 2))]
  
  # Print formatted table
  cat(paste("Top", top_n, "Products by Awareness Rates in", region, "\n"))
  knitr::kable(top_products, caption = paste("Top", top_n, "Products by Awareness Rates in", region))
}


# 4. Define a function to get top products by Advocacy rates 
top_products_advocacy <- function(data, gender, income_threshold, top_n = 5) {
  # Filter data for the specified gender and income threshold
  filtered_data <- data[get(Gender.name) == gender & get(Income.name) >= income_threshold]
  
  # Calculate Advocacy rates for each product, excluding NA values
  advocacy_rates <- filtered_data[, .(Advocacy_Rate = 100 * sum(!is.na(get(Advocacy.name)) & get(Advocacy.name)) / sum(!is.na(get(Advocacy.name)))), by = Product.name]
  
  # Order by Advocacy rates in descending order and rounding off
  top_products <- advocacy_rates[order(-Advocacy_Rate)][1:min(5, .N)][, .(Product = get(Product.name), Advocacy_Rate = round.numerics(Advocacy_Rate,2))]
  
  # Print formatted table
  cat(paste("Top", top_n, "Products by Advocacy Rates among", gender, "with Income >= $", income_threshold, "\n"))
  knitr::kable(top_products, caption = paste("Top", top_n, "Products by Advocacy Rates among", gender, "with Income >= $", income_threshold))
}

# 5. Function to calculate scores for binary outcomes
calculate_binary_scores <- function(data, outcome) {
  data[, paste0(outcome, "_Score") := sum(get(outcome) == 1, na.rm = TRUE) / sum(!is.na(get(outcome))), by = Product.name]
  
  return(data)
}

# 6. Function to calculate scores for integer outcomes
calculate_integer_scores <- function(data, outcome, max_score) {
  data[, paste0(outcome, "_Score") := mean(get(outcome), na.rm = TRUE) / max_score, by = Product.name]
  
  return(data)
}

# 7. Function to calculate aggregated engagement
calc_agg <- function(data, outcome, product) {
  
  setDT(data)[, Aggregated_engagement := mean(get(outcome)[Product != product], na.rm = TRUE), by = get(id.name)]
  
  setDT(data)[is.na(Aggregated_engagement), Aggregated_engagement := 0]
  
  setDT(data)
  
}

## More Dynamic App functions

# 1. Function to create age and income groups in the survey data
create_age_income_groups <- function(data) {
  # Create Age Group variable
  data[, (AgeGroupRVName) := cut(Age, breaks = Age.Groups, labels = Age.Group.Labels, include.lowest = TRUE)]
  
  # Create Income Group variable
  data[, (IncomeGroupRVName) := cut(Income, breaks = Income.Groups, labels = Income.Group.Labels, include.lowest = TRUE)]
  
  return(data)
}

percentage.table <- function(x, digits = 1){
  tab <- table(x)
  percentage.tab <- 100*tab/(sum(tab))
  rounded.tab <- round(x = percentage.tab, digits = digits)
  return(rounded.tab)
}

# 2. Function to filter data for engagement
filter_state_of_engagement_data <- function(data, age_groups, genders, income_groups, regions, personas) {
  # Filter by Age Group
  if (!is.null(age_groups)) {
    data <- data[Age_Group %in% age_groups]
  }
  
  # Filter by Gender
  if (!is.null(genders)) {
    data <- data[Gender %in% genders]
  }
  
  # Filter by Income Group
  if (!is.null(income_groups)) {
    data <- data[Income_Group %in% income_groups]
  }
  
  # Filter by Region
  if (!is.null(regions)) {
    data <- data[Region %in% regions]
  }
  
  # Filter by Persona
  if (!is.null(personas)) {
    data <- data[Persona %in% personas]
  }
  
  return(data)
}

# 3. Function to calculate top products for selected segmented outcome
calculate_outcome_rates <- function(data, outcome, top_n = 5) {
  # Calculate outcome rates for each product
  outcome_rates <- data[, .(Outcome_Rate = 100 * sum(!is.na(get(outcome)) & get(outcome)) / sum(!is.na(get(outcome)))), by = Product.name]
  
  # Order by Outcome rates in descending order
  outcome_rates <- outcome_rates[order(-Outcome_Rate)]
  
  # Rounding off to 2 decimal places
  outcome_rates$Outcome_Rate <- round.numerics(outcome_rates$Outcome_Rate, digits = 2)
  
  # Select top products
  top_products <- outcome_rates[1:min(top_n, .N), .(Product = get(Product.name), Outcome_Rate)]
  
  return(top_products)
}

# 4. Function to display top products for selected segmented outcome
display_outcomes <- function(top_products, outcome, state_of_engagement) {
  
  # Barplot for top products
  top_products_plot <- barplot(
    height = top_products$Outcome_Rate,
    names.arg = top_products$Product,
    las = 1,
    main = paste("Top", length(top_products$Product), "Products by", outcome, "Rates in", state_of_engagement),
    ylab = paste(outcome, "Rate"),
    col = 'dodgerblue',
    cex.names = 1.1,
    cex.axis = 1.1,
    cex.lab = 1.1,
    width = 3,  # Adjust the width as needed
    xlim = c(0, 100)  # Set x-axis limits to 0-100
  )
  
  #Rotate axis by 45 degrees
  rotate_x_labels(
    height = top_products$Outcome_Rate,
    names.arg = top_products$Product,
    rot_angle = 45
  )
  
  # Add labels with percentages at the center of each bar
  if (!is.null(top_products$Outcome_Rate)) {
    
    space_val <- 0.2
    
    # Calculate the x-positions of bars
    bar_positions <- barplot(
      height = top_products$Outcome_Rate,
      names.arg = top_products$Product,
      plot = FALSE
    )
    
    # Adjust the y position for labels
    label_y <- ifelse(top_products$Outcome_Rate > 80, top_products$Outcome_Rate - 5, top_products$Outcome_Rate + space_val)
    
    text(
      x = bar_positions,
      y = label_y,
      labels = paste(sprintf("%.1f%%", top_products$Outcome_Rate)),
      pos = 3,
      offset = space_val,
      col = "black"
    )
  }
}

# 5. Function to rotate X axis labels
rotate_x_labels <- function(height, names.arg, rot_angle, ...) {
  plt <- barplot(height, names.arg = names.arg, xaxt = "n", ...)
  text(plt, par("usr")[3], labels = names.arg, srt = rot_angle, adj = c(1.1, 1.1), xpd = TRUE, cex = 0.8)
}

# 6. Function to calculate Overall Brand Perception
calculate_brand_perception <- function(data, top_k = 5) {
  
  # Compute average scores, removing missing values
  average_perceptions <- data[, lapply(.SD, mean, na.rm = TRUE), .SDcols = all_perceptions, by = .(get(Product.name))]
  
  # Rename the "get" column to the desired variable name
  setnames(average_perceptions, "get", Product.name)
  
  # Invert the scores for negative perceptions
  average_perceptions[, (negative_perceptions) := lapply(.SD, function(x) 10 - x), .SDcols = negative_perceptions]
  
  # Compute the mean of all perception scores
  average_perceptions[, Overall_Average_Perception := rowMeans(.SD, na.rm = TRUE), .SDcols = all_perceptions]
  average_perceptions[, Overall_Average_Perception := round.numerics(Overall_Average_Perception, 2)]
  
  # Rank the brands in decreasing order of Overall Average Perception scores
  top_brands <- average_perceptions[order(-Overall_Average_Perception)][1:min(top_k, .N), .(Brand = get(Product.name), Overall_Average_Perception)]
  
  return(top_brands)
}

# 7. Map Brand Perception user inputs to columns for fitting model
map_user_inputs_to_columns <- function(selected_brand_perceptions) {
  # Assuming your dataset is named 'survey'
  columns_to_select <- paste0("BP_", gsub(" ", "_", selected_brand_perceptions), "_0_10")
  columns_to_select <- intersect(columns_to_select, colnames(survey))
  return(columns_to_select)
}

# 8. Function to fit model
fit.model <- function(dt, outcome.name, input.names, model.type, digits = 3){
  library(formulaic)
  the.formula <- as.formula(paste(outcome.name, "~", paste(input.names, collapse = " + ")))
  
  if(model.type == "logistic"){
    mod <- glm(formula = the.formula, family = "binomial", data = dt)
    mod.summary <- logistic.regression.summary(glm.mod = mod, digits = digits)
  }
  if(model.type == "linear"){
    mod <- lm(formula = the.formula, data = dt)
    mod.summary <- linear.regression.summary(lm.mod = mod, digits = digits)
  }
  mod.summary.rounded <- mod.summary[, lapply(X = .SD, FUN = "round.numerics", digits = digits)]
  return(mod.summary.rounded)
}

# 9. Logistic Regression summary
logistic.regression.summary <- function(glm.mod, digits = 3, alpha = 0.05){
  library(data.table)
  glm.coefs <- as.data.table(summary(glm.mod)$coefficients, keep.rownames = TRUE)
  setnames(x = glm.coefs, old = "rn", new = "Variable")
  z <- qnorm(p = 1-alpha/2, mean = 0, sd = 1)
  glm.coefs[, Odds.Ratio := exp(Estimate)]
  glm.coefs[, OR.Lower.95 := exp(Estimate - z * `Std. Error`)]
  glm.coefs[, OR.Upper.95 := exp(Estimate + z * `Std. Error`)]
  
  return(glm.coefs[])
}

# 10. Linear Regression summary
linear.regression.summary <- function(lm.mod, digits = 3, alpha = 0.05){
  library(data.table)
  lm.coefs <- as.data.table(summary(lm.mod)$coefficients, keep.rownames = TRUE)
  setnames(x = lm.coefs, old = "rn", new = "Variable")
  
  z <- qnorm(p = 1-alpha/2, mean = 0, sd = 1)
  lm.coefs[, Coef.Lower.95 := Estimate - z * `Std. Error`]
  lm.coefs[, Coef.Upper.95 := Estimate + z * `Std. Error`]
  return(lm.coefs)
}

# 11. Function to calculate aggregated engagement for multiple products
calc_agg_multiple_product <- function(data, outcome, products_to_exclude) {
  
  setDT(data)[, Aggregated_engagement := mean(get(outcome)[!(Product %in% products_to_exclude)], na.rm = TRUE), by = get(id.name)]
  
  setDT(data)[is.na(Aggregated_engagement), Aggregated_engagement := 0]
  
  setDT(data)
  
}