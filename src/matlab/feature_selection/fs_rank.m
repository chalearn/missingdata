function [ fid, num_feats, error ] = fs_rank( fs_method, th_method, D)
%FS_METHOD Obtain the relevance rankings of a data D according to the FS
%method selected and the threshold.
%   fs_method:  number that represents the FS method.
%               1 - s2n
%               2 - ttest
%   th_method:  number that represents the threshold method.
%               1 - log2n
%   D: Data type that represents the dataset to be analyzed.

% Check the number of parameters
fid = [];
num_feats = [];
error = 0;
if (nargin<3)
    error = 1;
else
    N = size(D.X,2);
    % Apply a feature selection method
    switch(fs_method)
        case 1 % s2n method
            % Ordered all the features of the dataset.
            [~, selected_features] = train(s2n, D);
            fpos = selected_features.fidx;
        case 2 % t-test method
            % Ordered all the features of the dataset.
            tvalue=zeros(1,N);
            for f=1:N
                feat = D.X(:,f);
                [~, tvalue(1,f)] = ttest(feat(~isnan(feat)));
            end
            [ord, fpos] = sort(tvalue,'descend');
            fpos = [fpos(~isnan(ord)) fpos(isnan(ord))];
        otherwise
            error = 2;
    end
    % Apply a threshold method    
    switch (th_method)
        case 1 % log2 threshold
            nmax = floor(log2(N));
            num_feats = 2.^(0:nmax);
        otherwise
            error = 3;
    end
    if (~error)
        % Add the total of features to the list
        if (nmax~=N)
            num_feats = [num_feats N];
        end

        % Obtain the different rankings of relevance
        fid = cell(1,length(num_feats));
        for i=1:length(num_feats)
            aux_fn = num_feats(i);
            % Indices of selected features
            fid{i} = fpos(1:aux_fn);
        end
    end
end


