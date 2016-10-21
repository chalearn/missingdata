function [ fid, num_feats ] = fs_rank( fs_method, th_method, D, Dt, Dv)
%FS_METHOD Summary of this function goes here
%   Detailed explanation goes here

% Select features selection method
switch(fs_method)
    case 1 % s2n method
        my_fs_method=s2n;
    otherwise 
        my_fs_method=s2n;
end
N = size(D.X,2);
switch (th_method)
    case 1 % log2 threshold
        nmax = floor(log2(N));
        num_feats = 2.^(0:nmax);
    otherwise
end
if nmax~=N
    num_feats = [num_feats N];
end

% Ordered all the features of the dataset.
[~, selected_features] = train(my_fs_method, D);

fid = cell(1,length(num_feats));
% Calculate the values and graphics
for i=1:length(num_feats)
    aux_fn = num_feats(i);
    % fprintf(' ==== Traning on %d features ===\n', aux_fn);
    % Indices of selected features
    fid{i} = selected_features.fidx(1:aux_fn);
end

