function h=plot_ev_curve(name, score, x, y, imput_l, old_h)
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

if nargin<6 || isempty(old_h);
    h=figure;
else
    h=figure(old_h); 
    cla
end
hold on

rand_predict=0.5;
% Add a x=100 and y=0 column in the points matrix.
x = [x ones(size(y,1),1).*100];
y = [y zeros(size(y,1),1)];
for c=1:size(y,1)
    last_point=x(1,end); %the last x point is the 100% of missing data.
    y_row = y(c,:);
    x_row = x(c,:);
    plot(x_row, y_row, ['-' color_list(c) 'o'], 'MarkerSize', 8, 'MarkerFaceColor', color_list(c));
    text(x_row(end-1)+6, y_row(end-1)-0.1, [imput_l(c) ' imput.'], 'Color', color_list(c));
end

tt=[upper(name)];
title(tt);
xlabel('% of missing values');
ylabel('PP/DP');
xlim([0 last_point]);
ylim([rand_predict 1]);
plot([0 last_point], [1 1]);
plot([last_point last_point], [rand_predict 1]);
plot([0 last_point], [rand_predict rand_predict]);
plot([0 0], [rand_predict 1]);