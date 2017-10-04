function [ output_args ] = analyze_dataset( dataset_name, fs_method )
%ANALYZE_DATASET 
% fs_method = s2n, ttest

    % Set the name of dataset folder.
    name_orig_folder = 'orig_dataset';
    name_miss_folder = 'miss_dataset';
    name_rest_folder = 'rest_dataset';

    % Get the different file names of the dataset.
    data_train_name = [dataset_name '_train'];
    data_test_name = [dataset_name '_test'];
    data_valid_name = [dataset_name '_valid'];
    data_feat_name = [dataset_name '_feat'];

    % Add the utils folder to Matlab path to start the file load process (including libs).
    utils_dir = ['..' filesep 'utils'];
    addpath(utils_dir);
    % Obtain the dir of each relevant folder in the repository.
    [~, datadir, graphsdir, ~, resultsdir] = load_path();
    
    % Obtain the dataset folder.
    data_orig_folder = [datadir filesep name_orig_folder filesep dataset_name];
    data_miss_folder = [datadir filesep name_miss_folder filesep dataset_name];
    data_rest_folder = [datadir filesep name_rest_folder filesep dataset_name];
    
    % Load the origin dataset, divided in train, test, validation, ...
    %[D_o, Dv_o, Dt_o, F_o, T_o, error_ld] = ...
    %        load_dataset( data_orig_folder, data_train_name, data_valid_name, ...
    %                      data_test_name, data_feat_name);
    
    % Create folders to save the graphs and results.
    graphs_dest_folder = [graphsdir filesep fs_method filesep dataset_name];
    mkdir(graphs_dest_folder);
    result_dest_folder = [resultsdir filesep fs_method filesep dataset_name];
    mkdir(result_dest_folder);

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
                        % Classification with the different feature subsets.
                        [train_mod, train_r, valid_r, test_r, error_c] = ...
                                            classif('kridge', D_r, Dv_r, Dt_r, rank_list);
                        % Obtain the precission and recall values.
                        [prec_r, error_m] = measures('prec', T_r, rank_list);
                        [recall_r, error_m] = measures('rec', T_r, rank_list);
                        % Obtain the different plots for the validation subset.
                        [cell_h_auroc, h_total_auroc, h_aulc, h_aupr, ~, ~, ~, error_gp] = ...
                                            get_plot(valid_r, prec_r, recall_r, num_feats);

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
                             'train_mod', 'prec_r', 'recall_r', 'auroc_v', 'aulc_v', 'aupr_v');
                    end
                end
            end
        end
    end
    pp_vs_dp(dataset_name);
end

