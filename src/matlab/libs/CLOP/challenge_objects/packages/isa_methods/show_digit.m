function im=show_digit(v, miss)
% im=show_digit(v)
% show a digit from a vector format

% Isabelle Guyon -- isabelle @ clopinet.com -- July 2003
warning off
ld=length(v);
nd=sqrt(ld);
im=255-reshape(v,nd,nd)';
num=256;
if (nargin==1)
    map=gray(num);
end
if (nargin>1)
    imiss=reshape(miss,nd,nd)';
    map=gray(num-1);
    map=[1 0.5 0; map];
end

imn = inormalize(im);
%im=6.25*(0.16-reshape(v,nd,nd))';
%imn=im;
if (nargin>1)
    imn(imiss==0)=-1;
end
imn = uint8(imn*(num-1));
colormap(map);
image(imn); 
freezeColors
warning on
