function [h, error_o] = overlay_learning_curve(x, y, aulc_l, aulcerr_l, ...
                                               percent_l, pos, old_h)
%OVERLAY_LEARNING_CURVE Obtain the graph of a set of learning curves 
%                       corresponding with the values passed by parameter.
% INPUT:
%   name:       Experiment name.
%   score:      Result value.
%   x:          Number of samples.
%   y:          ROC performance.
%   e:          Error bar.
%   percent_l:  Array with percentage values to show in the plot.
%   pos:        Position of the actual line to plot.
%   old_h:      Plot handle.
% OUTPUT:
%   h:          Plot handle.    
%   error_o:    Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.

% Set the initial value of return variables.
h = [];
error_o = 0;
style_list = {'-r','-.b','-k','-.m','-b','-.k','-m','-.r'};

% Check the number of parameters.
if (nargin < 6)
    error_o = 1;
else
    if (nargin > 6) && (~isempty(old_h))
        h=figure(old_h);
    else
        h=figure;
    end
    hold on

    rand_predict=0.5;

    x=log2(x);
    last_point=x(end);
    final_score=y(end);

    % Show the area under the curve
    %patch([x last_point 0 0], [y rand_predict rand_predict y(1)], [1 0.9 0.6]);

    % Plot the curve with error bars
    %errorbar(x, y, e, style_list{pos}, 'LineWidth', 2);

    plot(x, y, style_list{pos}, 'MarkerSize', 6);
    if (pos == length(percent_l))    
        line_data = findobj(h,'Type','line');
        line_data = fliplr(line_data')';
        for i=1:length(line_data)
            percent_l{i} = [percent_l{i} ' = ' ...
                            num2str(aulc_l(i)) '+-' num2str(aulcerr_l(i))];
        end
        legend(line_data, percent_l,'FontSize',16,'Location', 'southeast');

        plot([0 last_point], [1 1]);
        plot([last_point last_point], [1 0]);
    end
    %plot([0 last_point], [1 1]);
    %plot([last_point last_point], [rand_predict 1]);
    %plot([0 last_point], [rand_predict rand_predict]);
    %plot([0 0], [rand_predict 1]);
    %plot([0 last_point], [rand_predict 1], '-.');
    %plot([last_point last_point+1], [final_score final_score], 'k--');
    %name(name=='_')=' ';
    %tt=[upper(name) ': ALC=' num2str(score, '%5.4f')]; 
    %title(tt);
    %text(last_point+1, final_score, num2str(final_score, '-%5.4f\n'));
    %text(last_point+0.15, final_score, num2str(final_score, '\t%5.4f\n'));
    xlabel('Log_2(Number of features)');
    ylabel('ROC curves');
    set(gca,'fontsize',16);
    %ylabel('Area under the ROC curve (AUROC)');
    xl=xlim; yl=ylim;
    xlim([0 last_point]);
    ylim([0.5 1]);
end