function [ train_r, valid_r, test_r, train_mod, precision_r, recall_r ] ...
                                = classif( cl_method, D, Dt, Dv, F, T, fid)
%CLASSIF Summary of this function goes here
%   Detailed explanation goes here

    % Select classifier method
    switch(cl_method)
        case 1 % kridg method
            my_cl_method=kridge;
        otherwise 
            my_cl_method=kridge;
    end

    train_r = cell(1,length(fid));
    valid_r = cell(1,length(fid));
    test_r = cell(1,length(fid));
    train_mod = cell(1,length(fid));
    precision_r = zeros(1,length(fid)); 
    recall_r = zeros(1,length(fid));

    for i=1:(length(fid))
        r_listwise = find(~sum(isnan(D.X(:, fid{i})),2));
        if(~isempty(r_listwise))
            D_train = data(D.X(r_listwise,fid{i}), D.Y(r_listwise,:));
            [train_r{i}, train_mod{i}] = train(my_cl_method, D_train);
            %rv_listwise = find(~sum(isnan(Dv.X(:, fid{i})),2));
            %D_valid = data(Dv.X(rv_listwise,fid{i}), Dv.Y(rv_listwise,:));
            D_valid = data(Dv.X(:,fid{i}), Dv.Y);
            valid_r{i} = test(train_mod{i}, D_valid);
            %rt_listwise = find(~sum(isnan(Dt.X(:, fid{i})),2));
            %D_test = data(Dt.X(rt_listwise,fid{i}) , Dt.Y(rt_listwise,:));
            D_test = data(Dt.X(:,fid{i}), Dt.Y);
            test_r{i} = test(train_mod{i}, D_test);
        end
        num_positive = length(find(T==1));
        num_feats = length(fid{i});
        true_positive = sum(T(fid{i})==1);
        precision_r(1,i) = true_positive/num_feats; 
        recall_r(1,i) = true_positive/num_positive; 
    end
    train_r = train_r(1:length(find(~cellfun(@isempty,train_r))));
    valid_r = valid_r(1:length(find(~cellfun(@isempty,valid_r))));
    test_r = test_r(1:length(find(~cellfun(@isempty,test_r))));
end

