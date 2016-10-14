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
        D_train = data(D.X(:, fid{i}) , D.Y);
        [train_r{i}, train_mod{i}] = train(my_cl_method, D_train);
        D_valid = data(Dv.X(:, fid{i}), Dv.Y);
        valid_r{i} = test(train_mod{i}, D_valid);
        D_test = data(Dv.X(:, fid{i}), Dv.Y);
        test_r{i} = test(train_mod{i}, D_test);
        num_positive = length(find(T==1));
        num_feats = length(fid{i});
        true_positive = sum(T(fid{i})==1);
        precision_r(1,i) = true_positive/num_feats; 
        recall_r(1,i) = true_positive/num_positive; 
    end
end

