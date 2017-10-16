function [ error_md ] = create_missing_dataset( dataset_name, missing_type, ...
                                missing_meth, missing_perc, bool_probe )
%CREATE_MISSING_DATASET Create a missing values dataset.
% INPUT:
%   dataset_name:   Name of the dataset.
%   missing_type:   Cell array with the name of missing types.
%   missing_meth:   Cell array with the name of missing methods.
%   missing_perc:   Cell array with the missing percentage values.
%   bool_probe:     
% OUTPUT:
%   error_md:       Possible error when the function is executed:
%                       0 - No error.
%                       1 - Incorrect number of parameters.
%                       2 - Incorrect dataset name.

% Set the initial value of return variables.
error_md = 0;

% Check the number of parameters.
if (nargin<1)
    error_md = 1;
elseif (isempty(dataset_name))
    error_md = 2;
else
    if (nargin<2 || isempty(missing_type))
        missing_type = {'mcar','mar'};
    end
    if (nargin<3 || isempty(missing_meth))
        mcar_t = {'flipcoin'};
        mar_t = {'prod','neigh_and_prod','neigh_and_prod_corr','top_image'};
        mnar_t = {''};
        missing_meth = cell(3,2);
        missing_meth{1,1} = 'mcar';
        missing_meth{2,1} = 'mar';
        missing_meth{3,1} = 'mnar';
        missing_meth{1,2} = mcar_t;
        missing_meth{2,2} = mar_t;
        missing_meth{3,2} = mnar_t;
    end    
    if (nargin<4 || isempty(missing_perc))
        missing_perc = [0, 30, 60, 80, 90];
    end
    if (nargin<5 || isempty(bool_probe))
        bool_probe = false;
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
    [D, Dv, Dt, F, T, error_ld] = ...
            load_dataset( data_orig_folder, data_train_name, data_valid_name, ...
                          data_test_name, data_feat_name);

    for t=1:length(missing_type)
        % Create a folder to save the missing type datasets.
        data_miss_type_folder = [data_dest_folder filesep missing_type{t}];
        mkdir(data_miss_type_folder);
        pos_method = find(strcmp(missing_meth(:,1),missing_type(t)));
        for m=1:length(missing_meth{pos_method,2})
            data_miss_method_folder = ...
                [data_miss_type_folder filesep missing_meth{pos_method,2}{m}];
            mkdir(data_miss_method_folder);
            for p=1:length(missing_perc)
                data_miss_perc_folder = ...
                    [data_miss_method_folder filesep num2str(missing_perc(p))];
                mkdir(data_miss_perc_folder);
                miss_p = missing_perc(p);
                % Apply the correspond missing mechanism.
                [D_m, Dv_m, Dt_m, error_cm] = ...
                    create_missing(missing_type{t}, missing_meth{pos_method,2}{m}, ...
                                            miss_p, D, Dv, Dt, F, T);
                if (bool_probe)
                    [D_m, Dt_m, Dv_m, T] = create_probes(D_m, Dt_m, Dv_m);
                end
                % Save dataset to the files.
                [pftrain, pfvalid, pftest, pfprob, error_sd] = ...
                            store_dataset( data_miss_perc_folder, dataset_name, ...
                                           D_m, Dv_m, Dt_m, F, T);
            end
        end
    end
end