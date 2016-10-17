function [ D_mcar Dt_mcar Dv_mcar ] = mcar( mcar_method, mcar_percent, D, Dt, Dv );
%MCAR Summary of this function goes here
%   Detailed explanation goes here

    x = size(D,1);
    y = size(Dv,1);
    z = size(Dt,1);
    n = size(D,2);

    switch (mcar_method)
        case 1 % flip_coin
            total_size = (x+y+z)*n;
            miss_size = round(total_size*mcar_percent);
            rank_v = randperm(total_size);
            miss_pos = rank_v(1:miss_size);
            Dtotal = [D; Dv; Dt]';
            Dmiss = Dtotal;
            Dmiss(miss_pos)=0;
            Dmiss = Dmiss';
            D_mcar = Dmiss(1:x,:);
            Dv_mcar = Dmiss((x+1):(x+y),:);
            Dt_mcar = Dmiss((x+y+1):end,:);
    end
end

