function [M1 M2 ] = draw_digit_control(D, D_miss)
% M=browse_digit(X,Y,F)
% Browse through a digit database
% X -- Matrix with digits in lines
% Y -- Matrix with labels.
% F -- Array with feature identities.
% x -- Last digit read.
% Isabelle Guyon -- isabelle @ clopinet.com -- May 2005
% convert_pix=0;
% feat_idx=[];
% feat_loc=[];
% if nargin>3,
%     convert_pix=1;
%     kk=0;
%     for k=1:length(F)
%         ff=F{k};
%         if isempty(strfind(ff, 'perm'))&&isempty(strfind(ff, 'probe'))&&isempty(strfind(ff, 'pair'))
%             kk=kk+1;
%             dash=strfind(ff, '-');
%             ff=ff(dash(end)+1:end);
%             feat_idx(kk)=str2num(ff);
%             feat_loc(kk)=k;
%         end
%     end
% end
% 
n=1;
p=-1;
e=0;
% Obtain the missing matrix
X_miss = D_miss.X;
X_control = zeros(size(D.X))
for c=1:size(D.X,2)
    X_control(:,c) = D.X(randperm(size(D.X,1)),c);
end

figure('name', 'Isabelle''s MNIST browser');
num=0;
while 1
    idx = input('Digit number (or n for next, p for previous, e exit)? ');
    if isempty(idx), idx=n; end
    switch idx
    case n
        num=min(num+1,length(D.Y));
    case p
        num=max(1,num-1);
    case e
        break
    otherwise
        num=idx;
    end
%    if convert_pix,
%        M1=zeros(1,28*28);
%        M1(feat_idx)=D.X(num,feat_loc);
%        M2=zeros(1,28*28);
%        M2(feat_idx)=D_miss.X(num,feat_loc);
%        MM2=zeros(1,28*28);
%        MM2(feat_idx)=M_mcar(num,feat_loc);
%        M3=zeros(1,28*28);
%        M3(feat_idx)=D_mcar.X(num,feat_loc);
%    else
        M1=X_miss(num,:);
        MM1 = isnan(X_miss(num,:));
        M2=X_control(num,:);
%    end
    title(['Index: ' num2str(num) ' --  Class: ' num2str(D.Y(num,1))], 'FontSize', 16);
    subplot(1,2,1);
    show_digit(M1,MM1);
    title('Original');
    subplot(1,2,2);
    show_digit(M2);
    title('Control');
end