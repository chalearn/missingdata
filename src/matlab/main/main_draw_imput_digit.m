%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%EDITABLE SOURCE
%SELECT PARAMETERS TO SHOW DIGITS FROM MISSINGNESS AND RESTORED DATASET
% Select missingness mechanism and method that will be shown.
missing_type = 'mcar';      %options: 'mcar','mar'
missing_meth = 'flipcoin';  %options: 'flipcoin','prod','neigh_and_prod',
                            %         'neigh_and_prod_corr','top_image'
% Select missingness percentage that will be shown.
missing_perc = 50;          %options: 0,10,20,30,40,50,60,70,80,90
% Select solution mechanisms and method that will be shown.
solution_type = 'imp';      %options: 'imp'
solution_meth = 'svd';      %options: 'med','svd' 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set dataset name.
dataset_name = 'Gisette';
% Set the name of dataset folder.
name_orig_folder = 'orig_dataset';
name_miss_folder = 'miss_dataset';
name_rest_folder = 'rest_dataset';

% Get the different file names of the dataset.
data_train_name = [dataset_name '_train'];
data_test_name = [dataset_name '_test'];
data_valid_name = [dataset_name '_valid'];
data_feat_name = [dataset_name '_feat'];

% Get the path of missing and restore dataset subfolders.
data_miss_subfolder = [missing_type filesep missing_meth filesep int2str(missing_perc)];
data_rest_subfolder = [data_miss_subfolder filesep solution_type filesep solution_meth];

% Add the utils folder to Matlab path to start the file load process (including libs).
utils_dir = ['..' filesep 'utils'];
addpath(utils_dir);
% Obtain the dir of each relevant folder in the repository.
[rootdir datadir graphsdir srcdir resultsdir] = load_path();

% Obtain the dataset folder.
data_orig_folder = [datadir filesep name_orig_folder filesep dataset_name];
data_miss_folder = [datadir filesep name_miss_folder filesep dataset_name filesep data_miss_subfolder];
data_rest_folder = [datadir filesep name_rest_folder filesep dataset_name filesep data_rest_subfolder];


% Load the original dataset, divided in train, test, validation, ...
[D_o, Dv_o, Dt_o, F_o, T_o, error_ld] = ...
        load_dataset( data_orig_folder, data_train_name, data_valid_name, ...
                      data_test_name, data_feat_name);
                  
% Load the missing dataset, divided in train, test, validation, ...
[D_m, Dv_m, Dt_m, F_m, T_m, error_ld] = ...
        load_dataset( data_miss_folder, data_train_name, data_valid_name, ...
                      data_test_name, data_feat_name);
                  
% Load the restore dataset, divided in train, test, validation, ...
[D_r, Dv_r, Dt_r, F_r, T_r, error_ld] = ...
        load_dataset( data_rest_folder, data_train_name, data_valid_name, ...
                      data_test_name, data_feat_name);
                  
% Show original, missing and restore digits.
draw_digit(D_o, D_m, D_r, F_o);
                  
