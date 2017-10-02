function [ D_miss, Dv_miss, Dt_miss, error_m ] = ...
                        missing_data( miss_type, miss_meth, ...
                                      miss_perc, D, Dv, Dt, F, T )
%MISSING_DATA Generate the missing values in a dataset according to an
%             missingness method indicated (both train, validation and test).
% INPUT:
%   miss_type:  Name that represents the missingnes type.
%                   'mcar'  - mcar
%                   'mar'   - mar
%   miss_meth:  Name that represents the missingnes method within the 
%               missingnes type (For more information look at the definition
%               of each missing function).
%   miss_perc:  Percentage missingness value that will be generated.
%   D:          Data type that represents the training dataset that will be used.
%   Dv:         Data type that represents the validation dataset that will be used.
%   Dt:         Data type that represents the test dataset that will be used.
%   F:   
%   T:          Array of target values.
% OUTPUT:
%   D_miss:     Data type that represents the missingness train dataset.
%   Dv_miss:    Data type that represents the missingness validation dataset.
%   Dt_miss:    Data type that represents the missingness test dataset.
%   error_m:    Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.
%                   2 - Incorrect missing type requested.
%                   3 - Incorrect missing method requested.

% Set the initial value of return variables.
D_miss = [];
Dv_miss = [];
Dt_miss = [];
error_m = 0;

% Check the number of parameters.
if (nargin < 4)
    error_m = 1;
else                                                  
    switch(miss_type)
        case 'mcar'
            [D_miss, Dv_miss, Dt_miss, error_m] = mcar(miss_meth, miss_perc, D, Dv, Dt);
        case 'mar'
            [D_miss, Dv_miss, Dt_miss, error_m] = mar(miss_meth, miss_perc, D, Dv, Dv, F, T);
        case 'mnar'
        otherwise
            error_m = 2;
    end
end

