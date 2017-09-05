% This script examplifies the effect of various ways of dealing with missing
% values on variable selection with the T-test.

addpath('CLOP');
use_spider_clop;


% For the sake of simplicity, we only have 3 variables:
% Two continuous "features" and one "target" variable.
% One of the features is fully observed (no missing data) and is used to
% "help" another variable that has missing data, which we call "source".
% We are interested in studying how we can determine whether the "source"
% variable and the target are significantly dependent. We will use a
% variant of the T-statistic to measure that dependence.

%T  H  S

% All variables have n = n1+n2 values.

% The target variable has n1 examaples of the positive class and n2
% examples of the negative class.
n1=50;
n2=50;
target = [ones(n1,1); -ones(n2,1)];

% The "helper" variable is a Gaussian mixture.
% The samples for each class are Gaussian distributed with standard 
% deviations s1 and s2, and means m1 and m2 separated by delta_mu
alpha2 = 1; % signal to noise ratio
delta_mu2=1;
mu2=alpha2*delta_mu2/2;
s2=delta_mu2;
helper = [s*randn(n1+n2,1)+mu2];

% The helper variable, correlated with the source, has no missing values
alpha = 1; % signal to noise ratio
delta_mu=1;
mu=alpha*delta_mu/2;
s=delta_mu;
source = [s*randn(n1+n2,1)+mu];

% Create the missing data with the same sample size of missing in each class.
frac_missing = 0.8;
idx1=find(target==1);
idx2=find(target==-1);
aux_idx1 = idx1(randperm(n1));
aux_idx2 = idx2(randperm(n2));
miss_idx1 = aux_idx1(1:n1*frac_missing);
miss_idx2 = aux_idx2(1:n2*frac_missing);
good_idx1 = aux_idx1(n1*frac_missing+1:end);
good_idx2 = aux_idx2(n2*frac_missing+1:end);
good_idx = union(good_idx1, good_idx2);
miss_idx = union(miss_idx1, miss_idx2);

%% Perform a linear regression of H on S with non missing data F(H) = aH + b

[p,S,mu] = polyfit(helper(good_idx),source(good_idx),1);

%% Compute the residual for the non missing values sigma_res = sqrt[sum_i((F(Hi)-Si)^2]

% To see how good the fit is, evaluate the polynomial at the data points and generate a table showing the data, fit, and error.
f = polyval(p,helper);
T = table(helper(good_idx),source(good_idx),f(good_idx),source(good_idx)-f(good_idx),'VariableNames',{'X','Y','Fit','FitError'});

figure;
scatterplot([helper, source], target, 0);
figure;
target_miss_class_plot = target;
target_miss_class_plot(miss_idx1) = 2;
target_miss_class_plot(miss_idx2) = -2;
scatterplot([helper, source], target_miss_class_plot, 0);
s_hat([good_idx; miss_idx]) = [source(good_idx); f(miss_idx)]; 
figure;
scatterplot([helper, s_hat'], target_miss_class_plot, 1);

%Generate ideal 

%Residual for the non missing values
sigma_res = sqrt(sum((f(good_idx)-source(good_idx)).^2));

%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(m1-nu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
mean_diff = abs(mean(f(target==1)) - mean(f(target==-1)));

%% Compute the modify T statistic abs(m1-mu2) / sigma to independent variables with equal sample sizes and equal variance

%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
sigma_pooled1 = std(f(target==1));
sigma_pooled2 = std(f(target==-1));
sigma_pooled = sqrt((sigma_pooled1^2+sigma_pooled2^2)/2);

% Denominator of the modified t-stat
sigma = sqrt((2*(sigma_pooled^2+sigma_res^2))/n1);
% Denominator of the original t-stat
sigma_orig = sqrt(2/n1) * sqrt((sigma_pooled1^2+sigma_pooled2^2)/2);

% Compute the modified t-stat
t_statistic = mean_diff/sigma

% Compute the original t-stat
t_statistic_orig = mean_diff/sigma_orig
% that should be the same as the one obtained by the matlab version
[a,b,c,stats] = ttest2(source(target==1),source(target==-1));
% Get the p-value of the statistic
p_value = (1-tcdf (t_statistic,2*n1-2))*2
p_value_orig = (1-tcdf (t_statistic_orig,2*n1-2))*2


%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(m1-nu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
mean_diff = abs(mean(source(target==1)) - mean(source(target==-1)));

%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
sigma_pooled1 = std(source(target==1));
sigma_pooled2 = std(source(target==-1));

% Denominator of the original t-stat
sigma_orig = sqrt(2/n1) * sqrt((sigma_pooled1^2+sigma_pooled2^2)/2);

% Compute the original t-stat
t_statistic_nomissing = mean_diff/sigma_orig
% Get the p-value of the statistic
p_value_nomissing = (1-tcdf (t_statistic_nomissing,2*n1-2))*2


%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(m1-nu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
mean_diff = abs(mean(source(good_idx1)) - mean(source(good_idx2)));

%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
sigma_pooled1 = std(source(good_idx1));
sigma_pooled2 = std(source(good_idx2));

% Denominator of the original t-stat
sigma_orig = sqrt(2/length(good_idx1)) * sqrt((sigma_pooled1^2+sigma_pooled2^2)/2);

% Compute the original t-stat
t_statistic_listwise = mean_diff/sigma_orig
% Get the p-value of the statistic
p_value_listwise = (1-tcdf (t_statistic_listwise,2*length(good_idx1)-2))*2


%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(m1-nu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
s_mean_imput = source;
s_mean_imput(miss_idx) = mean(s_mean_imput(good_idx));
mean_diff = abs(mean(s_mean_imput(target==1)) - mean(s_mean_imput(target==-1)));

%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
sigma_pooled1 = std(s_mean_imput(target==1));
sigma_pooled2 = std(s_mean_imput(target==-1));

% Denominator of the original t-stat
sigma_orig = sqrt(2/n1) * sqrt((sigma_pooled1^2+sigma_pooled2^2)/2);

% Compute the original t-stat
t_statistic_meanimput = mean_diff/sigma_orig
% Get the p-value of the statistic
p_value_meanimput = (1-tcdf (t_statistic_meanimput,2*n1-2))*2