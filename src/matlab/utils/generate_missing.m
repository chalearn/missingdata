function Rx = generate_missing(X, Y, frac, type)
%Rx = generate_missing(X, Y, frac, type)
% Generate indicators of missingness for dataset X with target values Y.
% Inputs:
% X a (p, n) matrix, patterns in lines, features in columns
% Y a (p, c) matrix, patterns in lines, target values in columns
% frac: fraction of missing values desired (a number between 0 and 1)
% type: 'MCAR', 'MAR', or 'MNAR'
% Returns:
% Rx: missing data indicator values.

% Isabelle Guyon -- October 2016 -- isabelle@clopinet.com

if nargin<2, Y=[]; end
if nargin<3, frac=0.5; end
if nargin<4, type = 'MCAR'; end

[p, n]=size(X);
Rx=zeros(p, n);

switch type
    case 'MCAR'
        ind = randperm(p*n);
        vec=zeros(p*n,1);
        vec(ind(1:round(frac*p*n)))=1;
        Rx=reshape(vec, p, n); 
    otherwise
        disp 'No such type';
end


end

