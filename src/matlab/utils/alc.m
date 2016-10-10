function global_score=alc(x, y)
%global_score=alc(x, y)
% Compute the Area under the Learning Curve (ALC)
% Inputs:
% x --              Values of number of examples used for training
% y --              Corresponding AUC values
% Returns:
% global_score --   Normalized ALC

% Author: Isabelle Guyon -- Oct 2016 -- isabelle@clopinet.com

% Create a log2 scale
x=log2(x);

% Compute the score
A=0;
% Integrate by the trapeze method
for k=2:length(x)
    deltax=x(k)-x(k-1);
    mu=(y(k)+y(k-1))/2;
    A=A+deltax*mu;
end

% Normalize the score
rand_predict = 0.5;
Arand=rand_predict*x(end);
Amax=x(end);

global_score=(A-Arand)/(Amax-Arand);
    
return
    