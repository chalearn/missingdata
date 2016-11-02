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
            v_aux_pix = find(v_type_feat==0);
            v_aux_prod = find(v_type_feat==1);
            % Check if the number of remove pixels is less than the 75
            % percent of the real number of pixels than must be removed.
            pixel_miss = size(v_aux_pix,2)*(mar_percent/100)*0.75;
            real_miss = (size(v_aux_pix,2)+size(v_aux_prod,2))*(mar_percent/100);
            for i=1:t
                p_rand = randperm(length(v_aux_pix));
                j = 1;
                while ( ( (sum(Dmiss(i,:)) < real_miss) || ...
                          (sum(Dmiss(i,v_aux_pix)) < pixel_miss) ) && ...
                        (j <= length(p_rand)) )
                    Dmiss(i,v_aux_pix(p_rand(j))) = 1;
                    Dmiss(i,v_prod{v_aux_pix(p_rand(j))}) = 1;
                    j=j+1;
                end
            end
            M_mar = Dmiss(1:x,:);
            Mt_mar = Dmiss((x+1):(x+y),:);
            Mv_mar = Dmiss((x+y+1):end,:);
        case 'neigh_and_prod'
            v_aux_pix = find(v_type_feat==0);
            v_aux_prod = find(v_type_feat==1);
            % Check if the number of remove pixels is less than the 75
            % percent of the real number of pixels than must be removed.
            pixel_miss = size(v_aux_pix,2)*(mar_percent/100)*0.75;
            real_miss = (size(v_aux_pix,2)+size(v_aux_prod,2))*(mar_percent/100);
            for i=1:t
                p_rand = randperm(length(v_aux_pix));
                j = 1;
                while ( ( (sum(Dmiss(i,:)) < real_miss) || ...
                          (sum(Dmiss(i,v_aux_pix)) < pixel_miss) ) && ...
                        (j <= length(p_rand)) )
                    Dmiss(i,v_aux_pix(p_rand(j))) = 1;
                    Dmiss(i,v_prod{v_aux_pix(p_rand(j))}) = 1;
                    pos_neigh = getpos_neighbord(v_aux_pix(p_rand(j)), v_type_feat, v_id_pixel, 1);
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
    
    v_aux_pix = find(v_type_feat==0);
    probes = find(v_type_feat==2);
    p_rand = randperm(length(v_aux_pix));
    for i=1:length(probes)
        pos_feat = v_aux_pix(p_rand(mod(i-1,length(p_rand))+1));
        feat_X = X(:,pos_feat);
        feat_Xt = Xt(:,pos_feat);
        feat_Xv = Xv(:,pos_feat);
        feat_X = feat_X(randperm(length(feat_X')));
        feat_Xt = feat_Xt(randperm(length(feat_Xt')));
        feat_Xv = feat_Xv(randperm(length(feat_Xv')));
        X(:,probes(i)) = feat_X;
        Xt(:,probes(i)) = feat_Xt;
        Xv(:,probes(i)) = feat_Xv;
    end
    M_mar = isnan(X);
    Mt_mar = isnan(Xt);
    Mv_mar = isnan(Xv);
    D_miss.X = X;
    Dt_miss.X = Xt;
    Dv_miss.X = Xv;
end

