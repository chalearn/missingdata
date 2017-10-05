function [h, error_p] = plot_learning_curve(name, score, x, y, e, old_h)
%PLOT_LEARNING_CURVE Obtain the learning curve graph corresponding with the
%                    values passed by parameter.
% INPUT:
%   name:       Experiment name.
%   score:      Result value.
%   x:          Number of samples.
%   y:          ROC performance.
%   e:          Error bar.
%   old_h:      Plot handle.
% OUTPUT:
%   h:          Plot handle.    
%   error_p:    Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.

% Set the initial value of return variables.
h = [];
error_p = 0;

% Check the number of parameters.
if (nargin<5)
    error_p = 1;
else
    if (nargin > 5) && (~isempty(old_h))
        h=figure(old_h);
        cla
    else
        h=figure;
    end
    hold on
    rand_predict=0.5;
    x=log2(x);
    last_point=x(end);
    final_score=y(end);

    % Show the area under the curve
    patch([x last_point 0 0], [y rand_predict rand_predict y(1)], [1 0.9 0.6]);

    % Plot the curve with error bars
    errorbar(x, y, e, 'r', 'LineWidth', 2);

    plot(x, y, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');
    plot([0 last_point], [1 1]);
    plot([last_point last_point], [rand_predict 1]);
    plot([0 last_point], [rand_predict rand_predict]);
    plot([0 0], [rand_predict 1]);
    %plot([0 last_point], [rand_predict 1], '-.');
    %plot([last_point last_point+1], [final_score final_score], 'k--');
    name(name=='_')=' ';
    tt=[upper(name) ': ALC=' num2str(score, '%5.4f')]; 
    title(tt);
    %text(last_point+1, final_score, num2str(final_score, '-%5.4f\n'));
    text(last_point+0.15, final_score, num2str(final_score, '\t%5.4f\n'));
    xlabel('Log_2(Number of features)');
    ylabel('Area under the ROC curve (AUROC)');
    xl=xlim; yl=ylim;
    xlim([0 last_point]);
    ylim([0.5 1]);
end