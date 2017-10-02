% Load and show digits

% More info: http://clopinet.com/isabelle/Projects/ETH/Feature_Selection_w_CLOP.html
% Isabelle guyon, Oct, 2016

% There are 2 data versions:
%1) no probes = Gisette_noprobe
%2) with probes (original) = Gisette

% Set the dataset name.
dataset_name = 'Gisette';
% Set the dataset folder.
dataset_orig_type = 'orig_dataset';
% Set the dataset folder.
dataset_type = 'miss';
% Imputation method

miss_type = 'mar';
miss_meth = 'neigh_and_prod'; %{'prod','neigh_and_prod','neigh_and_prod_corr','top_image'};
imput_meth = 'svd';

mar_p = [10, 20, 40, 80];

% Get the different file names of the dataset.
data_base_name = lower(dataset_name);
data_train_name = [data_base_name '_train'];
data_test_name = [data_base_name '_test'];
data_valid_name = [data_base_name '_valid'];
data_feat_name = [data_base_name '_feat'];

% Add the utils folder to Matlab path to start the file load process (including libs).
utils_dir = '../utils';
addpath(utils_dir);
% Obtain the dir of each relevant folder in the repository.
[rootdir datadir graphsdir srcdir resultsdir] = load_path();
% Obtain the dataset folder.
dataset_folder = [datadir filesep dataset_orig_type filesep dataset_name];
% Create a folder to save the different graphs of the dataset.
aux_folder = [graphsdir filesep dataset_name];
mkdir(aux_folder);
aux_folder2 = [aux_folder filesep miss_meth];
mkdir(aux_folder2);
graphs_folder = [aux_folder2 filesep imput_meth];
mkdir(graphs_folder);
aulc_folder = [graphs_folder filesep 'aulc_' dataset_type];
mkdir(aulc_folder);
aupr_folder = [graphs_folder filesep 'aupr_' dataset_type];
mkdir(aupr_folder);
% Create a folder to save the info of the dataset.
results_folder = [resultsdir filesep dataset_name];
mkdir(results_folder);
aux_folder = [results_folder filesep miss_meth];
mkdir(aux_folder);
imputation_folder = [aux_folder filesep imput_meth];
mkdir(imputation_folder);

% Load the dataset, divided in train, test, validation, ...
[D, Dv, Dt, F, T, error_ld] = ...
    load_dataset(dataset_folder, data_train_name, data_valid_name, ...
                 data_test_name, data_feat_name);
% Take a look at the digits
%M=browse_digit(X,Y,F);
% Note: If you use the plain Gisette_noprobe, do niot load F and use
% M=browse_digit(X,Y);
% The function returns the image you were looking at when you exited

% Learn a simple model
use_spider_clop;
%my_classifier=svc({'coef0=1','degree=3','gamma=0','shrinkage=1'});

%my_classifier=kridge; % Other possible models, e.g. my_classifier=naive;
% Slightly better with normalization, but don't bother: my_model=chain({normalize, s2n('f_max=1000'),my_classifier});

for p=1:length(mar_p)
    miss_perc = mar_p(p);
    % Create a folder to save the different aurocs for each features selected
    % by feature selection methods. 
    auroc_by_fs_folder = [graphs_folder filesep 'auroc_' dataset_type '_' num2str(miss_perc)];
    mkdir(auroc_by_fs_folder);
    % Apply MAR missing data on the dataset.
    [D_miss, Dt_miss, Dv_miss] = create_missing( miss_type, miss_meth, ...
                                               miss_perc, D, Dt, Dv, F, T );
    % Apply an imputation over the missing data values.
    [D_imp, Dv_imp, Dt_imp, error_i] = imputation(imput_meth, D_miss, Dv_miss, Dt_miss);
    
    % See the picture of numbers (original / missing / imputation)
    %M=draw_digit(D, M_mcar, D_mcar);

    % Feature selection process.
    [rank_list, num_feats, fs_error] = fs_rank( 1, 1, D_imp);
    % Classification with the different feature subsets. 
    [train_mod, train_r, valid_r, test_r, prec_r, recall_r, error_cl] = ...
                        classif(1, D_imp, Dv_imp, Dt_imp, T, rank_list);
    % Obtain the different plots for the validation subset.
    [cell_h_auroc, h_total_auroc, h_aulc, h_aupr, auroc_v, aulc_v, aupr_v] = ...
                        get_plot(valid_r, prec_r, recall_r, num_feats);
    % Obtain the different plots for the test subset.
    %[cell_h_auroc, h_total_auroc, h_aulc, h_aupr] = ...
    %                    get_plot(test_r, prec_r, recall_r, num_feats);

    for i=1:length(cell_h_auroc)
        savefig(cell_h_auroc{i}, ...
                [auroc_by_fs_folder filesep 'auroc_fs_' num2str(num_feats(i))]);
    end
    savefig(h_total_auroc, [auroc_by_fs_folder filesep 'all_auroc_fs.fig']);
    close(h_total_auroc);
    savefig(h_aulc, [aulc_folder filesep 'aulc_' dataset_type '_' num2str(miss_perc)]);
    close(h_aulc);
    savefig(h_aupr, [aupr_folder filesep 'aupr_' dataset_type '_' num2str(miss_perc)]);
    close(h_aupr);

    save([imputation_folder filesep 'data_' dataset_type '_' num2str(miss_perc) '.mat'], ...
         'D_mar', 'Dt_mar', 'Dv_mar', 'M_mar', 'Mt_mar', 'Mv_mar', ...
         'rank_list', 'num_feats', 'train_r', 'valid_r', 'test_r', ...
         'train_mod', 'prec_r', 'recall_r', 'auroc_v', 'aulc_v', 'aupr_v', 'miss_perc');
end

h_miss_evol = get_miss_evolution_plot(results_folder);
savefig(h_miss_evol, [graphsdir filesep dataset_name filesep 'miss_evolution']);
close(h_miss_evol);
    
fprintf('\n ========== END =========\n');