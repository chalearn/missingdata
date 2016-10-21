function X = replace_missing(X, method, snum, maxiter)
%X = replace_missing(X, method, snum, maxiter)
% Replace missing data with a trivial method.
% X a (p, n) matrix, patterns in lines, features in columns
% method: a choice of:
%   - 'zeros': all zeros
%   - 'median': median value
%   - 'svd': singular value decomposition method
% snum and maxiter are parameters of the 'svd' option: number of singular
% values and number of iterations.
% Note: there is a basic problem here: if we do "discovery" we can use all
% the matrix to fill in the missing values. If we do "prediction" can we
% assume that we have all the data at the time we do imputation?
% In any case, we should not use the target values to fill in missing data
% or else we will bias the result.

% Isabelle Guyon -- October 2016 -- isabelle@clopinet.com

if nargin<2, method='median'; end
if nargin<3, snum=10; end
if nargin<4, maxiter=10; end

[p, n]=size(X);

switch method
    case 'zeros'
        X(isnan(X)) = 0;

    case 'median'
        for k=1:n
            missing=isnan(X(:,k));
            med = median(X(~missing,k));
            X(missing,k)=med;
        end
    case 'svd'
        missing = isnan(X);
        X(missing)=0;
        for k=1:maxiter
            [U, S, V] = svds(X, snum);
            XX = U*S*V;
            X(missing) = XX(missing);
        end
    otherwise
        disp 'No such type';
end


end

