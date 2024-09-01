library(dplyr)
library(tidyr)
library(ggplot2)
library(broom)
library(lme4)
library(merTools)
library(readr)
library(GLMMadaptive)
library(glmmTMB)
library(betareg)
library(lmerTest)


##### DATA PREPARATION #####

file_paths <- list(
  summary_en_3.5 = "../data_results_3.5/summary_english.csv",
  summary_nl_3.5 = "../data_results_3.5/summary_dutch.csv",
  summary_en_4o = "../data_results_4o/summary_english.csv",
  summary_nl_4o = "../data_results_4o/summary_dutch.csv",
  en_3.5 = "../data_results_3.5/english.csv",
  nl_3.5 = "../data_results_3.5/dutch.csv",
  en_4o = "../data_results_4o/english.csv",
  nl_4o = "../data_results_4o/dutch.csv"
)

# load data and set reference demographic attributes
df <-read.csv(file_paths$nl_4o) 

# Data preparation function
prepare_data <- function(df) {
  df %>%
    mutate(
      gender = relevel(factor(gender), ref = "male"),
      background = relevel(factor(background), ref = "European-American"),
      age = relevel(factor(age), ref = "65"),
      prompt_mitigation = relevel(factor(prompt_mitigation), ref = "nl_decision_default"),
      yes_prob = ifelse(yes_prob == 0, 0.0000001, ifelse(yes_prob == 1, 0.9999999, yes_prob)),
      logit_yes_prob = log(yes_prob / (1 - yes_prob))
    ) %>%
    mutate(
      gender = factor(gender, levels = c("male", "female")),
      background = factor(background, levels = c("European-American", "African-American", 
                                                 "Dutch", "Mexican", "Moroccan", "Turkish"))
    ) %>%
    dplyr::select(gender, age, background, type_background, question_id, yes_prob, logit_yes_prob, prompt_mitigation)
}


df_prepared <- prepare_data(df)

df_explicit <- df_prepared %>% filter(type_background == "explicit")
df_implicit <- df_prepared %>% filter(type_background == "implicit")


### CORRELATION ###

calculate_correlations <- function(df, reference_strategy = "nl_decision_default") {
  # Step 1: Calculate average yes_prob per question per prompt_mitigation
  df_avg_yes_prob <- df %>%
    group_by(question_id, prompt_mitigation) %>%
    summarise(avg_yes_prob = mean(yes_prob, na.rm = TRUE), .groups = 'drop')
  
  # Step 2: Reshape the data to have each mitigation strategy as a column
  df_wide <- df_avg_yes_prob %>%
    pivot_wider(names_from = prompt_mitigation, values_from = avg_yes_prob)
  
  # Check if reference_strategy exists in the data
  if (!(reference_strategy %in% names(df_wide))) {
    cat("Error: The specified reference strategy '", reference_strategy, "' was not found in the data.\n")
    cat("Available strategies are:\n")
    print(names(df_wide)[-1])  # Exclude the first column (question_id)
    return(NULL)
  }
  
  # Step 3: Calculate correlations between reference strategy and other strategies
  correlation_matrix <- cor(df_wide[,-1], use = "pairwise.complete.obs")
  correlations <- data.frame(
    term = colnames(correlation_matrix),
    reference_correlation = correlation_matrix[, reference_strategy]
  )
  
  # Remove self-correlation and sort
  correlations <- correlations %>%
    filter(term != reference_strategy) %>%
    arrange(desc(reference_correlation))
  
  # Rename the correlation column to match the reference strategy
  names(correlations)[names(correlations) == "reference_correlation"] <- reference_strategy
  
  # Print the correlations
  cat("Correlations with", reference_strategy, ":\n")
  print(correlations)
  
  return(correlations)
}

# Calculate and print correlations
correlations <- calculate_correlations(df_explicit, reference_strategy = "nl_decision_default")
correlations <- calculate_correlations(df_implicit, reference_strategy = "nl_decision_default")

