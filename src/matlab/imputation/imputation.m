function [D_imp, Dv_imp, Dt_imp, error_i] = imputation(imp_method, D_miss, Dv_miss, Dt_miss)
%IMPUTATION Imput the values in a missing dataset according to an
%           imputation method indicated (both train, validation and test).
% INPUT:
%   imp_method: Name that represents the imputation method.
%                   'med'   - median
%                   'svd'   - svd
%                   'lreg'  - linear regression
%                   'corr'  - correlation
%                   'lwise' - listwise
%   D_miss:     Data type that represents the missing train dataset that
%               will be imputed.
%   Dv_miss:    Data type that represents the missing validation dataset 
%               that will be imputed.
%   Dt_miss:    Data type that represents the missing test dataset that
%               will be imputed.
% OUTPUT:
%   D_imp:      Data type that represents the imputed train dataset.
%   Dv_imp:     Data type that represents the imputed validation dataset.
%   Dt_imp:     Data type that represents the imputed test dataset.
%   error_i:    Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.
%                   2 - Incorrect classification method requested.
    
    % Set initial values to return D struct.
    D_imp = D_miss;
    Dt_imp = Dt_miss;
    Dv_imp = Dv_miss;
    % Extract the X matrix to work with those data after. 
    X_miss = D_miss.X;
    Xt_miss = Dt_miss.X;
    Xv_miss = Dv_miss.X;
    % Get the sizes of each data subset.
    x = size(X_miss,1);
    y = size(Xt_miss,1);
    z = size(Xv_miss,1);
    n = size(X_miss,2);

    switch(imp_method)
        case 'med' % imputation by median value.
            X_median = nanmedian(X_miss);
            X_median(isnan(X_median)) = 0;
            Xt_median = nanmedian(Xt_miss);
            Xt_median(isnan(Xt_median)) = 0;
            Xv_median = nanmedian(Xv_miss);
            Xv_median(isnan(Xv_median)) = 0;
            X_median = repmat(X_median,x,1);
            Xt_median = repmat(Xt_median,y,1);
            Xv_median = repmat(Xv_median,z,1);
            miss_pos = isnan(X_miss);
            X_miss(miss_pos) = X_median(miss_pos);
            miss_pos = isnan(Xt_miss);
            Xt_miss(miss_pos) = Xt_median(miss_pos);
            miss_pos = isnan(Xv_miss);
            Xv_miss(miss_pos) = Xv_median(miss_pos);
        case 'svd' % imputation by svd
            maxiter = 10;
            maxnum = 10;
            miss = isnan(X_miss);
            miss_t = isnan(Xt_miss);
            miss_v = isnan(Xv_miss);
            X_miss(miss) = 0;
            Xt_miss(miss_t) = 0;
            Xv_miss(miss_v) = 0;
            for k=1:maxiter
                [U, S, V] = svds(X_miss, maxnum);
                [Ut, St, Vt] = svds(Xt_miss, maxnum);
                [Uv, Sv, Vv] = svds(Xv_miss, maxnum);
                XX = U*S*V';
                XXt = Ut*St*Vt';
                XXv = Uv*Sv*Vv';
                X_miss(miss) = XX(miss);
                Xt_miss(miss_t) = XXt(miss_t);
                Xv_miss(miss_v) = XXv(miss_v);
                X_miss(X_miss<0)=0;
                X_miss(X_miss>999)=999;
                Xt_miss(Xt_miss<0)=0;
                Xt_miss(Xt_miss>999)=999;
                Xv_miss(Xv_miss<0)=0;
                Xv_miss(Xv_miss>999)=999;
            end
        case 'lreg'
            [p,S,mu] = polyfit(helper(good_idx),source(good_idx),1);
        case 'corr'
            miss = isnan(X_miss);
            miss_t = isnan(Xt_miss);
            miss_v = isnan(Xv_miss);
            RHO = corr(X_miss, 'rows', 'pairwise');
            RHOt = corr(Xt_miss, 'rows', 'pairwise');
            RHOv = corr(Xv_miss, 'rows', 'pairwise');
            for c=1:n
                [sortingX,sortingI] = sort(abs(RHO(c,:)),'descend');
                [sortingXt,sortingIt] = sort(abs(RHOt(c,:)),'descend');
                [sortingXv,sortingIv] = sort(abs(RHOv(c,:)),'descend');
                imp_pos = sortingI(find(~isnan(sortingX)));
                imp_post = sortingI(find(~isnan(sortingXt)));
                imp_posv = sortingI(find(~isnan(sortingXv)));
                f = find(miss(:,c));
                pos = imp_pos(~isnan(X_miss(f,imp_pos)));
                X_miss(f,c) = X_miss(f,pos);
                
                f = find(miss_t(:,c));
                pos = imp_post(~isnan(Xt_miss(f,imp_post)));
                Xt_miss(f,c) = Xt_miss(f,pos);
                
                f = find(miss_v(:,c));
                pos = imp_posv(~isnan(Xv_miss(f,imp_posv)));
                Xv_miss(f,c) = Xv_miss(f,pos);
            end
        case 'lwise' % imputation by list wise deletion

    end
    D_imp.X = X_miss;
    Dt_imp.X = Xt_miss;
    Dv_imp.X = Xv_miss;
end