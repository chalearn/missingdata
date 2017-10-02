function [ D_miss, Dv_miss, Dt_miss, error_m] = ...
                    mcar( mcar_meth, mcar_perc, D, Dv, Dt )
%MCAR   Generate the missing values in a dataset according to MCAR method 
%       indicated (both train, validation and test).
% INPUT:
%   mcar_meth:  Name that represents the missingnes method:
%                   'flipcoin'  - fli-coin
%   mcar_perc:  Percentage missingness value that will be generated.
%   D:          Data type that represents the training dataset that will be used.
%   Dv:         Data type that represents the validation dataset that will be used.
%   Dt:         Data type that represents the test dataset that will be used.
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

    switch (mcar_meth)
        case 'flipcoin' % flip-coin
            total_size = samp*n;
            miss_size = round(total_size*(mcar_perc/100));
            rank_v = randperm(total_size);
            miss_pos = rank_v(1:miss_size);
            Dmiss = zeros(samp,n)';
            Dmiss(miss_pos)=1;
            Dmiss = Dmiss';
            M_mcar = Dmiss(1:x,:);
            if (flag_valid)
                Mt_mcar = Dmiss((x+1):(x+y),:);
            end
            if (flag_test)
                Mv_mcar = Dmiss((x+y+1):end,:);
            end
        otherwise
            error_m = 3;
    end
    
    % Get the final samples of the dataset with missing data as NaN values.
    M_mcar = logical(M_mcar);
    X(M_mcar)=NaN;
    D_miss.X = X;
    if (flag_valid)   
        Mv_mcar = logical(Mv_mcar);
        Xv(Mv_mcar)=NaN;
        Dv_miss.X = Xv;
    end
    if (flag_test)
        Mt_mcar = logical(Mt_mcar);
        Xt(Mt_mcar)=NaN;
        Dt_miss.X = Xt;
    end 
end

