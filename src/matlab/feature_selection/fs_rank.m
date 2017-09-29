function [ id_fs, size_fs, error_fs ] = fs_rank( fs_method, th_method, D_fs)
%FS_RANK Obtain the relevance rankings of a data D according to the FS
%method selected and the threshold.
% INPUT:
%   fs_method:  Number that represents the FS method.
%                   1 - s2n
%                   2 - ttest
%   th_method:  Number that represents the threshold method.
%                   1 - log2n
%   D_fs:       Data type that represents the dataset to be analyzed.
% OUTPUT:
%   id_fs:      Id of the features ordered according to their relevance.
%   size_fs:    Size of the subsets of features according to the threshold
%               method.
%   error_fs:   Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.
%                   2 - Incorrect feature selection method requested.
%                   3 - Incorrect threshold method requested.

% Check the number of parameters
id_fs = [];
size_fs = [];
error_fs = 0;
if (nargin<3)
    error_fs = 1;
else
    N = size(D_fs.X,2);
    % Apply a feature selection method
    switch(fs_method)
        case 1 % s2n method
            % Ordered all the features of the dataset.
            [~, selected_features] = train(s2n, D_fs);
            fpos = selected_features.fidx;
        case 2 % t-test method
            % Ordered all the features of the dataset.
            tvalue=zeros(1,N);
            for f=1:N
                feat = D_fs.X(:,f);
                [~, tvalue(1,f)] = ttest(feat(~isnan(feat)));
            end
            [ord, fpos] = sort(tvalue,'descend');
            fpos = [fpos(~isnan(ord)) fpos(isnan(ord))];
        otherwise
            error_fs = 2;
    end
    % Apply a threshold method    
    switch (th_method)
        case 1 % log2 threshold
            nmax = floor(log2(N));
            size_fs = 2.^(0:nmax);
        otherwise
            error_fs = 3;
    end
    if (~error_fs)
        % Add the total of features to the list
        if (nmax~=N)
            size_fs = [size_fs N];
        end

        % Obtain the different rankings of relevance
        id_fs = cell(1,length(size_fs));
        for i=1:length(size_fs)
            aux_fn = size_fs(i);
            % Indices of selected features
            id_fs{i} = fpos(1:aux_fn);
        end
    end
end


