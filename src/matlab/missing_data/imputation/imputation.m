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
        case 1 % imputation by median value.
            for i=1:size(X_mcar,2)
                X_median = [X_median median(X_mcar((find(M_mcar(:,i) == 1))))];
                Xt_median = [Xt_median median(Xt_mcar((find(Mt_mcar(:,i) == 1))))];
                Xv_median = [Xv_median median(Xv_mcar((find(Mv_mcar(:,i) == 1))))];
            end
            D_mcar.X = (D_mcar.X .* M_mcar) + (~M_mcar .* repmat(X_median,size(D_mcar.X,1),1));
            Dt_mcar.X = (Dt_mcar.X .* Mt_mcar) + (~Mt_mcar .* repmat(Xt_median,size(Dt_mcar.X,1),1));
            Dv_mcar.X = (Dv_mcar.X .* Mv_mcar) + (~Mv_mcar .* repmat(Xv_median,size(Dv_mcar.X,1),1));
    end
end

