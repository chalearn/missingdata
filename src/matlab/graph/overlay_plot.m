function [ output_args ] = overlay_plot( dataset_name )
%OVERLAY_PLOT Summary of this function goes here
%   Detailed explanation goes here

    % Add the utils folder to Matlab path to start the file load process (including libs).
    utils_dir = ['..' filesep 'utils'];
    addpath(utils_dir);
    % Obtain the dir of each relevant folder in the repository.
    [rootdir datadir graphsdir srcdir resultsdir] = load_path();
    
    % Obtain the dataset folder.
    result_folder = [resultsdir filesep dataset_name];
    graphs_folder = [graphsdir filesep dataset_name];
    
    aux_folds = dir(result_folder);
    miss_type_fold = aux_folds(3:end);
    for t=1:length(miss_type_fold)
        type_subroute_fold = [miss_type_fold(t).name];
        aux_folds = dir([result_folder filesep type_subroute_fold]);
        miss_method_fold = aux_folds(3:end);
        for m=1:length(miss_method_fold)
            method_subroute_fold = [type_subroute_fold filesep miss_method_fold(m).name];
            aux_folds = dir([result_folder filesep method_subroute_fold]);
            miss_perc_fold = aux_folds(3:end);
            % Create a list of percentage value used to generate the
            % PPvsDP plot.
            percent_list = cell(1,length(miss_perc_fold));
            j=1;
            for p=1:length(miss_perc_fold)
                percent_subroute_fold = [method_subroute_fold filesep miss_perc_fold(p).name];
                aux_folds = dir([result_folder filesep percent_subroute_fold]);
                miss_impt_fold = aux_folds(3:end);
                percent_list{1,p} = [miss_perc_fold(p).name ' %'];
                if ( p == 1)
                    imput_list = {miss_impt_fold(:).name}';
                    h_aupr_array = cell(length(miss_impt_fold),length(miss_perc_fold));
                    h_aulc_array = cell(length(miss_impt_fold),length(miss_perc_fold));
                end
                for i=1:length(miss_impt_fold)
                    imput_subroute_fold = [percent_subroute_fold filesep miss_impt_fold(i).name];
                    load([result_folder filesep imput_subroute_fold filesep 'data.mat']);
                    imput_pos = find(ismember(imput_list, miss_impt_fold(i).name));
                    [aux1, aux2, h_aulc_array{imput_pos,1}, h_aupr_array{imput_pos,1}, ~, ~, ~] = ...
                                        get_overlay_plot(valid_r, prec_r, recall_r, num_feats, ...
                                        h_aulc_array{imput_pos,1}, h_aupr_array{imput_pos,1}, ...
                                        percent_list, p);
                    for a=1:size(aux1,2);
                        close(aux1{a});
                    end
                    close(aux2);
                end
                j=j+1;
            end 
            for i=1:length(miss_impt_fold)
                savefig(h_aulc_array{i,1}, [graphs_folder filesep method_subroute_fold filesep 'aulc_' imput_list{i}]);
                close(h_aulc_array{i,1});
                savefig(h_aupr_array{i,1}, [graphs_folder filesep method_subroute_fold filesep 'aupr_' imput_list{i}]);
                close(h_aupr_array{i,1});
            end
        end
    end
end