function [ output_args ] = analyze_dataset( dataset_name )
%ANALYZE_DATASET Summary of this function goes here
%   Detailed explanation goes here
    
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
    [rootdir datadir graphsdir srcdir resultsdir] = load_path();
    
    % Obtain the dataset folder.
    data_orig_folder = [datadir filesep name_orig_folder filesep dataset_name];
    data_miss_folder = [datadir filesep name_miss_folder filesep dataset_name];
    data_rest_folder = [datadir filesep name_rest_folder filesep dataset_name];
    

    % Load the origin dataset, divided in train, test, validation, ...
    [D_o Dt_o Dv_o F_o T_o] = load_dataset(data_orig_folder, data_train_name, ...
                                           data_test_name, data_valid_name, ...
                                           data_feat_name);
    
    % Create folders to save the graphs and results.
    graphs_dest_folder = [graphsdir filesep dataset_name];
    mkdir(graphs_dest_folder);
    result_dest_folder = [resultsdir filesep dataset_name];
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
            percent_list = cell(1,length(miss_perc_fold));
            for p=1:length(miss_perc_fold)
                percent_subroute_fold = [method_subroute_fold filesep miss_perc_fold(p).name];
                mkdir([graphs_dest_folder filesep percent_subroute_fold]);
                mkdir([result_dest_folder filesep percent_subroute_fold]);
                % Load the missing dataset, divided in train, test, validation, ...
                [D_m Dt_m Dv_m F_m T_m] = ...
                                load_dataset([data_miss_folder filesep percent_subroute_fold], ...
                                             data_train_name, data_test_name, ...
                                             data_valid_name, data_feat_name);
                aux_folds = dir([data_rest_folder filesep percent_subroute_fold]);
                miss_impt_fold = aux_folds(3:end);
                percent_list{1,p} = miss_perc_fold(p).name;
                imput_list = {'';''}
                aupr_array = zeros(length(miss_impt_fold),length(miss_perc_fold));
                aulc_array = zeros(length(miss_impt_fold),length(miss_perc_fold));
                for i=1:length(miss_impt_fold)
                    imput_subroute_fold = [percent_subroute_fold filesep miss_impt_fold(i).name];                    
                    mkdir([graphs_dest_folder filesep imput_subroute_fold]);
                    mkdir([graphs_dest_folder filesep imput_subroute_fold filesep 'roc_fs']);
                    mkdir([result_dest_folder filesep imput_subroute_fold]);
                    % Load the restore dataset, divided in train, test, validation, ...
                    [D_r Dt_r Dv_r F_r T_r] = ...
                                    load_dataset([data_rest_folder filesep imput_subroute_fold], ...
                                                 data_train_name, data_test_name, ...
                                                 data_valid_name, data_feat_name);
                    % Feature selection process.
                    [rank_list num_feats] = fs_rank( 1, 1, D_r, Dt_r, Dv_r);
                    % Classification with the different feature subsets. 
                    [train_r, valid_r, test_r, train_mod, prec_r, recall_r] = ...
                                        classif(1, D_r, Dt_r, Dv_r, F_r, T_r, rank_list);
                    % Obtain the different plots for the validation subset.
                    [cell_h_auroc, h_total_auroc, h_aulc, h_aupr, auroc_v, aulc_v, aupr_v] = ...
                                        get_plot(valid_r, prec_r, recall_r, num_feats);
                                    
                    % Add the imput method to the list to draw the PPvsDP plot.
                    if (isempty(find(ismember(imput_list, miss_impt_fold(i).name))))
                        imput_list{i,1} = miss_impt_fold(i).name;
                    end
                    imput_pos = find(ismember(imput_list, miss_impt_fold(i).name));
                    % Add the values of the aupr and aulc to draw the
                    % PPvsDP plot
                    aupr_array(imput_pos,i) = aupr_v;
                    aulc_array(imput_pos,i) = aulc_v;

                    % Obtain the different plots for the test subset.
                    %[cell_h_auroc, h_total_auroc, h_aulc, h_aupr] = ...
                    %                    get_plot(test_r, prec_r, recall_r, num_feats);
                    for j=1:length(cell_h_auroc)
                        savefig(cell_h_auroc{j}, ...
                                [graphs_dest_folder filesep imput_subroute_fold filesep 'roc_fs' filesep 'roc_fs_' num2str(num_feats(j))]);
                    end
                    savefig(h_total_auroc, ...
                        [graphs_dest_folder filesep imput_subroute_fold filesep 'roc_fs.fig']);
                    close(h_total_auroc);
                    savefig(h_aulc, ...
                        [graphs_dest_folder filesep imput_subroute_fold filesep 'aulc']);
                    close(h_aulc);
                    savefig(h_aupr, ...
                        [graphs_dest_folder filesep imput_subroute_fold filesep 'aupr']);                        
                    close(h_aupr);

                    save([result_dest_folder filesep imput_subroute_fold filesep 'data.mat'], ...
                         'rank_list', 'num_feats', 'train_r', 'valid_r', 'test_r', ...
                         'train_mod', 'prec_r', 'recall_r', 'auroc_v', 'aulc_v', 'aupr_v');
                end
            end
            % Print the last plot (evolution of pp vs dp.
            h_miss_evol = plot_ev_curve('Evolution missing curve', 0, aupr_array, ...
                                        aulc_array, imput_list, percent_list);  
            savefig(h_miss_evol, [graphs_dest_folder filesep method_subroute_fold filesep 'pp_vs_dp']);
            close(h_miss_evol);
        end
    end
end

