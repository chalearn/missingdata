function [ output_args ] = draw_digit_control(D)
% Browse through a digit database
% D -- Data object

n=1;
p=-1;
e=0;

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
    
    M_o = D.X(num,1:(end/2));
    M_p = D.X(num,(end/2)+1:end);

    title(['Index: ' num2str(num) ' --  Class: ' num2str(D.Y(num,1))], 'FontSize', 16);
    subplot(1,2,1);
    show_digit(M_o);
    title('Real features');
    subplot(1,2,2);
    show_digit(M_p);
    title('Control features');
end