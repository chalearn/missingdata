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
    [v_type_feat v_id_pixel v_prod] = getv_inffeature(F);

    switch (mar_method)
        case 'mar_miss_prod' % MCAR on pixels and then delete the prods of the missing pixel.
            for i=1:t
                v_aux = find(v_type_feat==0);
                p_rand = randperm(length(v_aux));
                j = 1;
                while ( (sum(Dmiss(i,:)) < line_miss) && ...
                        (j <= length(p_rand)) )
                    Dmiss(i,v_aux(p_rand(j))) = 1;
                    Dmiss(i,v_prod{v_aux(p_rand(j))}) = 1;
                    j=j+1;
                end
            end
            M_mar = Dmiss(1:x,:);
            Mv_mar = Dmiss((x+1):(x+y),:);
            Mt_mar = Dmiss((x+y+1):end,:);
        case 'mar_miss_neigh_prod'
            for i=1:t
                v_aux = find(v_type_feat==0);
                p_rand = randperm(length(v_aux));
                j = 1;
                while ( (sum(Dmiss(i,:)) < line_miss) && ...
                        (j <= length(p_rand)) )
                    Dmiss(i,v_aux(p_rand(j))) = 1;
                    Dmiss(i,v_prod{v_aux(p_rand(j))}) = 1;
                    pos_neigh = getpos_neighbord(v_aux(p_rand(j)), v_type_feat, v_id_pixel, 1);
                    Dmiss(i,pos_neigh) = 1;
                    Dmiss(i,[v_prod{pos_neigh}]) = 1;
                    j=j+1;
                end
            end
            M_mar = Dmiss(1:x,:);
            Mv_mar = Dmiss((x+1):(x+y),:);
            Mt_mar = Dmiss((x+y+1):end,:);
        case 'mar_miss_neigh_prod_corr'
        case 'mar_miss_top_image'
    end
    M_mar = logical(M_mar);
    Mt_mar = logical(Mt_mar);
    Mv_mar = logical(Mv_mar);
end

