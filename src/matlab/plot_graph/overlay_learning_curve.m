function h=plot_learning_curve(name, score, x, y, e, percent_l, pos, old_h)
%h=plot_learning_curve(name, score, x, y, e, old_h)
% Plot the learning curve 
% Inputs:
% x -- Number of samples
% y -- Performance
% e -- Error bar
% name -- experiment name
% Returns:
% h --      The plot handle

% Author: Isabelle Guyon -- November 2010 -- isabelle@clopinet.com

color_list = ['r','b','y','m','k','g','b','c'];

if nargin<8 || isempty(old_h);
    h=figure;
else
    h=figure(old_h);
end
hold on

rand_predict=0.5;

x=log2(x);
last_point=x(end);
final_score=y(end);

% Show the area under the curve
%patch([x last_point 0 0], [y rand_predict rand_predict y(1)], [1 0.9 0.6]);

% Plot the curve with error bars
errorbar(x, y, e, [color_list(pos)], 'LineWidth', 2);

plot(x, y, [color_list(pos) 'o'], 'MarkerSize', 6, 'MarkerFaceColor', [color_list(pos)]);
text(x(12)-1, 0.8-(0.03*pos), [percent_l{pos} ' %'], 'Color', color_list(pos));
plot([0 last_point], [1 1]);
plot([last_point last_point], [rand_predict 1]);
plot([0 last_point], [rand_predict rand_predict]);
plot([0 0], [rand_predict 1]);
%plot([0 last_point], [rand_predict 1], '-.');
%plot([last_point last_point+1], [final_score final_score], 'k--');
%name(name=='_')=' ';
%tt=[upper(name) ': ALC=' num2str(score, '%5.4f')]; 
%title(tt);
%text(last_point+1, final_score, num2str(final_score, '-%5.4f\n'));
text(last_point+0.15, final_score, num2str(final_score, '\t%5.4f\n'));
xlabel('Log_2(Number of features)');
ylabel('Area under the ROC curve (AUROC)');
xl=xlim; yl=ylim;
xlim([0 last_point]);
ylim([0.5 1]);




