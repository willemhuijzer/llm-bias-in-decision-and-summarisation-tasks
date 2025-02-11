# Cross-lingual Bias Assessment and Mitigation in LLMs

This repository contains the code and data for the paper "Discrimination by LLMs: Cross-lingual Bias Assessment and Prompt-instructed Mitigation for Decision and Summarisation Tasks".

## Abstract
The rapid integration of Large Language Models (LLMs) into various domains raises concerns about societal inequalities and information bias. This study explores biases in LLMs related to background, gender, and age, focusing on their impact during decision-making and summarization tasks. Furthermore, it examines the cross-lingual propagation of these biases and evaluates the effectiveness of prompt-instructed mitigation strategies.
Using an adapted version of dataset by Tamkin et al. (2023) translated to Dutch, we created 151,200 unique prompts for the decision task and 176,400 for the summarization task, where various  demographic variables, instructions, salience levels and languages were tested on GPT-3.5 and GPT-4o.
It was observed that both models were significantly biased during decision-making, favoring female gender, younger ages, and African-American backgrounds. 
In contrast, the summarization task showed minimal evidence of bias, though significant age-related differences emerged for GPT-3.5 in English.
Cross-lingual analysis showed that despite nuances, bias patterns remained largely consistent between English and Dutch.
The newly proposed mitigation instructions demonstrated, although unable to eliminate biases, potential in reducing them. The most effective instruction achieving a 27\% reduction on average. Notably, contrary to GPT-3.5, GPT-4o displayed reduced biases for all prompts in English, indicating specific potential for prompt-based mitigation within newer models. This research underscores the importance of cautious adoption of LLMs and context-specific bias testing, highlighting the need for the continued development of effective mitigation strategies to ensure responsible deployment of AI.

## Results Data Download
Below in the directory structure, two empty folders can be found. These two folder represent the folders for gathering the results data.

For GPT-3.5 this can be downloaded via this link:
Google Drive Anonymized
For GPT-4o this can be downloaded via this link:
Google Drive Anonymized

## Directory Structure
├── data_results_3.5/                  # Results from GPT-3.5 model experiments
├── data_results_4o/                   # Results from GPT-4o model experiments
│   ├── dutch.csv                        # Dutch decision task results
│   ├── english.csv                      # English decision task results
│   ├── summary_dutch.csv                # Dutch summarization task results
│   └── summary_english.csv              # English summarization task results
├── gpt_responding/                    # Scripts for interacting with GPT models
│   ├── gpt_assistant.py                 # Python module for GPT API interactions
│   └── run_responses.ipynb              # Jupyter notebook to run experiments and collect responses
├── input_csv/                         # Input data for experiments
│   ├── dutch_setup.csv                  # Setup data for Dutch language experiments
│   ├── english_setup.csv              # Setup data for English language experiments
│   ├── setup_creation.ipynb             # Notebook to generate setup CSV files
│   ├── summary_dutch_setup.csv          # Setup data for Dutch summarization experiments
│   └── summary_english_setup.csv        # Setup data for English summarization experiments
├── input_texts/                       # Raw input texts and demographic data
│   ├── instructions.json                # Instructions for different experimental conditions
│   ├── names.json                       # Dataset of names for demographic variations
│   ├── unfilled_explicit_dutch.json     # Adjusted Template texts in Dutch with explicit demographic mentions
│   ├── unfilled_explicit_english.json   # Adjusted Template texts in English with explicit demographic mentions
│   ├── unfilled_implicit_dutch.json     # Adjusted Template texts in Dutch with implicit demographic mentions
│   └── unfilled_implicit_english.json   # Adjusted Template texts in English with implicit demographic mentions
└── r_code/                            # R scripts for statistical analysis
│   ├── beta_regression.R                # Script for beta regression analysis
│    ├── mitigation_correlation.R        # Script to analyze mitigation strategy effectiveness
└──Readme.md                           # Documentation for R code usage
└──requirements.txt                    # Required R packages for analysis


## Setup and Usage
pip install -r r_code/requirements.txt

1. Install the required dependencies:
2. Data Preparation:
- The `input_texts/` directory contains the template texts and demographic information.
- Use `input_csv/setup_creation.ipynb` to generate the input CSV files for the experiments.

3. Running Experiments:
- Execute `gpt_responding/run_responses.ipynb` to generate responses from the LLMs.
- Results are stored in the `data_results_3.5/` and `data_results_4o/` directories.

4. Analysis:
- Use the R scripts in the `r_code/` directory for statistical analysis:
  - `beta_regression.R`: Performs beta regression analysis on the results.
  - `mitigation_correlation.R`: Analyzes the effectiveness of mitigation strategies.


## Citation
If you use this code or data in your research, please cite our paper:
