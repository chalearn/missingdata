function [ D_miss, Dt_miss, Dv_miss, M_mar, Mt_mar, Mv_mar ] = ...
                            mar( mar_method, mar_percent, D, Dt, Dv, F, T);
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
    
    Dmiss = zeros(x+y+z,n);
    t = size(Dmiss,1);
    [v_type_feat v_id_pixel v_prod] = getv_inffeature(F);

    switch (mar_method)
        case 'prod' % MCAR on pixels and then delete the prods of the missing pixel.
            for i=1:t
                v_aux = find(v_type_feat==0);
                pixel_miss = size(v_aux,2)*(mar_percent/100);
                p_rand = randperm(length(v_aux));
                j = 1;
                while ( (sum(Dmiss(i,:)) < pixel_miss) && ...
                        (j <= length(p_rand)) )
                    Dmiss(i,v_aux(p_rand(j))) = 1;
                    Dmiss(i,v_prod{v_aux(p_rand(j))}) = 1;
                    j=j+1;
                end
            end
            M_mar = Dmiss(1:x,:);
            Mt_mar = Dmiss((x+1):(x+y),:);
            Mv_mar = Dmiss((x+y+1):end,:);
        case 'neigh_and_prod'
            for i=1:t
                v_aux = find(v_type_feat==0);
                pixel_miss = size(v_aux,2)*(mar_percent/100);
                p_rand = randperm(length(v_aux));
                j = 1;
                while ( (sum(Dmiss(i,:)) < pixel_miss) && ...
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
            Mt_mar = Dmiss((x+1):(x+y),:);
            Mv_mar = Dmiss((x+y+1):end,:);
        case 'neigh_and_prod_corr'
        case 'top_image'
    end
    M_mar = logical(M_mar);
    Mt_mar = logical(Mt_mar);
    Mv_mar = logical(Mv_mar);
    
    % Get the final samples of the dataset with missing data as NaN values.
    X(M_mar)=NaN;
    Xt(Mt_mar)=NaN;
    Xv(Mv_mar)=NaN;
    D_miss.X = X;
    Dt_miss.X = Xt;
    Dv_miss.X = Xv;
end

