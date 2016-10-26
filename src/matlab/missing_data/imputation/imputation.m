function [D_rest Dt_rest Dv_rest] = imputation(imp_method, D_miss, Dt_miss, Dv_miss)
%IMPUTATION Summary of this function goes here
%   Detailed explanation goes here
    
    % Set initial values to return D struct.
    D_rest = D_miss;
    Dt_rest = Dt_miss;
    Dv_rest = Dv_miss;
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
        case 'median' % imputation by median value.
            X_median = nanmedian(X_miss);
            Xt_median = nanmedian(Xt_miss);
            Xv_median = nanmedian(Xv_miss);
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
                Xt_miss(miss_t) = XX(miss_t);
                Xv_miss(miss_v) = XXv(miss_v);
                X_miss(X_miss<0)=0;
                X_miss(X_miss>999)=999;
                Xt_miss(Xt_miss<0)=0;
                Xt_miss(Xt_miss>999)=999;
                Xv_miss(Xv_miss<0)=0;
                Xv_miss(Xv_miss>999)=999;
            end
    end
    D_rest.X = X_miss;
    Dt_rest.X = Xt_miss;
    Dv_rest.X = Xv_miss;
end

