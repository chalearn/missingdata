function [ D, Dt, Dv, F, T ] = create_probes(D, Dt, Dv, F, T)
%CREATE_PROBES Summary of this function goes here
%   Detailed explanation goes here

    X_control = zeros(size(D.X));
    Xt_control = zeros(size(Dt.X));
    Xv_control = zeros(size(Dv.X));
    for c=1:size(D.X,2)
        X_control(:,c) = D.X(randperm(size(D.X,1)),c);
    end
    for c=1:size(Dt.X,2)
        Xt_control(:,c) = Dt.X(randperm(size(Dt.X,1)),c);
    end
    for c=1:size(Dv.X,2)
        Xv_control(:,c) = Dv.X(randperm(size(Dv.X,1)),c);
    end
    D.X = [D.X X_control];
    Dt.X = [Dt.X Xt_control];
    Dv.X = [Dv.X Xv_control];
end

