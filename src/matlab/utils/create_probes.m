function [ D ] = create_probes(D)
%CREATE_PROBES Summary of this function goes here
%   Detailed explanation goes here

    X_control = zeros(size(D.X));
    for c=1:size(D.X,2)
        X_control(:,c) = D.X(randperm(size(D.X,1)),c);
    end
    D.X = [D.X X_control];
end

