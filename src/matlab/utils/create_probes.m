function [ D, Dv, Dt, T ] = create_probes(D, Dv, Dt)
%CREATE_PROBES Summary of this function goes here
%   Detailed explanation goes here

    x = size(D.X,1);
    y = size(Dv.X,1);
    z = size(Dt.X,1);
    n = size(D.X,2);
    D_aux = D.X;
    Dv_aux = Dv.X;
    Dt_aux = Dt.X;
    
    T_orig = ones(size(D.X,2),1);
    T_prob = ones(size(D.X,2),1).*-1;
    
    [~, rand_out] = sort(rand(x,n),1);
    aux_out = repmat(0:n-1,x,1)*x;
    X_prob = D_aux(rand_out+aux_out);

    [~, rand_out] = sort(rand(y,n),1);
    aux_out = repmat(0:n-1,y,1)*y;
    Xv_prob = Dv_aux(rand_out+aux_out);
    
    [~, rand_out] = sort(rand(z,n),1);
    aux_out = repmat(0:n-1,z,1)*z;
    Xt_prob = Dt_aux(rand_out+aux_out);

    D.X = [D.X X_prob];
    Dv.X = [Dv.X Xv_prob];
    Dt.X = [Dt.X Xt_prob];
    T = [T_orig; T_prob];
end

