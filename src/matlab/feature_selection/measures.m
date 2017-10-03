function [ result, error_m ] = measures( measure_meth, T, id_fs )
%MEASURES Obtain the selected measure according to the feature selection
%         process (taking into account relevant and irrelevant features).
% INPUT:
%   measure_meth:   Name that represents the measure method.
%                       'prec'  - precission.
%                       'rec'   - recall.
%   T:              Array of feature relevance.
%                       1       - relevant feature.
%                       -1      - irrelevant feature.
%   id_fs:          Cell array with the id of selected features. Each cell
%                   corresponds with a number (threshold) of selected features.
% OUTPUT:
%   result:         Result value of the measure selected
%   error_m:        Possible error when the function is executed:
%                       0 - No error.
%                       1 - Incorrect number of parameters.
%                       2 - Incorrect measure method requested.

% Set the initial value of return variables.
result = [];
error_m = 0;

% Check the number of parameters.
if (nargin<3)
    error_m = 1;
else    
    num_positive = length(find(T==1));
    num_negative = length(find(T==-1));
    num_feats = cell2mat(cellfun(@length, id_fs,'uni',false));
    for i=1:length(id_fs)
        true_positive(i) = sum(T(id_fs{i})==1);
    end
    % Apply a measure method to obtain the result.
    switch(measure_meth)
        case 'prec'
            result = true_positive./num_feats;
        case 'rec'
            result = true_positive./num_positive;
        case ''
        otherwise
            error_m = 1;
    end
end