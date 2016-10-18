function [ M_mcar Mt_mcar Mv_mcar ] = mcar( mcar_method, mcar_percent, D, Dt, Dv );
%MCAR Summary of this function goes here
%   Detailed explanation goes here

    x = size(D.X,1);
    y = size(Dv.X,1);
    z = size(Dt.X,1);
    n = size(D.X,2);

    switch (mcar_method)
        case 1 % flip_coin
            total_size = (x+y+z)*n;
            miss_size = round(total_size*(mcar_percent/100));
            rank_v = randperm(total_size);
            miss_pos = rank_v(1:miss_size);
            Dmiss = ones(x+y+z,n)';
            Dmiss(miss_pos)=0;
            Dmiss = Dmiss';
            M_mcar = Dmiss(1:x,:);
            Mv_mcar = Dmiss((x+1):(x+y),:);
            Mt_mcar = Dmiss((x+y+1):end,:);
    end
end

