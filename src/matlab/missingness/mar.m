function [ D_miss, Dv_miss, Dt_miss, error_m ] = ...
                        mar( mar_meth, mar_perc, D, Dv, Dt, F, T)
%MAR    Generate the missing values in a dataset according to MAR method 
%       indicated (both train, validation and test).
% INPUT:
%   mar_meth:   Name that represents the missingnes method:
%                   'prod'                  - prods.
%                   'neigh'                 - neighborhood.
%                   'neigh_and_prod'        - neighborhood and prods.
%                   'neigh_and_prod_corr'   - correlated neighborhood and prods.
%                   'top_image'             - top image pixels.
%   mar_perc:   Percentage missingness value that will be generated.
%   D:          Data type that represents the training dataset that will be used.
%   Dv:         Data type that represents the validation dataset that will be used.
%   Dt:         Data type that represents the test dataset that will be used.
%   F:
%   T:
% OUTPUT:
%   D_miss:     Data type that represents the missingness train dataset.
%   Dv_miss:    Data type that represents the missingness validation dataset.
%   Dt_miss:    Data type that represents the missingness test dataset.
%   error_m:    Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.
%                   3 - Incorrect missing method requested.

% Set the initial value of return variables.
D_miss = [];
Dv_miss = [];
Dt_miss = [];
error_m = 0;

% Set the initial value of flags.
flag_valid = 0;
flag_test = 0;

% Check the number of parameters.
if (nargin < 3)
    error_m = 1;
