function [ output_args ] = pp_vs_dp( dataset_name )
%PP_VS_DP Summary of this function goes here
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
            miss_perc_fold = aux_folds(4:end);
            % Create a list of percentage value used to generate the
            % PPvsDP plot.
            percent_list = cell(1,length(miss_perc_fold));
            j=1;
            for p=1:length(miss_perc_fold)
                percent_subroute_fold = [method_subroute_fold filesep miss_perc_fold(p).name];
                aux_folds = dir([result_folder filesep percent_subroute_fold]);
                miss_impt_fold = aux_folds(3:end);
                percent_list{1,p} = miss_perc_fold(p).name;
                if ( p == 1)
                    imput_list = {miss_impt_fold(:).name}';
                    aupr_array = zeros(length(miss_impt_fold),length(miss_perc_fold));
                    aulc_array = zeros(length(miss_impt_fold),length(miss_perc_fold));
                end
                for i=1:length(miss_impt_fold)
                    imput_subroute_fold = [percent_subroute_fold filesep miss_impt_fold(i).name];
                    load([result_folder filesep imput_subroute_fold filesep 'data.mat']);
                    imput_pos = find(ismember(imput_list, miss_impt_fold(i).name));
                    % Add the values of the aupr and aulc to draw the
                    % PPvsDP plot
                    aupr_array(imput_pos,j) = aupr_v;
                    aulc_array(imput_pos,j) = aulc_v;
                end
                j=j+1;
            end
            % Print the last plot (evolution of pp vs dp.
            h_miss_evol = plot_ev_curve('Evolution missing curve', 0, aulc_array, ...
                                        aupr_array, imput_list, percent_list);  
            savefig(h_miss_evol, [graphs_folder filesep method_subroute_fold filesep 'pp_vs_dp']);
            close(h_miss_evol);
        end
    end
end

