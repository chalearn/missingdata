% Load and show digits

% More info: http://clopinet.com/isabelle/Projects/ETH/Feature_Selection_w_CLOP.html
% Isabelle guyon, Oct, 2016

% There are 2 data versions:
%1) no probes = Gisette_noprobe
%2) with probes (original) = Gisette

% Add the utils folder to Matlab path to start the file load process (including libs).
utils_dir = '../utils';
addpath(utils_dir);
% Obtain the dir of each relevant folder in the repository.
[rootdir datadir graphsdir srcdir resultsdir] = load_path();

% Set the dataset name.
dataset_name = 'Gisette';
% Set the dataset folder.
dataset_type = ['orig_dataset'];
dataset_folder = [datadir filesep dataset_type filesep dataset_name filesep];

% Create a folder to save the different graphs of the dataset.
graphs_folder = [graphsdir filesep dataset_name];
mkdir(graphs_folder);
% Create a folder to save the different aurocs for each features selected
% by feature selection methods. 
auroc_by_fs_folder = [graphs_folder filesep 'auroc_by_fs_' dataset_type];
mkdir(auroc_by_fs_folder);

X=load([dataset_folder 'gisette_train.data']);
Y=load([dataset_folder 'gisette_train.labels']);
F=read_label([dataset_folder 'gisette_feat.info']); % Know the identity of the probes
T=load([dataset_folder 'gisette_feat.labels']); % +1 for a real feature; -1 for a probe

% Take a look at the digits
%M=browse_digit(X,Y,F);
% Note: If you use the plain Gisette_noprobe, do niot load F and use
% M=browse_digit(X,Y);
% The function returns the image you were looking at when you exited

% Learn a simple model
use_spider_clop;
%my_classifier=svc({'coef0=1','degree=3','gamma=0','shrinkage=1'});

my_classifier=kridge; % Other possible models, e.g. my_classifier=naive;
%my_model=chain({s2n('f_max=1000'),my_classifier}); % feature selection followed by classification
% Slightly better with normalization, but don't bother: my_model=chain({normalize, s2n('f_max=1000'),my_classifier});

D = data (X, Y);
%[training_results, my_trained_model] = train(my_model, D);
%auc_tr = auc(training_results); % training_results.X = predictions, training_results.Y = targets

% Performance on validation set
Xv=load([dataset_folder 'gisette_valid.data']);
Yv=load([dataset_folder 'gisette_valid.labels']);
Dv = data (Xv, Yv);
%validation_results = test(my_trained_model, Dv);
%auc_va = auc(validation_results);

%h_auroc = roc(validation_results);
%savefig(h_auroc, [auroc_by_fs_folder filesep 'auroc_' dataset_type]);
%set(h_auroc,'Visible','off');
%close(h_auroc);
% Performance on test set
%Xt=load([dataset_folder 'gisette_test.data']);
%Yt=load([dataset_folder 'gisette_test.labels']);
%Dt = data (Xt, Yt);
%test_results = test(my_trained_model, Dt);
%auc_te = auc(test_results);

%roc(test_results);

%fprintf('AUROC results for model\n');
%my_trained_model
%fprintf('train=%5.4f\tvalid=%5.4f\ttest=%5.4f\n', auc_tr, auc_va, auc_te);
%fprintf('To show ROC curve type: roc(test_results)\n');

% Select features
my_select=s2n;
[Ds, selected_features] = train(my_select, D);
N = length(T); % Total number of features
Npos = length(find(T==1));
nmax = floor(log2(N));
feat_num = 2.^[0: nmax];
if nmax~=N, feat_num = [feat_num N]; end
auc_va = [];
sigma_va = [];
precision = [];
recall = [];

% Prepare the subplots
if (mod(length(feat_num),5) == 0)
    num_rows = length(feat_num)/5;
else num_rows = floor(length(feat_num)/5 + 1);
end
roc_fig = figure;
for i=1:length(feat_num)
    h_roc(i)=subplot(num_rows,5,i);
    %set(h_roc(i), 'XTick', [], 'YTick', []);
end

% Calculate the values and graphics
for i=1:length(feat_num)
    fn = feat_num(i);
    fprintf(' ==== Traning on %d features ===\n', fn);
    % Indices of selected features
    fidx = selected_features.fidx(1:fn);
    % Fraction of "probes"; precision = fraction of the retrieved that are relevant;
    % recall = fraction of the relevant that are retrieved
    TP = sum(T(fidx)==1);
    precision(i) = TP/fn; 
    recall(i) = TP/Npos; 
    % Success of prediction
    D = data(X(:, fidx) , Y);
    [training_results, my_trained_model] = train(my_classifier, D);
    Dv = data(X(:, fidx), Y);
    validation_results = test(my_trained_model, Dv);
    [auc_va(i), sigma_va(i)] = auc(validation_results);
    h_aux = roc(validation_results);
    savefig(h_aux, [auroc_by_fs_folder filesep 'auroc_fs_' num2str(fn) '_' dataset_type]);
    set(h_aux,'Visible','off');
    tmpaxes=findobj(h_aux,'Type','axes');
    copyobj(allchild(tmpaxes),h_roc(i));
    title(h_roc(i),['FEATS=' num2str(fn) '  AUROC=' num2str(auc_va(i))], 'FontSize', 7);
end
savefig(roc_fig, [auroc_by_fs_folder filesep 'all_auroc_fs']);
close(roc_fig);


% Measure the predictive power with AULC
% Learning curve and AULC
AULC = alc(feat_num, auc_va);
%fprintf('+++ Area under the learnign curve AULC = %5.4f +++\n', AULC);
h_aulc=plot_learning_curve('Learning curve', AULC, feat_num, auc_va, sigma_va);
savefig(h_aulc, [graphsdir filesep dataset_name filesep 'aulc_' dataset_type]);
close(h_aulc);
% Measure the discovery power with AUPR
% Precision-recall curve (we use the same code...)
AUPR = aupr(recall, precision);
h_aupr=plot_pr_curve('PR curve', AUPR, recall, precision);
savefig(h_aupr, [graphsdir filesep dataset_name filesep 'aupr_' dataset_type]);
close(h_aupr);

fprintf('\n ========== END =========\n');

%save([resultsdir filesep dataset_name '_' dataset_type])

% Todo: 
% Vary the proportion of missing data (percent = 0, 10, 20, 40, 80)
% Replace missing data by median
% Compute ALC and AUPR for all proportions of missing data


