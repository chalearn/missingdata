function [ cell_h_auroc, h_auroc, h_aulc, h_aupr, auc_va, AULC, AUPR ] = ...
                            get_overlay_plot( test_r, prec_r, recall_r, num_feats, ...
                            h_aulc_orig, h_aupr_orig, percent_list, position )
%GET_PLOT Summary of this function goes here
%   Detailed explanation goes here

    if (nargin<5) h_aulc_orig=[];
    end
    if (nargin<6) h_aupr_orig=[];
    end
    if (nargin<7) percent_list=[];
    end
    if (nargin<8) position=1;
    end
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
    AULC = alc(num_feats, auc_va);
    if (isempty(h_aulc_orig))
        h_aulc=overlay_learning_curve('Learning curve', AULC, num_feats, auc_va, ...
                                   sigma_va, percent_list, position);
    %fprintf('+++ Area under the learnign curve AULC = %5.4f +++\n', AULC);
    else h_aulc=overlay_learning_curve('Learning curve', AULC, num_feats, auc_va, ...
                                       sigma_va, percent_list, position, h_aulc_orig);
    end
    
    % Measure the discovery power with AUPR
    % Precision-recall curve (we use the same code...)
    AUPR = aupr(recall_r, prec_r);
    if (isempty(h_aupr_orig))
        h_aupr=overlay_pr_curve('PR curve', AUPR, recall_r, prec_r, sigma_va, ...
                                percent_list, position);
    else h_aupr=overlay_pr_curve('PR curve', AUPR, recall_r, prec_r, sigma_va, ...
                                 percent_list, position, h_aupr_orig);
    end
end

