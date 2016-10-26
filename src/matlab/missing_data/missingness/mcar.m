function [ D_miss, Dt_miss, Dv_miss, M_mcar, Mt_mcar, Mv_mcar ] = ...
                            mcar( mcar_method, mcar_percent, D, Dt, Dv );
%MCAR Summary of this function goes here
%   Detailed explanation goes here
    % Set initial values to return D struct.
    D_miss = D;
    Dt_miss = Dt;
    Dv_miss = Dv;
    % Extract the X matrix to work with those data after. 
    X = D.X;
    Xt = Dt.X;
    Xv = Dv.X;
    % Get the sizes of each data subset.
    x = size(X,1);
    y = size(Xt,1);
    z = size(Xv,1);
    n = size(X,2);

    switch (mcar_method)
        case 'flipcoin' % flip_coin
            total_size = (x+y+z)*n;
            miss_size = round(total_size*(mcar_percent/100));
            rank_v = randperm(total_size);
            miss_pos = rank_v(1:miss_size);
            Dmiss = zeros(x+y+z,n)';
            Dmiss(miss_pos)=1;
            Dmiss = Dmiss';
            M_mcar = Dmiss(1:x,:);
            Mv_mcar = Dmiss((x+1):(x+y),:);
            Mt_mcar = Dmiss((x+y+1):end,:);
    end
    M_mcar = logical(M_mcar);
    Mt_mcar = logical(Mt_mcar);
    Mv_mcar = logical(Mv_mcar);
    
    % Get the final samples of the dataset with missing data as NaN values.
    X(M_mcar)=NaN;
    Xt(Mt_mcar)=NaN;
    Xv(Mv_mcar)=NaN;
    D_miss.X = X;
    Dt_miss.X = Xt;
    Dv_miss.X = Xv;
end

