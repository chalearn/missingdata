function [ error_ad ] = analyze_dataset( data_name, fs_method )
%ANALYZE_DATASET Obtain different results and plots from the analysis of
%                all imputed (restored) datasets that were previously obtained.
% INPUT:
%   data_name:  Dataset name (it must be the same as the folder where the 
%               restored dataset files are stored.
%   fs_method:  Name that represents the FS method.
%                   's2n'   - s2n (default)
%                   'ttest' - ttest
%                   'ktest' - kristin's test
% OUTPUT:
%   error_ad:   Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.
%                   2 - Incorrect dataset name requested.
%                   3 - Error in feature selection process. Please, check that
%                       fs_method name is correct.
%                   4 - Error in classification process.
%                   5 - Error when obtaining the values for precision and
%                       recall measures.
%                   6 - Error in plot process.

% Set the initial value of return variables.
error_ad = 0;

% Check the number of parameters.
if (nargin<1)
    error_ad = 1;
else
    if (nargin<2)
        fs_method = 's2n';
    end
    % Set the name of dataset folder.
    %name_orig_folder = 'orig_dataset';
    %name_miss_folder = 'miss_dataset';
    name_rest_folder = 'rest_dataset';

    % Get the different file names of the dataset.
    data_train_name = [data_name '_train'];
    data_test_name = [data_name '_test'];
    data_valid_name = [data_name '_valid'];
    data_feat_name = [data_name '_feat'];

    % Add the utils folder to Matlab path to start the file load process (including libs).
    utils_dir = ['..' filesep 'utils'];
    addpath(utils_dir);
    % Obtain the dir of each relevant folder in the repository.
    [~, datadir, graphsdir, ~, resultsdir] = load_path();

    % Obtain the dataset folder.
    %data_orig_folder = [datadir filesep name_orig_folder filesep data_name];
    %data_miss_folder = [datadir filesep name_miss_folder filesep data_name];
    data_rest_folder = [datadir filesep name_rest_folder filesep data_name];

    % Load the origin dataset, divided in train, test, validation, ...
    %[D_o, Dv_o, Dt_o, F_o, T_o, error_ld] = ...
    %        load_dataset( data_orig_folder, data_train_name, data_valid_name, ...
    %                      data_test_name, data_feat_name);

    % Create folders to save the graphs and results.
    graphs_dest_folder = [graphsdir filesep fs_method filesep data_name];
    mkdir(graphs_dest_folder);
    result_dest_folder = [resultsdir filesep fs_method filesep data_name];
    mkdir(result_dest_folder);
    
    if (exist(data_rest_folder, 'file') ~= 7)
        error_ad = 2;
    else
        aux_folds = dir(data_rest_folder);
        miss_type_fold = aux_folds(3:end);
        for t=1:length(miss_type_fold)
            type_subroute_fold = [miss_type_fold(t).name];
            mkdir([graphs_dest_folder filesep type_subroute_fold]);
            mkdir([result_dest_folder filesep type_subroute_fold]);
            aux_folds = dir([data_rest_folder filesep type_subroute_fold]);
            miss_method_fold = aux_folds(3:end);
            for m=1:length(miss_method_fold)
                method_subroute_fold = [type_subroute_fold filesep miss_method_fold(m).name];
                mkdir([graphs_dest_folder filesep method_subroute_fold]);
                mkdir([result_dest_folder filesep method_subroute_fold]);
                aux_folds = dir([data_rest_folder filesep method_subroute_fold]);
                miss_perc_fold = aux_folds(3:end);
                % Create a list of percentage value used to generate the
                % PPvsDP plot.
                for p=1:length(miss_perc_fold)
                    percent_subroute_fold = [method_subroute_fold filesep miss_perc_fold(p).name];
                    mkdir([graphs_dest_folder filesep percent_subroute_fold]);
                    mkdir([result_dest_folder filesep percent_subroute_fold]);
                    % Load the missing dataset, divided in train, test, validation, ...
                    %[D_m, Dv_m, Dt_m, F_m, T_m, error_ld] = ...
                    %                load_dataset([data_miss_folder filesep percent_subroute_fold], ...
                    %                             data_train_name, data_valid_name, ...
                    %                             data_test_name, data_feat_name);
                    aux_folds = dir([data_rest_folder filesep percent_subroute_fold]);
                    miss_sol_fold = aux_folds(3:end);
                    for s=1:length(miss_sol_fold)
                        solution_subroute_fold = [percent_subroute_fold filesep miss_sol_fold(s).name];                    
                        mkdir([graphs_dest_folder filesep solution_subroute_fold]);
                        mkdir([result_dest_folder filesep solution_subroute_fold]);
                        aux_folds = dir([data_rest_folder filesep solution_subroute_fold]);
                        miss_sol_meth_fold = aux_folds(3:end);
                        for i=1:length(miss_sol_meth_fold)
                            sol_meth_subroute_fold = [solution_subroute_fold filesep miss_sol_meth_fold(i).name];                    
                            mkdir([graphs_dest_folder filesep sol_meth_subroute_fold]);
                            mkdir([graphs_dest_folder filesep sol_meth_subroute_fold filesep 'roc_fs']);
                            mkdir([result_dest_folder filesep sol_meth_subroute_fold]);
                            % Load the restore dataset, divided in train, test, validation, ...
                            [D_r, Dv_r, Dt_r, F_r, T_r, error_ld] = ...
                                            load_dataset([data_rest_folder filesep sol_meth_subroute_fold], ...
                                                         data_train_name, data_valid_name, ...
                                                         data_test_name, data_feat_name);
                            % Feature selection process.
                            [rank_list, num_feats, fs_error] = fs_rank(fs_method, 'log2', D_r);
                            if (fs_error~=0)
                                error_ad = 3;
                                break;
                            end
                            rank_total = rank_list{end};
                            % Classification with the different feature subsets.
                            [train_mod, train_r, valid_r, test_r, error_c] = ...
                                                classif('kridge', D_r, Dv_r, Dt_r, rank_list);
                            if (error_c~=0)
                                error_ad = 4;
                                break;
                            end
                            % Obtain the precission and recall values.
                            [prec_r, error_m] = measures('prec', T_r, rank_total);
                            if (error_m~=0)
                                error_ad = 5;
                                break;
                            end
                            [recall_r, error_m] = measures('rec', T_r, rank_total);
                            if (error_m~=0)
                                error_ad = 5;
                                break;
                            end
                            T_ideal = ones(size(T_r));
                            T_ideal(rank_total(length(find(T_r==-1))+1:end)) = -1;
                            [ideal_prec_r, error_m] = measures('prec',T_ideal, rank_total);
                            if (error_m~=0)
                                error_ad = 5;
                                break;
                            end
                            [ideal_recall_r, error_m] = measures('rec',T_ideal, rank_total);
                            if (error_m~=0)
                                error_ad = 5;
                                break;
                            end
                            % Obtain the different plots for the validation subset.
                            [cell_h_auroc, h_total_auroc, h_aulc, h_aupr, auroc_v, aulc_v, aupr_v, error_gp] = ...
                                                get_plot(valid_r, prec_r, recall_r, num_feats);
                            if (error_gp~=0)
                                error_ad = 6;
                                break;
                            end

                            % Obtain the different plots for the test subset.
                            %[cell_h_auroc, h_total_auroc, h_aulc, h_aupr] = ...
                            %                    get_plot(test_r, prec_r, recall_r, num_feats);
                            for j=1:length(cell_h_auroc)
                                savefig(cell_h_auroc{j}, ...
                                        [graphs_dest_folder filesep sol_meth_subroute_fold filesep 'roc_fs' filesep 'roc_fs_' num2str(num_feats(j))]);
                            end
                            savefig(h_total_auroc, ...
                                [graphs_dest_folder filesep sol_meth_subroute_fold filesep 'roc_fs.fig']);
                            close(h_total_auroc);
                            savefig(h_aulc, ...
                                [graphs_dest_folder filesep sol_meth_subroute_fold filesep 'aulc']);
                            close(h_aulc);
                            savefig(h_aupr, ...
                                [graphs_dest_folder filesep sol_meth_subroute_fold filesep 'aupr']);                        
                            close(h_aupr);

                            save([result_dest_folder filesep sol_meth_subroute_fold filesep 'data.mat'], ...
                                 'rank_list', 'num_feats', 'train_r', 'valid_r', 'test_r', ...
                                 'train_mod', 'prec_r', 'ideal_prec_r', 'recall_r', 'ideal_recall_r', ...
                                 'auroc_v', 'aulc_v', 'aupr_v');
                        end
                    end
                end
            end
        end
        pp_vs_dp(data_name);
    end
end

