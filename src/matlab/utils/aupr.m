function global_score=aupr(x, y)
%global_score=aupr(x, y)
% Compute the Area under curve
% Inputs:
% x --              Values of number of examples used for training
% y --              Corresponding AUC values
% Returns:
% global_score --   UUPR

% Author: Isabelle Guyon -- Oct 2016 -- isabelle@clopinet.com

% Create a log2 scale
%x=log2(x);

% Compute the score
A=0;
% Integrate by the trapeze method
for k=2:length(x)
    deltax=x(k)-x(k-1);
    mu=(y(k)+y(k-1))/2;
    A=A+deltax*mu;
end

global_score=A; % No normalization (yet)
    
return
    