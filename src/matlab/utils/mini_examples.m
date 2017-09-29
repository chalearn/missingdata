% This script examplifies the effect of various ways of dealing with missing
% values on variable selection with the T-test.

use_spider_clop;


% For the sake of simplicity, we only have 3 variables:
% Two continuous "features" and one "target" variable.
% One of the features is fully observed (no missing data) and is used to
% "help" another variable that has missing data, which we call "source".
% We are interested in studying how we can determine whether the "source"
% variable and the target are significantly dependent. We will use a
% variant of the T-statistic to measure that dependence.

% All variables have n = n1+n2 values.

% The target variable has n1 examaples of the positive class and n2
% examples of the negative class.
n1=50;
n2=50;
target = [ones(n1,1); -ones(n2,1)];

% The "source" variable is a Gaussian mixture.
% The samples for each class are Gaussian distributed with standard 
% deviations s1 and s2, and means m1 and m2 separated by delta_mu

alpha = 1; % signal to noise ratio
delta_mu=1;
mu1=alpha*delta_mu/2;
mu2=-alpha*delta_mu/2;
s1=delta_mu;
s2=delta_mu;
source = [s1*randn(n1,1)+mu1; s2*randn(n1,1)+mu2];

% The source variable has missing data

frac_missing = 0.8;
Rs = rand(n1+n2,1)<=frac_missing;
miss_idx = find(Rs==1);
good_idx = find(Rs==0);

% The helper variable, correlated with the source, has no missing values
a = 1; % slope
b = 0; % intercept
noise_level = delta_mu/2;
noise = randn(n1+n2, 1)*noise_level;
helper = a * source + b + noise;

% Plot with missing data == 0
min_val=floor(min(source));
idx1=1:n1;
idx2=n1+1:n1+n2;
good_idx1=intersect(idx1, good_idx);
good_idx2=intersect(idx2, good_idx);
miss_idx1=intersect(idx1, miss_idx);
miss_idx2=intersect(idx2, miss_idx);
figure; hold on
plot(helper(good_idx1), source(good_idx1), 'ro');
plot(helper(good_idx2), source(good_idx2), 'bo');
plot(helper(miss_idx1), min_val*ones(size(miss_idx1)), 'r+');
plot(helper(miss_idx2), min_val*ones(size(miss_idx2)), 'b+');

title('No imputation');
xlabel('Helper');
ylabel('Source');
legend({'Positive class', 'Negative class'});
figure;
scatterplot([source, helper], target);
