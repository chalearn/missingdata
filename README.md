# Missing data experiments
This repository contains a framework to generate, impute and analize missing data and imputation bias on different datasets. We have developed different missing data mechanisms: both MCAR and MAR; and different imputation methods: median and SVD. Our goal is to study the risk/benefit tradeoff of missing value imputation in the context of feature selection. We caution against using imputation methods that may yield false positives: features not associated to the target becoming dependent as a result of imputation. We also investigate situations in which imputing missing values may be beneficial to reduce false negatives. We have stored a dataset called Gissette, which we have used as a base example to perform the experimentation. Due to the size of the files we have only been able to provide the original dataset (without missingess and imputed datasets).

## Repository content
- **data**: Folder to store the original, missingned and imputed datasets.
- **graph**: Folder to store the resulting graphs obtained fruit of the experimentation.
- **results**: Folder to store the resulting data obtained.
- **src**: Contains the experimentation source (only Matlab implementation available at the moment).

## Experimental reproduction
1. Add all the project folders to Matlab path. 
2. Execute the example function *main_mcar_example*  or *main_mar_example* depending on the missingness type that we want to generate on Gisette dataset.
