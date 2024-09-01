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

##### DATA PREPARATION #####

file_path_en_3.5 <- "../data_results_3.5/english.csv" # Update this path accordingly
file_path_nl_3.5 <- "../data_results_3.5/dutch.csv" # Update this path accordingly
file_path_en_4o <- "../data_results_4o/english.csv" # Update this path accordingly
file_path_nl_4o <- "../data_results_4o/dutch.csv" # Update this path accordingly

file_summary_path_en_3.5 <- "../data_results_3.5/summary_english.csv" # Update this path accordingly
file_summary_path_nl_3.5 <- "../data_results_3.5/summary_dutch.csv" # Update this path accordingly
file_summary_path_en_4o <- "../data_results_4o/summary_english.csv" # Update this path accordingly
file_summary_path_nl_4o <- "../data_results_4o/summary_dutch.csv" # Update this path accordingly

# load data and set reference demographic attributes
df <-
  read.csv(file_summary_path_nl_4o) %>%
  mutate(gender = relevel(as.factor(gender), ref="male"),
         background = relevel(as.factor(background), ref="European-American"),
         age = relevel(as.factor(age), ref="65"),
         logit_yes_prob = log(yes_prob+ 1e-10 / (1 - yes_prob) + 1e-10),
         yes_prob = ifelse(yes_prob == 0, 0.0000001, ifelse(yes_prob == 1, 0.9999999, yes_prob)))  


df_mitigation <- df %>% filter(prompt_mitigation == "nl_summary_default")

# Select only the required columns
df_selected <- df_mitigation %>%
  dplyr::select(gender, age, background, type_background, question_id, yes_prob, logit_yes_prob)

df_implicit <- df_selected %>% filter(type_background == "implicit")
df_explicit <- df_selected %>% filter(type_background == "explicit")

df_implicit$gender <- factor(df_implicit$gender, levels = c("male", "female"))
df_implicit$background <- factor(df_implicit$background, 
                                 levels = c("European-American", "African-American", 
                                            "Dutch", "Mexican", "Moroccan", "Turkish"))
df_implicit$age <- factor(df_implicit$age, 
                                 levels = c("65", "45", "25"))

df_explicit$gender <- factor(df_explicit$gender, levels = c("male", "female"))
df_explicit$background <- factor(df_explicit$background, 
                                levels = c("European-American", "African-American", 
                                            "Dutch", "Mexican", "Moroccan", "Turkish"))
df_explicit$age <- factor(df_explicit$age, 
                          levels = c("65", "45", "25"))

##### MODEL FITTING  #####

# Beta approach
beta_model <- mixed_model(yes_prob ~ background + gender + age,
                     random = ~ 1 | question_id,
                     data = df_explicit,
                     family = beta.fam())

summary(beta_model)


# Beta approach
beta_model <- mixed_model(yes_prob ~ background + gender + age,
                          random = ~ 1 | question_id,
                          data = df_implicit,
                          family = beta.fam())

summary(beta_model)

