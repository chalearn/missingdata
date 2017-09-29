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

%T<-S->H

repeats = 10;
corr_table_r = zeros(5,5,repeats);
for r=1:repeats
    % All variables have n = n1+n2 values.
    n=100;

    % The "source" variable is a Gaussian mixture.
    % The samples for each class are Gaussian distributed with standard 
    % deviations s1 and s2, and means m1 and m2 separated by delta_mu

    alpha = 1; % signal to noise ratio
    delta_mu=1;
    mu=alpha*delta_mu/2;
    s=delta_mu;
    source = [s*randn(n,1)+mu];

    % The helper variable, correlated with the source, has no missing values
    a = 1; % slope
    b = 0; % intercept
    noise_level = delta_mu/2;
    noise = randn(n, 1)*noise_level;
    helper = a * source + b + noise;

    % The target variable has n1 examaples of the positive class and n2
    % examples of the negative class.
    beta=1;
    target = ones(n,1);
    % SIGMOID METHOD
    auxt = rand_sigmoid(source,beta);
    target(find(~auxt))=-1;
    % THRESHOLD METHOD
    % target(find(source<median(source)))=-1;
    
    n1 = sum(target==1);
    n2 = sum(target==-1);

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

    %figure;
    %scatterplot([helper, source], target, 0);
    %figure;
    %target_miss_class_plot = target;
    %target_miss_class_plot(miss_idx1) = 2;
    %target_miss_class_plot(miss_idx2) = -2;
    %scatterplot([helper, source], target_miss_class_plot, 0);
    s_hat([good_idx; miss_idx]) = [source(good_idx); f(miss_idx)]; 
    %figure;
    %scatterplot([helper, s_hat'], target_miss_class_plot, 1);

    [ t_statistic_nomissing(r), p_value_nomissing(r) ] = ttest_nomissing ( source, target );

    [ t_statistic_listwise(r), p_value_listwise(r) ] = ttest_listwise( source, good_idx1, good_idx2 );

    s_mean_imput = source;
    s_mean_imput(miss_idx) = mean(s_mean_imput(good_idx));
    [ t_statistic_meanimput(r), p_value_meanimput(r) ] = ttest_meanimput ( s_mean_imput, target );

    [ t_statistic_orig(r), p_value_orig(r) ] = ttest_orig ( source, f, target, good_idx );

    [ t_statistic_modif(r), p_value_modif(r) ] = ttest_mod ( source, f, target, good_idx );

    [ t_statistic_kristin(r), p_value_kristin(r) ] = ttest_kristin( source, f, target, good_idx, frac_missing, noise );

    [ t_statistic_h_t_r(r), p_value_h_t_r(r) ] = ttest_nomissing ( helper, target );

    corr_table_r(:,:,r) = corrcoef([source s_mean_imput s_hat' helper target]);
end

t_statistic_r = [t_statistic_nomissing', t_statistic_listwise', t_statistic_meanimput', ...
               t_statistic_orig', t_statistic_modif', t_statistic_kristin'];
           
p_value_r = [p_value_nomissing', p_value_listwise', p_value_meanimput', ...
               p_value_orig', p_value_modif', p_value_kristin'];

           
t_statistic = mean(t_statistic_r)'
t_statistic_std = std(t_statistic_r)'
p_value = mean(p_value_r)'
p_value_std = std(p_value_r)'

t_statistic_h_t = mean(t_statistic_h_t_r')
t_statistic_h_t_std = std(t_statistic_h_t_r')
p_value_h_t = mean(p_value_h_t_r')
p_value_h_t_std = std(p_value_h_t_r')

corr_table = mean(corr_table_r,3)