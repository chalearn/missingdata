function [ cell_h_auroc, h_auroc, h_aulc, h_aupr, auc_va, AULC, AUPR, error_gp ] = ...
                            get_plot( test_r, prec_r, recall_r, num_feats )
%GET_PLOT Obtain the different plots of a training-test results.
% INPUT:
%   test_r:         
%   prec_r:         
%   recall_r:       
%   num_feats:      
% OUTPUT:
%   cell_h_auroc:   
%   h_auroc:        
%   h_aulc: 
%   h_aupr:
%   auc_va:
%   AULC:
%   AUPR:
%   error_gp:       Possible error when the function is executed:
%                       0 - No error.
%                       1 - Incorrect number of parameters.
%                       2 - Incorrect feature selection method requested.
%                       3 - Incorrect threshold method requested.

    error_gp = 0;
    num_plots = length(test_r);

    if (num_plots > 0)
        cell_h_auroc = cell(1,num_plots);
    
        % Prepare the subplots
        if (mod(num_plots,5) == 0)
            num_rows = num_plots/5;
        else num_rows = floor(num_plots/5 + 1);
        end
        
        auc_va = zeros(1,num_plots);
        sigma_va = zeros(1,num_plots);
    
        h_auroc = figure;
        for i=1:num_plots
            h_axes_auroc(i)=subplot(num_rows,5,i);
            %set(h_roc(i), 'XTick', [], 'YTick', []);
        end
        for i=1:num_plots
            [auc_va(i), sigma_va(i)] = auc(test_r{i});
            cell_h_auroc{i} = roc(test_r{i});
            %savefig(h_aux, [auroc_by_fs_folder filesep 'auroc_fs_' num2str(fn) '_' dataset_type]);
            set(cell_h_auroc{i},'Visible','off');
            tmpaxes=findobj(cell_h_auroc{i},'Type','axes');
            copyobj(allchild(tmpaxes),h_axes_auroc(i));
            title(h_axes_auroc(i),['FEATS=' num2str(num_feats(i)) '  AUROC=' num2str(auc_va(i))], 'FontSize', 7);
        end
    end
    
    % Measure the predictive power with AULC
    % Learning curve and AULC
    AULC = alc(num_feats(1:length(auc_va)), auc_va);
    h_aulc=plot_learning_curve('Learning curve', AULC, num_feats(1:length(auc_va)), auc_va, sigma_va);
    %fprintf('+++ Area under the learnign curve AULC = %5.4f +++\n', AULC);
    
    % Measure the discovery power with AUPR
    % Precision-recall curve (we use the same code...)
    AUPR = aupr(recall_r, prec_r);
    h_aupr=plot_pr_curve('PR curve', AUPR, recall_r, prec_r, []);
end

