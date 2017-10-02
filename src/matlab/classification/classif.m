function [ train_mod, train_r, valid_r, test_r, precis_r, recall_r , error_cl] = ...
                                classif(cl_method, D_cl, Dv_cl, Dt_cl, T_cl, id_fs)
%CLASSIF Obtain the results of make the classification process over a dataset
%        (both training and test).
% INPUT:
%   cl_method:  number that represents the classification method.
%                   'kridge'    - kridge
%   D_cl:       Data type that represents the dataset that will be classified.
%   Dv_cl:      Data type that represents the dataset that will be used to
%               perform the validation.
%   Dt_cl:      Data type that represents the dataset that will be used to
%               perform the test.
%   T_cl:       Array of target values.
%   id_fs:      Cell array with subsets of relevant features.
% OUTPUT:
%   train_mod:  Trained classification model.
%   train_r:    Train results of classification process.
%   valid_r:    Validation results obtained with the trained classification.
%   test_r:     Test results obtained with the trained classification.
%   precis_r:   Precission results.
%   recall_r:   Recall results.
%   error_fs:   Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.
%                   2 - Incorrect classification method requested.

% Set the initial value of return variables.
train_r = [];
valid_r = [];
test_r = [];
train_mod = [];
precis_r = [];
recall_r = [];
error_cl = 0;

% Set the initial value of flags.
flag_valid = 0;
flag_test = 0;
flag_prec_recall = 0;
flag_fs = 0;

% Check the number of parameters.
if (nargin<2)
    error_cl = 1;
else
    if (nargin > 2)
        flag_valid = 1;
    end
    if (nargin > 3)
        flag_test = 1;
    end
    if (nargin > 4)
        flag_prec_recall = 1;
    end
    if (nargin > 5)
        flag_fs = 1;
    end
    
    % Initialize variables.
    if (~flag_fs)
        id_fs = {1:size(D_cl.X,2)};
    end
    train_r = cell(1,length(id_fs));
    train_mod = cell(1,length(id_fs));
    if (flag_valid)
        valid_r = cell(1,length(id_fs));
    end
    if (flag_test)
        test_r = cell(1,length(id_fs));
    end
    if (flag_prec_recall)
        precis_r = zeros(1,length(id_fs)); 
        recall_r = zeros(1,length(id_fs));
    end

    % Select classifier method.
    switch(cl_method)
        case 'kridge' % kridg method
            my_cl_method=kridge;
        otherwise
            error_cl = 2;
    end

    if (~error_cl)
        for i=1:(length(id_fs))
            r_listwise = find(~sum(isnan(D_cl.X(:, id_fs{i})),2));
            if(~isempty(r_listwise))
                D_train = data(D_cl.X(r_listwise,id_fs{i}), D_cl.Y(r_listwise,:));
                [train_r{i}, train_mod{i}] = train(my_cl_method, D_train);
                %rv_listwise = find(~sum(isnan(Dv.X(:, fid{i})),2));
                %D_valid = data(Dv.X(rv_listwise,fid{i}), Dv.Y(rv_listwise,:));
                if (flag_valid)
                    D_valid = data(Dv_cl.X(:,id_fs{i}), Dv_cl.Y);
                    valid_r{i} = test(train_mod{i}, D_valid);
                end
                %rt_listwise = find(~sum(isnan(Dt.X(:, fid{i})),2));
                %D_test = data(Dt.X(rt_listwise,fid{i}) , Dt.Y(rt_listwise,:));
                if (flag_test)
                    D_test = data(Dt_cl.X(:,id_fs{i}), Dt_cl.Y);
                    test_r{i} = test(train_mod{i}, D_test);
                end
            end
            if (flag_prec_recall)
                num_positive = length(find(T_cl==1));
                num_feats = length(id_fs{i});
                true_positive = sum(T_cl(id_fs{i})==1);
                precis_r(1,i) = true_positive/num_feats; 
                recall_r(1,i) = true_positive/num_positive; 
            end
        end
        train_r = train_r(1:length(find(~cellfun(@isempty,train_r))));
        if (flag_valid)
            valid_r = valid_r(1:length(find(~cellfun(@isempty,valid_r))));
        end
        if (flag_test)
            test_r = test_r(1:length(find(~cellfun(@isempty,test_r))));
        end
    end
end