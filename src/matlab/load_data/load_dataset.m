function [ D, Dv, Dt, F, T, error_ld ] = load_dataset( fold_root_data, ...
                                    file_name_train, file_name_valid, ...
                                    file_name_test, file_name_probes )
%LOAD_DATASET Load the dataset files into Matlab variables.
% INPUT:
%   fold_root_data:     Path of the dataset root folder.
%   file_name_train:    Name of the train file.
%   file_name_valid:    Name of the validation file.
%   file_name_test:     Name of the test file.
%   file_name_probes:   Name of the probes file.
% OUTPUT:
%   D:          Data type that represents the dataset that will be classified.
%   Dv:         Data type that represents the dataset that will be used to
%               perform the validation.
%   Dt:         Data type that represents the dataset that will be used to
%               perform the test.
%   F:          
%   T:          Array of target values.
%   error_ld:   Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.

% Set the initial value of return variables.
D = [];
Dv = [];
Dt = [];
F = [];
T = [];
error_ld = 0;

% Check the number of parameters.
if (nargin<2)
    error_ld = 1;
else
    if (nargin>1)
        X=load([fold_root_data filesep file_name_train '.data']);
        Y=load([fold_root_data filesep file_name_train '.labels']);
        D = data (X, Y);
    end
    if (nargin>2)
        Xv=load([fold_root_data filesep file_name_valid '.data']);
        Yv=load([fold_root_data filesep file_name_valid '.labels']);
        Dv = data (Xv, Yv);
    end
    if (nargin>3)
        Xt=load([fold_root_data filesep file_name_test '.data']);
        Yt=load([fold_root_data filesep file_name_test '.labels']);
        Dt = data (Xt, Yt);
    end
    if (nargin>4)
        F=read_label([fold_root_data filesep file_name_probes '.info']); % Know the identity of the probes
        T=load([fold_root_data filesep file_name_probes '.labels']); % +1 for a real feature; -1 for a probe
    end
end