function h=plot_ev_curve(name, score, x, y, imput_l, percent_l, old_h)
%h=plot_learning_curve(name, score, x, y, imput_l, old_h)
% Plot the learning curve 
% Inputs:
% x -- Number of samples
% y -- Performance
% e -- Name of the imputation method
% name -- experiment name
% Returns:
% h --      The plot handle

% Author: Isabelle Guyon -- November 2010 -- isabelle@clopinet.com

color_list = ['r','b','g','y','m','c','b','k'];

if nargin<7 || isempty(old_h);
    h=figure;
else
    h=figure(old_h); 
    cla
end
hold on

rand_predict=0.5;
% Add a x=100 and y=0 column in the points matrix.
x = [x zeros(size(y,1),1)];
y = [y zeros(size(y,1),1)];
percent_l = [percent_l '100'];
percent_l = strcat(percent_l,{'%'});
for c=1:size(y,1)
    last_point=1; %the last x point is the 100% of missing data.
    y_row = y(c,:);
    x_row = x(c,:);
    plot(y_row, x_row, ['-' color_list(c) 'o'], 'MarkerSize', 8, 'MarkerFaceColor', color_list(c));
    text(y_row(4)-0.03, x_row(4)-0.05, [imput_l{c} ' imput.'], 'Color', color_list(c));
    text(y_row+0.007, x_row-0.015, percent_l, 'Color', color_list(c));
end

tt=[upper(name)];
title(tt);
xlabel('DP');
ylabel('PP');
xlim([0.5 last_point]);
ylim([rand_predict 1]);
plot([0.5 last_point], [1 1]);
plot([last_point last_point], [rand_predict 1]);
plot([0.5 last_point], [rand_predict rand_predict]);
plot([0.5 0.5], [rand_predict 1]);