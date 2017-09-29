function [ pos_neigh ] = getpos_neighbord( pos_center_pixel, v_type_feat, v_id_pixel, ratio )
%GET_NEIGHBORD Summary of this function goes here
%   Detailed explanation goes here
    x_image_size = 28;
    y_image_size = 28;

    v_aux=zeros(1,x_image_size*y_image_size);
    v_aux(v_id_pixel(v_type_feat==0)) = v_id_pixel(v_type_feat==0);
    m_aux = reshape(v_aux,x_image_size,y_image_size);
    [xc yc] = find(m_aux==v_id_pixel(pos_center_pixel));
    inix = xc-ratio;
    finx = xc+ratio;
    if (xc <= ratio)
        inix = 1;
    else if (xc > x_image_size-ratio)
        finx = x_image_size;
        end
    end
    iniy = yc-ratio;
    finy = yc+ratio;
    if (yc <= ratio)
        iniy = 1;
    else if (yc > y_image_size-ratio)
        finy = y_image_size;
        end
    end
    id_neigh = m_aux(inix:finx,iniy:finy);
    id_neigh = id_neigh(id_neigh>0)';
    pos_neigh = find(ismember(v_id_pixel,id_neigh));
end

