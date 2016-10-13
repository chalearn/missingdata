function [ D Dt Dv F T ] = load_dataset( folder_data_root, f_train_name, ...
                                        f_test_name, f_valid_name, f_probes_name )
%LOAD_TRAIN_VALID_TEST Summary of this function goes here
%   Detailed explanation goes here

if nargin >= 2
    X=load([folder_data_root filesep f_train_name '.data']);
    Y=load([folder_data_root filesep f_train_name '.labels']);
    D = data (X, Y);
end
if nargin >= 3
    Xt=load([folder_data_root filesep f_test_name '.data']);
    Yt=load([folder_data_root filesep f_test_name '.labels']);
    Dt = data (Xt, Yt);
end
if nargin >= 4
    Xv=load([folder_data_root filesep f_valid_name '.data']);
    Yv=load([folder_data_root filesep f_valid_name '.labels']);
    Dv = data (Xv, Yv);
end
if nargin >= 5
    F=read_label([folder_data_root filesep f_probes_name '.info']); % Know the identity of the probes
    T=load([folder_data_root filesep f_probes_name '.labels']); % +1 for a real feature; -1 for a probe
end

end

