# Missing data experiments
This repository contains a framework to generate, impute and analize missing data and imputation bias on different datasets. We have developed different missing data mechanisms: both MCAR, MAR and MNAR; and different imputation methods: median and SVD. Our goal is to study the risk/benefit tradeoff of missing value imputation in the context of feature selection. We caution against using imputation methods that may yield false positives: features not associated to the target becoming dependent as a result of imputation. We also investigate situations in which imputing missing values may be beneficial to reduce false negatives.

## Repository content
- **data**: Folder to store the original, missingned and imputed datasets.
- **graph**: Folder to store the resulting graphs obtained fruit of the experimentation.
- **results**: Folder to store the resulting data obtained.
- **src**: Contains the experimentation source (only Matlab implementation available at the moment).

## Experimental reproduction
1. Add all the project folders to Matlab path.
2. Execute the desired function of *causal_relation* folder.
