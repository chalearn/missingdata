function [ error_rd ] = ...
    restore_dataset( dataset_name, solution_type, solution_method )
%RESTORE_DATASET Restore a missing values dataset.
% INPUT:
%   dataset_name:   Name of the dataset.
%   solution_type:  Cell array with the name of solution types.
%   solution_meth:  Cell array with the name of solution methods.
% OUTPUT:
%   error_rd:       Possible error when the function is executed:
%                       0 - No error.
%                       1 - Incorrect number of parameters.
%                       2 - Incorrect dataset name.

% Set the initial value of return variables.
error_rd = 0;

% Check the number of parameters.
if (nargin<1)
    error_rd = 1;
elseif (isempty(dataset_name))
    error_rd = 2;
else
    if (nargin<2 || isempty(solution_type))
        solution_type = {'del','imp'};
    end
    if (nargin<3 || isempty(solution_method))
        del_t = {};%{'lwise', 'pwise'};
        imp_t = {'med','svd'};%,'lreg','corr'};
        solution_method = cell(2,2);
        solution_method{1,1} = 'del';
        solution_method{2,1} = 'imp';
        solution_method{1,2} = del_t;
        solution_method{2,2} = imp_t;
    end

    % Set the dataset folder.
    dataset_orig_folder = 'miss_dataset';
    % Set the dataset folder.
    dataset_dest_folder = 'rest_dataset';

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
    data_orig_folder = [datadir filesep dataset_orig_folder filesep dataset_name];
    
    % Create a folder to save the different missing datasets.
    data_dest_folder = [datadir filesep dataset_dest_folder filesep dataset_name];
    mkdir(data_dest_folder);
    
    aux_folds = dir(data_orig_folder);
    miss_type_fold = aux_folds(3:end);
    for t=1:length(miss_type_fold)
        type_orig_fold = [data_orig_folder filesep miss_type_fold(t).name];
        type_dest_fold = [data_dest_folder filesep miss_type_fold(t).name];
        mkdir(type_dest_fold);
        aux_folds = dir(type_orig_fold);
        miss_method_fold = aux_folds(3:end);
        for m=1:length(miss_method_fold)
            method_orig_fold = [type_orig_fold filesep miss_method_fold(m).name];
            method_dest_fold = [type_dest_fold filesep miss_method_fold(m).name];
            mkdir(method_dest_fold);
            aux_folds = dir(method_orig_fold);
            miss_perc_fold = aux_folds(3:end);
            for p=1:length(miss_perc_fold)
                perc_orig_fold = [method_orig_fold filesep miss_perc_fold(p).name];
                perc_dest_fold = [method_dest_fold filesep miss_perc_fold(p).name];
                mkdir(perc_dest_fold);

                % Load the missing dataset, divided in train, test, validation, ...
                [D_m, Dv_m, Dt_m, F_m, T_m, error_ld] = ...
                            load_dataset(perc_orig_fold, data_train_name, ...
                                        data_valid_name, data_test_name, ...
                                        data_feat_name);
                for t=1:length(solution_type)
                    data_solv_folder = [perc_dest_fold filesep solution_type{t}];
                    mkdir(data_solv_folder);
                    for i=1:length(solution_method)
                        data_rest_folder = [data_solv_folder filesep solution_method{i}];
                        mkdir(data_rest_folder);
                        % Apply an imputation over the missing data values.
                        [D_s, Dv_s, Dt_s, error_s] = ...
                                    solve_missing(solution_type{t}, solution_method{i}, D_m, Dv_m, Dt_m);
                        % Save dataset to the files.
                        [pftrain, pfvalid, pftest, pfprob, error_sd] = ...
                                    store_dataset( data_rest_folder, dataset_name, ...
                                                   D_s, Dv_s, Dt_s, F_m, T_m);
                    end
                end
            end
        end
    end
end