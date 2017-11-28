function [ D_sol, Dv_sol, Dt_sol, error_s ] = ...
                solve_missing( solv_type, solv_meth, D_miss, Dv_miss, Dt_miss )
%IMPUTATION Imput the values in a missing dataset according to an
%           imputation method indicated (both train, validation and test).
% INPUT:
%   solv_type:  Name that represents the solution missing type.
%                   'del'   - deletion
%                   'imp'   - imputation
%   solv_meth:  Name that represents the solution method within the 
%               solution missing type (For more information look at the definition
%               of each solution function).
%   D_miss:     Data type that represents the missing train dataset that
%               will be imputed.
%   Dv_miss:    Data type that represents the missing validation dataset 
%               that will be imputed.
%   Dt_miss:    Data type that represents the missing test dataset that
%               will be imputed.
% OUTPUT:
%   D_sol:      Data type that represents the solved train dataset.
%   Dv_sol:     Data type that represents the solved validation dataset.
%   Dt_sol:     Data type that represents the solved test dataset.
%   error_i:    Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.
%                   2 - Incorrect solution type requested.
%                   3 - Incorrect solution method requested.

% Set the initial value of return variables.
D_sol = [];
Dv_sol = [];
Dt_sol = [];
error_s = 0;

% Check the number of parameters.
if (nargin < 3)
    error_s = 1;
else                                                  
    switch(solv_type)
        case 'del'
            [D_sol, Dv_sol, Dt_sol, error_s] = deletion(solv_meth, D_miss, Dv_miss, Dt_miss);
        case 'imp'
            [D_sol, Dv_sol, Dt_sol, error_s] = imputation(solv_meth, D_miss, Dv_miss, Dt_miss);
        otherwise
            error_s = 2;
    end
end