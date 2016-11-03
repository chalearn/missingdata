function [ pos_top ] = gettop_image( v_type_feat, v_id_pixel, percent )
%GET_TOP_IMAGE Summary of this function goes here
%   Detailed explanation goes here
    x_image_size = 28;
    y_image_size = 28;

    v_aux=zeros(1,x_image_size*y_image_size);
    v_aux(v_id_pixel(v_type_feat==0)) = v_id_pixel(v_type_feat==0);
    m_aux = reshape(v_aux,x_image_size,y_image_size);
    pixel_miss = ceil(x_image_size*(percent/100));
    %[xc yc] = find(m_aux==v_id_pixel(pos_center_pixel));

    iniy = 1;
    finy = pixel_miss;
    id_top = m_aux(:,iniy:finy);
    id_top = id_top(id_top>0)';
    pos_top = find(ismember(v_id_pixel,id_top));
end

