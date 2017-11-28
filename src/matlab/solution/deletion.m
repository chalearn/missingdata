function [D_del, Dv_del, Dt_del, error_d] = deletion(del_method, D_miss, Dv_miss, Dt_miss)
%DELETION   Delete samples in a missing dataset according to an
%           deletion method indicated (both train, validation and test).
% INPUT:
%   del_method: Name that represents the deletion method.
%                   'lwise' - listwise deletion
%                   'pwise' - pairwise deletion
%   D_miss:     Data type that represents the missing train dataset that
%               will be imputed.
%   Dv_miss:    Data type that represents the missing validation dataset 
%               that will be imputed.
%   Dt_miss:    Data type that represents the missing test dataset that
%               will be imputed.
% OUTPUT:
%   D_del:      Data type that represents the train dataset with missing
%               samples deleted.
%   Dv_del:     Data type that represents the validation dataset with
%               missing samples deleted.
%   Dt_del:     Data type that represents the test dataset with missing
%               samples deleted.
%   error_d:    Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.
%                   3 - Incorrect deleted method requested.

% Set the initial value of return variables.
D_del = [];
Dv_del = [];
Dt_del = [];
error_d = 0;

% Set the initial value of flags.
flag_valid = 0;
flag_test = 0;

% Check the number of parameters.
if (nargin<2)
    error_d = 1;
else
    if (nargin > 2)
        flag_valid = 1;
    end
    if (nargin > 3)
        flag_test = 1;
    end

    % Set initial values to return D struct and extract the X matrix to
    % work with those data after. 
    D_del = D_miss;
    X_miss = D_miss.X;
    x = size(X_miss,1);
    n = size(X_miss,2);
    if (flag_valid)
        Dv_del = Dv_miss;
        Xv_miss = Dv_miss.X;
        z = size(Xv_miss,1);
    end
    if (flag_test)
        Dt_del = Dt_miss;
        Xt_miss = Dt_miss.X;
        y = size(Xt_miss,1);
    end

    switch(del_method)
        case 'lwise' % deletion by listwise.
        case 'pwise' % deletion by pairwise.
        otherwise
            error_d = 3;
    end
    
    D_del.X = X_miss;
    if (flag_valid)
        Dv_del.X = Xv_miss;
    end
    if (flag_test)
        Dt_del.X = Xt_miss;
    end
end