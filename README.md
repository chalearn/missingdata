# Missing data experiments
This repository contains a framework to generate, impute and analize missing data and imputation bias on different datasets. We have developed different missing data mechanisms: both MCAR, MAR and MNAR; and different imputation methods: median and SVD. Our goal is to study the risk/benefit tradeoff of missing value imputation in the context of feature selection. We caution against using imputation methods that may yield false positives: features not associated to the target becoming dependent as a result of imputation. We also investigate situations in which imputing missing values may be beneficial to reduce false negatives.

## Repository content
- **causal_relation**: Contains main functions that allow to reproduce different causal relationships between three variables (source variable *S*, helper variable *H* and target variable *T*), allowing the generation and imputation of missing data in *S* with *H*.
- **graph**: Contains functions that graphically represent the results obtained in different causal relationships.
- **libs**: Contains base library functions used in this work.
- **statistics**: Contains different statistic functions used in this work, ranging from original T-test to different modifications of this statistic test.
- **utils**: Contains general purpose functions.

## Experimental reproduction
1. Add all the project folders to Matlab path.
2. Execute the desired function of *causal_relation* folder.
