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
n1=50;
n2=50;

% The "helper" variable is a Gaussian distribution with standard 
% deviation s and mean m separated by delta_mu. The helper variable has no 
% missing data
alpha = 1; % signal to noise ratio
delta_mu=1;
mu=alpha*delta_mu/2;
s=delta_mu;
helper = [s*randn(n1+n2,1)+mu];

% The source variable, correlated with the helper, has missing data
a = 1; % slope
b = 0; % intercept
noise_level = delta_mu/2;
noise = randn(n1+n2, 1)*noise_level;
source = a * helper + b + noise;

frac_missing = 0.8;
Rs = rand(n1+n2,1)<=frac_missing;
miss_idx = find(Rs==1);
good_idx = find(Rs==0);

% The target variable has n1 examaples of the positive class and n2
% examples of the negative class.
target = ones(n1+n2,1);
target(find(helper<median(helper))) = -1;

% Plot with missing data == 0
min_val=floor(min(source));
idx1=1:n1;
idx2=n1+1:n1+n2;
good_idx1=intersect(idx1, good_idx); % for positive class
good_idx2=intersect(idx2, good_idx); % for negative class
miss_idx1=intersect(idx1, miss_idx);
miss_idx2=intersect(idx2, miss_idx);
figure; hold on
plot(helper(good_idx1), source(good_idx1), 'ro'); %points for positive class, no missing
plot(helper(good_idx2), source(good_idx2), 'bo'); %points for negative class, no missing
plot(helper(miss_idx1), min_val*ones(size(miss_idx1)), 'r+'); % missing point for positive class
plot(helper(miss_idx2), min_val*ones(size(miss_idx2)), 'b+'); % missing points for negative class

title('No imputation');
xlabel('Helper');
ylabel('Source');
legend({'Positive class', 'Negative class'});

%% Perform a linear regression of H on S with non missing data F(H) = aH + b

[p,S,mu] = polyfit(helper(good_idx),source(good_idx),1);

%% Compute the residual for the non missing values sigma_res = sqrt[sum_i((F(Hi)-Si)^2]


% To see how good the fit is, evaluate the polynomial at the data points and generate a table showing the data, fit, and error.
f = polyval(p,helper);
plot(helper,f)
hold off;
T = table(helper(good_idx),source(good_idx),f(good_idx),source(good_idx)-f(good_idx),'VariableNames',{'X','Y','Fit','FitError'});

figure;
scatterplot([helper, source], target);

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
%[a,b,c,stats] = ttest2(f(target==1),f(target==-1))
% Get the p-value of the statistic
p_value = (1-tcdf (t_statistic,2*n1-2))*2
p_value_orig = (1-tcdf (t_statistic_orig,2*n1-2))*2