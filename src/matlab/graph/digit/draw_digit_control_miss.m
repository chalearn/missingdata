function [ output_args ] = draw_digit_control_miss(D, D_miss, option)
% M=browse_digit(X,Y,F)
% Browse through a digit database
% D -- Data object
% D_miss -- Data miss object
% option -- 0 show original image without mark missing values (default)
%           1 mark missing values over original image
%           2 mark missing values and delete it on original image
%           3 delete missing values on original image without mark their

if (isempty(option)) option = 0; end
    
n=1;
p=-1;
e=0;
% Obtain the missing matrix
X_miss = D_miss.X;

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

    switch(option)
        case 0
            M_o = D.X(num,1:end/2);
            M_o_miss = zeros(size(M_o));
            M_p = D.X(num,(end/2)+1:end);
            M_p_miss = zeros(size(M_p));
        case 1
            M_o = D.X(num,1:end/2);
            M_o_miss = isnan(X_miss(num,1:end/2));
            M_p = D.X(num,(end/2)+1:end);
            M_p_miss = isnan(X_miss(num,(end/2)+1:end));
        case 2
            M_o = X_miss(num,1:end/2);
            M_o_miss = isnan(X_miss(num,1:end/2));
            M_p = X_miss(num,(end/2)+1:end);
            M_p_miss = isnan(X_miss(num,(end/2)+1:end));
        case 3
            M_o = X_miss(num,1:end/2);
            M_o_miss = zeros(size(M_o));
            M_p = X_miss(num,(end/2)+1:end);
            M_p_miss = zeros(size(M_p));
    end

    title(['Index: ' num2str(num) ' --  Class: ' num2str(D.Y(num,1))], 'FontSize', 16);
    subplot(1,2,1);
    show_digit(M_o,M_o_miss,'r');
    title('Real features');
    subplot(1,2,2);
    show_digit(M_p,M_p_miss,'r');
    title('Control features');
end