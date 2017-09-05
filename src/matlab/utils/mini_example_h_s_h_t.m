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

%T<-H->S

% All variables have n = n1+n2 values.
n=100;

% The "helper" variable is a Gaussian distribution with standard 
% deviation s and mean m separated by delta_mu. The helper variable has no 
% missing data
alpha = 1; % signal to noise ratio
delta_mu=1;
mu=alpha*delta_mu/2;
s=delta_mu;
helper = [s*randn(n,1)+mu];

% The source variable, correlated with the helper, has missing data
a = 1; % slope
b = 0; % intercept
noise_level = delta_mu/2;
noise = randn(n, 1)*noise_level;
source = a * helper + b + noise;

% The target variable has n1 examaples of the positive class and n2
% examples of the negative class.
beta=1;
target = ones(n,1);
auxt = rand_sigmoid(helper,beta);
target(find(~auxt))=-1;
n1 = sum(auxt);
n2 = sum(~auxt);

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
sigma_pooled = sqrt(((n1-1)*(sigma_pooled1^2))+((n2-1)*(sigma_pooled2^2))/(n1+n2-2));

% Denominator of the modified t-stat
sigma = sqrt(((1/n1 + 1/n2)*(sigma_pooled^2+sigma_res^2)));
% Denominator of the original t-stat
sigma_orig = sqrt(1/n1 + 1/n2) * ...
             sqrt(((n1-1)*(sigma_pooled1^2))+((n2-1)*(sigma_pooled2^2))/(n1+n2-2));

% Compute the modified t-stat
t_statistic = mean_diff/sigma

% Compute the original t-stat
t_statistic_orig = mean_diff/sigma_orig
% that should be the same as the one obtained by the matlab version
%[a,b,c,stats] = ttest2(f(target==1),f(target==-1))
% Get the p-value of the statistic
p_value = (1-tcdf (t_statistic,n1+n2-2))*2
p_value_orig = (1-tcdf (t_statistic_orig,n1+n2-2))*2


%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(m1-nu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
mean_diff = abs(mean(source(target==1)) - mean(source(target==-1)));

%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
sigma_pooled1 = std(source(target==1));
sigma_pooled2 = std(source(target==-1));

% Denominator of the original t-stat
sigma_orig = sqrt(1/n1 + 1/n2) * ...
             sqrt(((n1-1)*(sigma_pooled1^2))+((n2-1)*(sigma_pooled2^2))/(n1+n2-2));

% Compute the original t-stat
t_statistic_nomissing = mean_diff/sigma_orig
% Get the p-value of the statistic
p_value_nomissing = (1-tcdf (t_statistic_nomissing,n1+n2-2))*2


%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(m1-nu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
mean_diff = abs(mean(source(good_idx1)) - mean(source(good_idx2)));

%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
sigma_pooled1 = std(source(good_idx1));
sigma_pooled2 = std(source(good_idx2));

% Denominator of the original t-stat
sigma_orig = sqrt(1/n1 + 1/n2) * ...
             sqrt(((n1-1)*(sigma_pooled1^2))+((n2-1)*(sigma_pooled2^2))/(n1+n2-2));

% Compute the original t-stat
t_statistic_listwise = mean_diff/sigma_orig
% Get the p-value of the statistic
p_value_listwise = (1-tcdf (t_statistic_listwise,length(good_idx1)+length(good_idx2)-2))*2


%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(m1-nu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
s_mean_imput = source;
s_mean_imput(miss_idx) = mean(s_mean_imput(good_idx));
mean_diff = abs(mean(s_mean_imput(target==1)) - mean(s_mean_imput(target==-1)));

%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
sigma_pooled1 = std(s_mean_imput(target==1));
sigma_pooled2 = std(s_mean_imput(target==-1));

% Denominator of the original t-stat
sigma_orig = sqrt(1/n1 + 1/n2) * ...
             sqrt(((n1-1)*(sigma_pooled1^2))+((n2-1)*(sigma_pooled2^2))/(n1+n2-2));


% Compute the original t-stat
t_statistic_meanimput = mean_diff/sigma_orig
% Get the p-value of the statistic
p_value_meanimput = (1-tcdf (t_statistic_meanimput,n1+n2-2))*2


%% Compute the difference between the means of the 2 classes (defined by T) for F(H) abs(mu1-mu2)
% Notice this uses the F(H) “reconstructed” values for all samples, even for non missing data
mean_diff = abs(mean(f(target==1)) - mean(f(target==-1)));

%% Compute the modify T statistic for fixed A developed by Kristin.
%sigma_pooled^2 is the pooled within class variance (you may use (sigma1^2 +  sigma2^2)/2 if the classes are balanced)
cov1 = cov(f(target==1));
cov2 = cov(f(target==-1));

% Denominator of the modified t-stat
t_denom=sqrt(cov1/n1 + cov2/n2 + ...
        ((n1*frac_missing)/n1^2 + (n2*frac_missing)/n2^2)*sum(noise)^2);

% Compute the modified t-stat
t_statistic_kristin = mean_diff/t_denom

% that should be the same as the one obtained by the matlab version
%[h0,p,ci,stats] = ttest2(source(target==1),source(target==-1))
% Get the p-value of the statistic
p_value_kristin = (1-tcdf (t_statistic_kristin,2*n1-2))*2