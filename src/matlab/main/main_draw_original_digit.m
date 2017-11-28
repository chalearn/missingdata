% Set dataset name.
dataset_name = 'Gisette';
% Set the name of dataset folder.
name_orig_folder = 'orig_dataset';

% Get the different file names of the dataset.
data_train_name = [dataset_name '_train'];
data_test_name = [dataset_name '_test'];
data_valid_name = [dataset_name '_valid'];
data_feat_name = [dataset_name '_feat'];

% Add the utils folder to Matlab path to start the file load process (including libs).
utils_dir = ['..' filesep 'utils'];
addpath(utils_dir);
% Obtain the dir of each relevant folder in the repository.
[rootdir datadir graphsdir srcdir resultsdir] = load_path();

% Obtain the dataset folder.
data_orig_folder = [datadir filesep name_orig_folder filesep dataset_name];

% Load the original dataset, divided in train, test, validation, ...
[D, Dv, Dt, F, T, error_ld] = ...
        load_dataset( data_orig_folder, data_train_name, data_valid_name, ...
                      data_test_name, data_feat_name);
% Show original digits.
draw_digit(D, [], [], F);
                  
