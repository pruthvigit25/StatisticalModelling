# Dataset Analysis


## Objective Statement

The main aim of this project is to analyze the Chowdary dataset and determine the genes that have the most significant influence on the categorization of lymph node-negative breast tumors (B) and Dukes' B colon tumors (C) as cancer types. The dataset consists of 104 qualitative observations and 182 numeric columns. The objective is to determine the correlation between these variables and the classification of the disease to gain a deeper understanding of the basic biology of these cancers.

## Dataset

The Chowdary dataset consists of 104 rows and 182 columns. The second column contains information about the two types of tumors, classified as B and C. The remaining columns contain information about different gene types.

## Methodology

### Generalized Linear Models (GLMs)

Generalized linear models (GLMs) are a type of statistical model that expands upon the linear regression model to account for response variables that do not follow a normal distribution. GLMs allow for the modeling of response variables that may be binary, count, or categorical. In this project, we will use GLMs to model the correlation between gene expressions and cancer types.

### Lasso Regression

Lasso regression is a form of regularization technique used in generalized linear models, including logistic regression. The primary objective of lasso regression is to achieve a sparse model by reducing certain coefficients towards zero, selecting a subset of the most significant features while disregarding the rest. In this project, we will use lasso regression to identify the genes that have the most significant influence on cancer type classification.

## Results

The top 10 genes that most influence the cancer type designation are as follows:
- "X202286_s_at"
- "X209016_s_at"
- "X204653_at"
- "X209604_s_at"
- "X214088_s_at"
- "X209343_at"
- "X219508_at"
- "X202859_x_at"
- "X208161_s_at"
- "X201123_s_at"

These genes exhibit either a positive or negative association with cancer type designation. For example, "X202286_s_at" is negatively associated with cancer type designation, while "X214088_s_at" is positively associated.

A heatmap and box plot are also generated to visualize the gene expression levels and their distribution across cancer types B and C.

## Repository Contents

- `code.R`: The R code used for data analysis, including GLM and lasso regression.
- `data.csv`: The Chowdary dataset used for analysis.
- `README.md`: This file, providing an overview of the project and instructions.

## How to Use

To reproduce the analysis or explore the results, follow these steps:

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/your-repo.git
2. Navigate to the project directory:
   cd your-repo
3. Open the code.R file in an R environment (e.g., RStudio) to view and run the R code for data analysis.

4. The data.csv file contains the Chowdary dataset used for analysis. You can explore the dataset or modify it as needed.
