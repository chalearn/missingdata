function [ path_ftrain, path_fvalid, path_ftest, path_fprobes, error_sd ] = ...
                store_dataset( fold_root_data, file_basename, D, Dv, Dt, F, T )
%STORE_DATASET Store the Matlab variables into dataset files.
% INPUT:
%   fold_root_data:     Path of the dataset root folder.
%   file_basename:      Basename of the file.
%   D:                  Data type that represents the dataset that will be classified.
%   Dv:                 Data type that represents the dataset that will be used to
%                       perform the validation.
%   Dt:                 Data type that represents the dataset that will be used to
%                       perform the test.
%   F:          
%   T:                  Array of target values.
% OUTPUT:
%   path_ftrain:        Path of the train file.
%   path_fvalid:        Path of the validation file.
%   path_ftest:         Path of the test file.
%   path_fprobes:       Path of the probes file.
%   error_sd:           Possible error when the function is executed:
%                           0 - No error.
%                           1 - Incorrect number of parameters.
%                           2 - Incorrect root folder path or file basename.

% Set the initial value of return variables.
path_ftrain = [];
path_fvalid = [];
path_ftest = [];
path_fprobes = [];
error_sd = 0;

% Check the number of parameters.
if (nargin<3)
    error_sd = 1;
else
    if (isempty(fold_root_data) || (isempty(file_basename)))
        error_sd = 2;
    else
        if (nargin>2 && ~isempty(D))
            % Save the train data to the files.
            dlmwrite([fold_root_data filesep file_basename '_train.data'], D.X, ' ');
            dlmwrite([fold_root_data filesep file_basename '_train.labels'], D.Y, ' ');
        end
        if (nargin>3 && ~isempty(Dv))
            % Save the validation data to the files.
            dlmwrite([fold_root_data filesep file_basename '_valid.data'], Dv.X, ' ');
            dlmwrite([fold_root_data filesep file_basename '_valid.labels'], Dv.Y, ' ');
        end
        if (nargin>4 && ~isempty(Dt))
            % Save the test data to the files.
            dlmwrite([fold_root_data filesep file_basename '_test.data'], Dt.X, ' ');
            dlmwrite([fold_root_data filesep file_basename '_test.labels'], Dt.Y, ' ');
        end
        if (nargin>5 && ~isempty(F))
            % Save the feat data to the files.
            fileID = fopen([fold_root_data filesep file_basename '_feat.info'],'w');
            fprintf(fileID,'%s\n', F{:});
            fclose(fileID);
        end
        if (nargin>6 && ~isempty(T))
            % Save the feat data to the files.
            dlmwrite([fold_root_data filesep file_basename '_feat.labels'], T, ' ');
        end
    end
end