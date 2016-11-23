function [ output_args ] = create_missing_dataset( dataset_name, probes, ...
                                        missing_type, missing_method, ...
                                        missing_percentage )
%CREATE_MISSING_DATASET Summary of this function goes here
%   Detailed explanation goes here

    if (nargin < 2)
        probes = false;
    end
    % Imputation method
    if (nargin < 3)
        missing_type = {'mcar','mar'};
    end
    if (nargin < 4)
        mcar_t = {'flipcoin'};
        mar_t = {'prod','neigh_and_prod','neigh_and_prod_corr','top_image'};
        mnar_t = {''};
        missing_method = cell(3,2);
        missing_method{1,1} = 'mcar';
        missing_method{2,1} = 'mar';
        missing_method{3,1} = 'mnar';
        missing_method{1,2} = mcar_t;
        missing_method{2,2} = mar_t;
        missing_method{3,2} = mnar_t;
    end
    if (nargin < 5)
        missing_percentage = [0, 10, 20, 40, 80];
    end
    
    % Set the dataset folder.
    dataset_orig_folder = 'orig_dataset';
    % Set the dataset folder.
    dataset_dest_folder = 'miss_dataset';

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

    % Load the original dataset, divided in train, test, validation, ...
    [D Dt Dv F T] = load_dataset(data_orig_folder, data_train_name, data_test_name, ...
                                 data_valid_name, data_feat_name);

    for t=1:length(missing_type)
        % Create a folder to save the missing type datasets.
        data_miss_type_folder = [data_dest_folder filesep missing_type{t}];
        mkdir(data_miss_type_folder);
        pos_method = find(strcmp(missing_method(:,1),missing_type(t)));
        for m=1:length(missing_method{pos_method,2})
            data_miss_method_folder = ...
                [data_miss_type_folder filesep missing_method{pos_method,2}{m}];
            mkdir(data_miss_method_folder);
            for p=1:length(missing_percentage)
                data_miss_perc_folder = ...
                    [data_miss_method_folder filesep num2str(missing_percentage(p))];
                mkdir(data_miss_perc_folder);
                miss_p = missing_percentage(p);
                % Apply the correspond missing mechanism.
                [D_m, Dt_m, Dv_m] = missing_data( ...
                                            missing_type{t}, ...
                                            missing_method{pos_method,2}{m}, ...
                                            miss_p, D, Dt, Dv, F, T);
                if (probes)
                    [D_m, Dt_m, Dv_m, T] = create_probes(D_m, Dt_m, Dv_m);
                end
                % Save the train data to the files.
                dlmwrite([data_miss_perc_folder filesep dataset_name '_train.data'], D_m.X, ' ');
                dlmwrite([data_miss_perc_folder filesep dataset_name '_train.labels'], D_m.Y, ' ');
                % Save the test data to the files.
                dlmwrite([data_miss_perc_folder filesep dataset_name '_test.data'], Dt_m.X, ' ');
                dlmwrite([data_miss_perc_folder filesep dataset_name '_test.labels'], Dt_m.Y, ' ');
                % Save the validation data to the files.
                dlmwrite([data_miss_perc_folder filesep dataset_name '_valid.data'], Dv_m.X, ' ');
                dlmwrite([data_miss_perc_folder filesep dataset_name '_valid.labels'], Dv_m.Y, ' ');
                % Save the feat data to the files.
                fileID = fopen([data_miss_perc_folder filesep dataset_name '_feat.info'],'w');
                fprintf(fileID,'%s\n', F{:});
                fclose(fileID);
                dlmwrite([data_miss_perc_folder filesep dataset_name '_feat.labels'], T, ' ');
            end
        end
    end
end