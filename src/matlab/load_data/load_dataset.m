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
%                   2 - Some file does not exist.

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
        dx_file_name = [fold_root_data filesep file_name_train '.data'];
        dy_file_name = [fold_root_data filesep file_name_train '.labels'];
        if (exist(dx_file_name, 'file') == 2) && exist(dy_file_name, 'file') == 2
            X=load(dx_file_name);
            Y=load(dy_file_name);
            D = data (X, Y);
        else
            error_ld = 2;
        end
    end
    if (nargin>2)
        dvx_file_name = [fold_root_data filesep file_name_valid '.data'];
        dvy_file_name = [fold_root_data filesep file_name_valid '.labels'];
        if (exist(dvx_file_name, 'file') == 2) && exist(dvy_file_name, 'file') == 2            
            Xv=load();
            Yv=load();
            Dv = data (Xv, Yv);
        else
            error_ld = 2;
        end
    end
    if (nargin>3)
        dtx_file_name = [fold_root_data filesep file_name_test '.data'];
        dty_file_name = [fold_root_data filesep file_name_test '.labels'];
        if (exist(dtx_file_name, 'file') == 2) && exist(dty_file_name, 'file') == 2            
            Xt=load(dtx_file_name);
            Yt=load(dty_file_name);
            Dt = data (Xt, Yt);
        else
            error_ld = 2;
        end
    end
    if (nargin>4)
        f_file_name = [fold_root_data filesep file_name_probes '.info'];
        if (exist(f_file_name, 'file') == 2)
            F=read_label(f_file_name); % Know the identity of the probes
        else
            error_ld = 2;
        end
        t_file_name = [fold_root_data filesep file_name_probes '.labels'];
        if (exist(t_file_name, 'file') == 2)
            T=load(t_file_name); % +1 for a real feature; -1 for a probe
        else
            error_ld = 2;
        end
    end
end