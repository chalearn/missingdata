function [ D_miss, Dt_miss, Dv_miss ] = mar( mar_method, mar_percent, D, Dt, Dv, F, T);
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
                p_rand1 = randperm(length(v_aux_pix));
                j = 1;
                while ( ( (sum(Dmiss(i,:)) < real_miss) || ...
                          (sum(Dmiss(i,v_aux_pix)) < pixel_miss) ) && ...
                        (j <= length(p_rand1)) )
                    Dmiss(i,v_aux_pix(p_rand1(j))) = 1;
                    Dmiss(i,v_prod{v_aux_pix(p_rand1(j))}) = 1;
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
                p_rand1 = randperm(length(v_aux_pix));
                j = 1;
                while ( ( (sum(Dmiss(i,:)) < real_miss) || ...
                          (sum(Dmiss(i,v_aux_pix)) < pixel_miss) ) && ...
                        (j <= length(p_rand1)) )
                    Dmiss(i,v_aux_pix(p_rand1(j))) = 1;
                    Dmiss(i,v_prod{v_aux_pix(p_rand1(j))}) = 1;
                    pos_neigh = getpos_neighbord(v_aux_pix(p_rand1(j)), v_type_feat, v_id_pixel, 1);
                    Dmiss(i,pos_neigh) = 1;
                    Dmiss(i,[v_prod{pos_neigh}]) = 1;
                    j=j+1;
                end
            end
            M_mar = Dmiss(1:x,:);
            Mt_mar = Dmiss((x+1):(x+y),:);
            Mv_mar = Dmiss((x+y+1):end,:);
        case 'neigh_and_prod_corr'
            v_aux_pix = find(v_type_feat==0);
            v_aux_prod = find(v_type_feat==1);
            % Check if the number of remove pixels is less than the 75
            % percent of the real number of pixels than must be removed.
            pixel_miss = size(v_aux_pix,2)*(mar_percent/100)*0.75;
            real_miss = (size(v_aux_pix,2)+size(v_aux_prod,2))*(mar_percent/100);
            p_rand1 = randperm(length(v_aux_pix));
            p_rand2 = randperm(length(v_aux_pix));
            r = randperm(x);
            rt = randperm(y);
            rv = randperm(z);
            r_miss1 = [r(1:end/2) rt(1:end/2)+x rv(1:end/2)+x+y];
            r_miss2 = [r(end/2:end) rt(end/2:end)+x rv(end/2:end)+x+y];
            j = 1;
            while ( ( (sum(Dmiss(r_miss1(1),:)) < real_miss) || ...
                      (sum(Dmiss(r_miss1(1),v_aux_pix)) < pixel_miss) ) && ...
                    (j <= length(p_rand1)) )
                Dmiss(r_miss1,v_aux_pix(p_rand1(j))) = 1;
                Dmiss(r_miss1,v_prod{v_aux_pix(p_rand1(j))}) = 1;
                pos_neigh = getpos_neighbord(v_aux_pix(p_rand1(j)), v_type_feat, v_id_pixel, 1);
                Dmiss(r_miss1,pos_neigh) = 1;
                Dmiss(r_miss1,[v_prod{pos_neigh}]) = 1;
                j=j+1;
            end
            while ( ( (sum(Dmiss(r_miss2(1),:)) < real_miss) || ...
                      (sum(Dmiss(r_miss2(1),v_aux_pix)) < pixel_miss) ) && ...
                    (j <= length(p_rand2)) )
                Dmiss(r_miss2,v_aux_pix(p_rand2(j))) = 1;
                Dmiss(r_miss2,v_prod{v_aux_pix(p_rand2(j))}) = 1;
                pos_neigh = getpos_neighbord(v_aux_pix(p_rand2(j)), v_type_feat, v_id_pixel, 1);
                Dmiss(r_miss2,pos_neigh) = 1;
                Dmiss(r_miss2,[v_prod{pos_neigh}]) = 1;
                j=j+1;
            end
            M_mar = Dmiss(1:x,:);
            Mt_mar = Dmiss((x+1):(x+y),:);
            Mv_mar = Dmiss((x+y+1):end,:);
        case 'top_image'
            pos_top = gettop_image(v_type_feat, v_id_pixel, mar_percent);
            r = randperm(x);
            rt = randperm(y);
            rv = randperm(z);
            r_miss = [r(1:end/2) rt(1:end/2)+x rv(1:end/2)+x+y];
            Dmiss(r_miss, pos_top) = 1;
            Dmiss(r_miss,[v_prod{pos_top}]) = 1;
            M_mar = Dmiss(1:x,:);
            Mt_mar = Dmiss((x+1):(x+y),:);
            Mv_mar = Dmiss((x+y+1):end,:);            
    end
    
    % Generate the probes features with missing values.
    M_mar = logical(M_mar);
    Mt_mar = logical(Mt_mar);
    Mv_mar = logical(Mv_mar);
    % Get the final samples of the dataset with missing data on pixels
    % as NaN values.
    X(M_mar)=NaN;
    Xt(Mt_mar)=NaN;
    Xv(Mv_mar)=NaN;
    % Generate the probes with missing data values.
    v_aux_pix = find(v_type_feat==0);
    probes = find(v_type_feat==2);
    p_rand1 = randperm(length(v_aux_pix));
    for i=1:length(probes)
        pos_feat = v_aux_pix(p_rand1(mod(i-1,length(p_rand1))+1));
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
    % Get the final samples of the dataset with missing data as NaN values.
    D_miss.X = X;
    Dt_miss.X = Xt;
    Dv_miss.X = Xv;
end

