# Cross-lingual Bias Assessment and Mitigation in LLMs

This repository contains the code and data for the paper "Discrimination by LLMs: Cross-lingual Bias Assessment and Prompt-instructed Mitigation for Decision and Summarisation Tasks" by Willem Huijzer.

## Abstract

This study investigates decision-making bias, summarisation bias, cross-lingual bias transmission, and prompt-instructed mitigation techniques in Large Language Models (LLMs). We adapted and translated 70 template texts from English to Dutch, populated with diverse demographic combinations. The research examines bias patterns across different models (GPT-3.5 and GPT-4o), languages (English and Dutch), and tasks (decision-making and summarisation).

## Directory Structure
├── data_results_3.5/                  # Results from GPT-3.5 model experiments
│   ├── dutch.csv                        # Dutch decision task results
│   ├── english.csv                      # English decision task results
│   ├── summary_dutch.csv                # Dutch summarization task results
│   └── summary_english.csv              # English summarization task results
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
