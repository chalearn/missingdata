function [ output_args ] = restore_( dataset_name, imputation_method )
%RESTORE_ Summary of this function goes here
%   Detailed explanation goes here

    % Imputation method
    if (nargin < 2)
        imputation_method = {'median','svd'};
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
                [D_m Dt_m Dv_m F_m T_m] = ...
                            load_dataset(perc_orig_fold, data_train_name, ...
                                        data_test_name, data_valid_name, ...
                                        data_feat_name);

                for i=1:length(imputation_method)
                    data_rest_folder = [perc_dest_fold filesep imputation_method{i}];
                    mkdir(data_rest_folder);
                    % Apply an imputation over the missing data values.
                    [D_r Dt_r Dv_r] = imputation(imputation_method{i}, D_m, Dt_m, Dv_m);
                    % Save the train data to the files.
                    dlmwrite([data_rest_folder filesep dataset_name '_train.data'], D_r.X, ' ');
                    dlmwrite([data_rest_folder filesep dataset_name '_train.labels'], D_r.Y, ' ');
                    % Save the test data to the files.
                    dlmwrite([data_rest_folder filesep dataset_name '_test.data'], Dt_r.X, ' ');
                    dlmwrite([data_rest_folder filesep dataset_name '_test.labels'], Dt_r.Y, ' ');
                    % Save the validation data to the files.
                    dlmwrite([data_rest_folder filesep dataset_name '_valid.data'], Dv_r.X, ' ');
                    dlmwrite([data_rest_folder filesep dataset_name '_valid.labels'], Dv_r.Y, ' ');
                    % Save the feat data to the files.
                    fileID = fopen([data_rest_folder filesep dataset_name '_feat.info'],'w');
                    fprintf(fileID,'%s\n', F_m{:});
                    fclose(fileID);
                    dlmwrite([data_rest_folder filesep dataset_name '_feat.labels'], T_m, ' ');
                end
            end
        end
    end
end