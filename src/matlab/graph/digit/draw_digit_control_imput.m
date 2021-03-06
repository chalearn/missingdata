function [ output_args ] = draw_digit_control_imput(D, D_miss, rank_list)
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
X_feat = zeros(size(X_miss));
X_feat(:,rank_list) = 1;

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
%   if convert_pix,
%       M1=zeros(1,28*28);
%       M1(feat_idx)=D.X(num,feat_loc);
%       M2=zeros(1,28*28);
%       M2(feat_idx)=D_miss.X(num,feat_loc);
%       MM2=zeros(1,28*28);
%       MM2(feat_idx)=M_mcar(num,feat_loc);
%       M3=zeros(1,28*28);
%       M3(feat_idx)=D_mcar.X(num,feat_loc);
%   else
        M_o = D.X(num,1:end/2);
        M_o_miss = isnan(X_miss(num,1:end/2));
        M_p = X_miss(num,(end/2)+1:end);
        M_p_miss = isnan(X_miss(num,(end/2)+1:end));
        M_o_relevant = X_feat(num,1:end/2);
        M_p_relevant = X_feat(num,(end/2)+1:end);
%   end
    title(['Index: ' num2str(num) ' --  Class: ' num2str(D.Y(num,1))], 'FontSize', 16);
    subplot(2,2,1);
    show_digit(M_o,M_o_miss,'r');
    title('Original (red points are missing)');
    subplot(2,2,2);
    show_digit(M_p,M_p_miss,'r');
    title('Control image');
    subplot(2,2,3);
    show_digit(M_o,M_o_relevant,'b');
    title('Relevant (blue points are the most relevant features)');
    subplot(2,2,4);
    show_digit(M_p,M_p_relevant,'b');
    title('Control image');
end