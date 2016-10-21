function [D_mcar Dt_mcar Dv_mcar] = imputation(imp_method, D, Dt, Dv, M_mcar, Mt_mcar, Mv_mcar)
%IMPUTATION Summary of this function goes here
%   Detailed explanation goes here

    X_mcar = D.X;
    Xt_mcar = Dt.X;
    Xv_mcar = Dv.X;
    D_mcar = D;
    Dt_mcar = Dt;
    Dv_mcar = Dv;
    X_median = [];
    Xt_median = [];
    Xv_median = [];
    switch(imp_method)
        case 'median' % imputation by median value.
            for i=1:size(X_mcar,2)
                X_median = [X_median median(X_mcar(~M_mcar(:,i)))];
                Xt_median = [Xt_median median(Xt_mcar(~Mt_mcar(:,i)))];
                Xv_median = [Xv_median median(Xv_mcar(~Mv_mcar(:,i)))];
            end
            D_mcar.X = (D_mcar.X .* ~M_mcar) + (M_mcar .* repmat(X_median,size(D_mcar.X,1),1));
            Dt_mcar.X = (Dt_mcar.X .* ~Mt_mcar) + (Mt_mcar .* repmat(Xt_median,size(Dt_mcar.X,1),1));
            Dv_mcar.X = (Dv_mcar.X .* ~Mv_mcar) + (Mv_mcar .* repmat(Xv_median,size(Dv_mcar.X,1),1));
        case 'svd' % imputation by svd
            maxiter = 10;
            maxnum = 10;
            X_mcar(M_mcar) = 0;
            Xt_mcar(Mt_mcar) = 0;
            Xv_mcar(Mv_mcar) = 0;
            for k=1:maxiter
                [U, S, V] = svds(X_mcar, maxnum);
                [Ut, St, Vt] = svds(Xt_mcar, maxnum);
                [Uv, Sv, Vv] = svds(Xv_mcar, maxnum);
                XX = U*S*V';
                XXt = Ut*St*Vt';
                XXv = Uv*Sv*Vv';
                X_mcar(M_mcar) = XX(M_mcar);
                Xt_mcar(Mt_mcar) = XXt(Mt_mcar);
                Xv_mcar(Mv_mcar) = XXv(Mv_mcar);
                X_mcar(X_mcar<0)=0;
                X_mcar(X_mcar>999)=999;
                Xt_mcar(Xt_mcar<0)=0;
                Xt_mcar(Xt_mcar>999)=999;
                Xv_mcar(Xv_mcar<0)=0;
                Xv_mcar(Xv_mcar>999)=999;
            end
            D_mcar.X = X_mcar;
            Dt_mcar.X = Xt_mcar;
            Dv_mcar.X = Xv_mcar;
    end
end