else
    if (nargin > 3)
        flag_valid = 1;
    end
    if (nargin > 4)
        flag_test = 1;
    end
    
    % Set initial values to return D struct.
    D_miss = D;
    % Extract the X matrix to work with those data after. 
    X = D.X;
    % Get the sizes of each data subset.
    x = size(X,1);
    n = size(X,2);
    samp = x;
    if (flag_valid)
        Dv_miss = Dv;
        Xv = Dv.X;
        y = size(Xv,1);
        samp = samp + y;
    end
    if (flag_test)
        Dt_miss = Dt;
        Xt = Dt.X;
        z = size(Xt,1);
        samp = samp + z;
    end
    
    Dmiss = zeros(samp,n);
    [v_type_feat, v_id_pixel, v_prod] = getv_inffeature(F);

    switch (mar_meth)
        case 'prod' % MCAR on pixels and then delete the prods of the missing pixel.
            v_aux_pix = find(v_type_feat==0);
            v_aux_prod = find(v_type_feat==1);
            % Check if the number of remove pixels is less than the 75
            % percent of the real number of pixels than must be removed.
            pixel_miss = size(v_aux_pix,2)*(mar_perc/100)*0.75;
            real_miss = (size(v_aux_pix,2)+size(v_aux_prod,2))*(mar_perc/100);
            for i=1:samp
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
        case 'neigh'
            v_aux_pix = find(T'==1);
            v_aux_control = find(T'==-1);
            % Check if the number of remove pixels is less than the 75
            % percent of the real number of pixels than must be removed.
            pixel_miss = size(v_aux_pix,2)*(mar_perc/100)*0.75;
            real_miss = (size(v_aux_pix,2)+size(v_aux_control,2))*(mar_perc/100);
            for i=1:samp
                p_rand1 = randperm(length(v_aux_pix));
                j = 1;
                while ( ( (sum(Dmiss(i,:)) < real_miss) || ...
                          (sum(Dmiss(i,v_aux_pix)) < pixel_miss) ) && ...
                        (j <= length(p_rand1)) )
                    Dmiss(i,v_aux_pix(p_rand1(j))) = 1;
                    Dmiss(i,v_aux_control(p_rand1(j))) = 1;
                    pos_neigh = getpos_neighbord(v_aux_pix(p_rand1(j)), T'==-1, v_aux_pix, 1);
                    Dmiss(i,pos_neigh) = 1;
                    Dmiss(i,pos_neigh+size(v_aux_pix,2)) = 1;
                    j=j+1;
                end
            end
        case 'neigh_and_prod'
            v_aux_pix = find(v_type_feat==0);
            v_aux_prod = find(v_type_feat==1);
            % Check if the number of remove pixels is less than the 75
            % percent of the real number of pixels than must be removed.
            pixel_miss = size(v_aux_pix,2)*(mar_perc/100)*0.75;
            real_miss = (size(v_aux_pix,2)+size(v_aux_prod,2))*(mar_perc/100);
            for i=1:samp
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
        case 'neigh_and_prod_corr'
            v_aux_pix = find(v_type_feat==0);
            v_aux_prod = find(v_type_feat==1);
            % Check if the number of remove pixels is less than the 75
            % percent of the real number of pixels than must be removed.
            pixel_miss = size(v_aux_pix,2)*(mar_perc/100)*0.75;
            real_miss = (size(v_aux_pix,2)+size(v_aux_prod,2))*(mar_perc/100);
            p_rand1 = randperm(length(v_aux_pix));
            p_rand2 = randperm(length(v_aux_pix));
            r = randperm(x);
            rv = randperm(y);
            rt = randperm(z);
            r_miss1 = [r(1:end/2) rv(1:end/2)+x rt(1:end/2)+x+y];
            r_miss2 = [r(end/2:end) rv(end/2:end)+x rt(end/2:end)+x+y];
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
        case 'top_image'
            pos_top = gettop_image(v_type_feat, v_id_pixel, mar_perc);
            r = randperm(x);
            rv = randperm(y);
            rt = randperm(z);
            r_miss = [r(1:end/2) rv(1:end/2)+x rt(1:end/2)+x+y];
            Dmiss(r_miss, pos_top) = 1;
            Dmiss(r_miss,[v_prod{pos_top}]) = 1;       
        otherwise
            error_m = 3;
    end
    % Generate the probes with missing data values.
    v_aux_pix = find(v_type_feat==0);
    probes = find(v_type_feat==2);
    p_rand1 = randperm(length(v_aux_pix));
    
    M_mar = Dmiss(1:x,:);
    % Generate the probes features with missing values.
    M_mar = logical(M_mar);
    % Get the final samples of the dataset with missing data on pixels
    % as NaN values.
    X(M_mar)=NaN;
    for i=1:length(probes)
        pos_feat = v_aux_pix(p_rand1(mod(i-1,length(p_rand1))+1));
        feat_X = X(:,pos_feat);
        feat_X = feat_X(randperm(length(feat_X')));
        X(:,probes(i)) = feat_X;
    end
    % Get the final samples of the dataset with missing data as NaN values.
    D_miss.X = X;
    
    Mv_mar = Dmiss((x+1):(x+y),:);
    % Generate the probes features with missing values.
    Mv_mar = logical(Mv_mar);
    % Get the final samples of the dataset with missing data on pixels
    % as NaN values.
    Xv(Mv_mar)=NaN;
    for i=1:length(probes)
        pos_feat = v_aux_pix(p_rand1(mod(i-1,length(p_rand1))+1));
        feat_Xv = Xv(:,pos_feat);
        feat_Xv = feat_Xv(randperm(length(feat_Xv')));
        Xv(:,probes(i)) = feat_Xv;
    end    
    % Get the final samples of the dataset with missing data as NaN values.
    Dv_miss.X = Xv;
    
    Mt_mar = Dmiss((x+y+1):end,:);
    % Generate the probes features with missing values.
    Mt_mar = logical(Mt_mar);
    % Get the final samples of the dataset with missing data on pixels
    % as NaN values.
    Xt(Mt_mar)=NaN;
    for i=1:length(probes)
        pos_feat = v_aux_pix(p_rand1(mod(i-1,length(p_rand1))+1));
        feat_Xt = Xt(:,pos_feat);
        feat_Xt = feat_Xt(randperm(length(feat_Xt')));
        Xt(:,probes(i)) = feat_Xt;
    end
    % Get the final samples of the dataset with missing data as NaN values.
    Dt_miss.X = Xt;
end

