function L = read_label(filename)
% L = read_label(filename)

% Isabelle Guyon -- August 2014 -- isabelle@clopinet.com

L={};
fp = fopen(filename, 'r');
if fp>0
    L = textscan(fp, '%s');
    L=L{1};
    fclose(fp);
end
