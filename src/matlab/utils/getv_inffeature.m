function [ v_feats v_prods] = getv_inffeature( F )
%GETV_INFODATA Summary of this function goes here
%   Detailed explanation goes here
% - v_feats is a vector of the same size that F, and each position can have 
% the following values:
%       v_feats = 0   -> feat_pixel
%       v_feats = 1   -> feat_pair
%       v_feats = 2   -> probe_pair
%       v_feats = -1  -> indefined feature (not corresponding with the
%                        aforementioned)
%
% - v_prods is a vector to save the positions of the prods for each "feat-pixel"
% that has prods. The vector has the same size as v_feats, and each position
% is a cell with a vector of the prods positions. Only the positions of the
% vector with "feat-pixel" with prods are different to [].

    sF = length(F);
    v_feats = ones(1,sF) * -1;
    v_aux_pixel = zeros(1,sF);
    aux_prods = cell(1,sF);
    v_prods = cell(1,sF);
    for i=1:sF
        feat = F{i};
        if (~isempty(findstr(feat, 'feat-pixel')))
            v_feats(i) = 0;
            aux = strsplit(feat,'feat-pixel-');
            v_aux_pixel(i) = str2num(aux{2});
        end
        if (~isempty(findstr(feat, 'feat-pair')))
            v_feats(i) = 1;
            aux = strsplit(feat,'-');
            aux_prods{i} = [str2num(aux{3})];
            aux_prods{i} = [aux_prods{i} str2num(aux{4})];
        end
        if (~isempty(findstr(feat, 'probe-pair')))
            v_feats(i) = 2;
        end
    end
    
    for i=1:sF
        if (~isempty(aux_prods{i}))
            aux_p = aux_prods{i};
            pos1 = find(v_aux_pixel == aux_p(1));
            pos2 = find(v_aux_pixel == aux_p(2));
            v_prods{pos1} = [v_prods{pos1} i];
            v_prods{pos2} = [v_prods{pos2} i];
        end
    end

end

