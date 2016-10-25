function [ M_mar Mt_mar Mv_mar ] = mar( mar_method, mar_percent, D, Dt, Dv, F, T);
%MCAR Summary of this function goes here
%   Detailed explanation goes here

    x = size(D.X,1);
    y = size(Dv.X,1);
    z = size(Dt.X,1);
    n = size(D.X,2);
    Dmiss = zeros(x+y+z,n);
    t = size(Dmiss,1);
    total_miss = mar_percent*(t*n)/100;
    line_miss = total_miss/t;
    [v_feats v_prods] = getv_inffeature(F);

    switch (mar_method)
        case 'mar_miss_prod' % MCAR on pixels and then delete the prods of the missing pixel.
            for i=1:t
                v_aux = find(v_feats==0);
                p_rand = randperm(length(v_aux));
                j = 1;
                while (sum(Dmiss(i,:)) < line_miss)
                    Dmiss(i,v_aux(p_rand(j))) = 1;
                    Dmiss(i,v_prods{v_aux(p_rand(j))}) = 1;
                    j=j+1;
                end
            end
            M_mar = Dmiss(1:x,:);
            Mv_mar = Dmiss((x+1):(x+y),:);
            Mt_mar = Dmiss((x+y+1):end,:);
    end
    M_mar = logical(M_mar);
    Mt_mar = logical(Mt_mar);
    Mv_mar = logical(Mv_mar);
end

