function [M1, M2, M3, error_dd] = draw_digit(D_orig, D_miss, D_imp, F_orig)
%DRAW_DIGIT Draw digits inside D_orig data object. This function can draw
%           missing pixels (red dot) and imputation values, obtaining a 
%           maximum of three different subplots inside figure.
% INPUT:
%   D_orig:     Data type that represents the original dataset that will be
%               drawn.
%   D_miss:     Data type that represents the missingness dataset that will be
%               drawn. If this variable is empty, it will not be
%               drawn the digit with imputed values.
%   D_imp:      Data type that represents the imputed dataset that will be
%               drawn. If this variable is empty, it will not be
%               drawn the digit with imputed values.
%   F_orig:     Array of feature type values. If this variable is empty, it
%               will be considered that the dataset does not contain
%               probes.
% OUTPUT:
%   M1:         Matrix that contains only the real pixel values of original
%               dataset.
%   M2:         Matrix that contains only the real pixel values of missing
%               dataset.
%   M3:         Matrix that contains only the real pixel values of imputed
%               dataset.
%   error_dd:   Possible error when the function is executed:
%                   0 - No error.
%                   1 - Incorrect number of parameters.

% Set the initial value of return variables.
M1 = [];
M2 = [];
M3 = [];
error_dd = 0;

% Set the initial value of flags.
flag_miss = 0;
flag_imp = 0;
flag_f = 0;

% Set the values of next previous and exit keyboard inputs
n=1;
p=-1;
e=0;

% Set the initial number of subplots
nsubplot = 1;

% Check the number of parameters.
if (nargin<1)
    error_dd = 1;
else
    if (nargin > 1 && ~isempty(D_miss))
            flag_miss = 1;
            nsubplot=nsubplot+1;
    end
    if (nargin > 2 && ~isempty(D_imp))
            flag_imp = 1;
            nsubplot=nsubplot+1;
    end
    if (nargin > 3 && ~isempty(F_orig))
            flag_f = 1;
    end

    feat_idx=[];
    feat_loc=[];
    
    if (flag_f)
        kk=0;
        for k=1:length(F_orig)
            ff=F_orig{k};
            if isempty(strfind(ff, 'perm'))&&isempty(strfind(ff, 'probe'))&&isempty(strfind(ff, 'pair'))
                kk=kk+1;
                dash=strfind(ff, '-');
                ff=ff(dash(end)+1:end);
                feat_idx(kk)=str2num(ff);
                feat_loc(kk)=k;
            end
        end
    end
    
    figure('name', 'MNIST browser');
    num=0;
    while 1
        idx = input('Digit number (or n for next, p for previous, e exit)? ');
        if isempty(idx), idx=n; end
        switch idx
            case n
                num=min(num+1,length(D_orig.Y));
            case p
                num=max(1,num-1);
            case e
                break
            otherwise
                num=idx;
        end
               
        if (flag_f)
            M1=zeros(1,28*28);
            M1(feat_idx)=D_orig.X(num,feat_loc);
            if (flag_miss)
                M2=zeros(1,28*28);
                M2(feat_idx)=D_miss.X(num,feat_loc);
                MM2=isnan(M2);
            end
            if (flag_imp)
                M3=zeros(1,28*28);
                M3(feat_idx)=D_imp.X(num,feat_loc);
            end
        else
            M1=D_orig.X(num,:);
            if (flag_miss)
                M2=D_miss.X(num,:);
                MM2=isnan(M2);
            end
            if (flag_imp)
                M3=D_imp.X(num,:);
            end
        end
        possubplot=1;
        title(['Index: ' num2str(num) ' --  Class: ' num2str(D_orig.Y(num,1))], 'FontSize', 16);
        subplot(1,nsubplot,possubplot);
        show_digit(M1);
        title('Original');
        possubplot=possubplot+1;
        if (flag_miss)
            subplot(1,nsubplot,possubplot);
            show_digit(M2, MM2, 'r');
            title('Missing');
            possubplot=possubplot+1;
        end
        if (flag_imp)
            subplot(1,nsubplot,possubplot);
            show_digit(M3);
            title('Imputation');
            possubplot=possubplot+1;
        end
    end
end