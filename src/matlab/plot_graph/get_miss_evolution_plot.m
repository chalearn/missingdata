function [ h_miss_evol ] = get_miss_evolution_plot(dataset_folder)
%GET_MISS_EVOLUTION_PLOT Summary of this function goes here
%   Detailed explanation goes here
    line_list = [];
    imput_list = [];
    folders = dir(dataset_folder);
    for i=1:size(folders,1)
        if ( (folders(i).isdir) && ...
             ~(strcmp(folders(i).name,'.') || strcmp(folders(i).name,'..')) )
            imput_method = strsplit(folders(i).name, '_');
            imput_list = [imput_list; imput_method(3)];
            files = dir([dataset_folder filesep folders(i).name]);
            point_list = [];
            for j=1:size(files,1)
                if (~files(j).isdir)
                    miss_p = strsplit(files(j).name, '_');
                    miss_p = str2num(strtok(miss_p{3},'.'));
                    load(files(j).name);
                    point_aux = struct ('aupr_v', aupr_v, 'aulc_v', aulc_v, 'miss_p', miss_p);
                    point_list = [point_list point_aux];
                end
            end
            line_list = [line_list; point_list];
        end
    end
    for i=1:size(line_list,1)
        point_list = line_list(i,:);
        fn = fieldnames(point_list);
        cell_aux = struct2cell(point_list);
        sz = size(cell_aux);
        mat_aux = sortrows(reshape(cell_aux,sz(1),[])',3)';
        cell_aux = reshape(mat_aux, sz);
        point_list = cell2struct(cell_aux, fn, 1);
        line_list(i,:) = point_list;
    end
    line_list = line_list';
    h_miss_evol = plot_ev_curve('Evolution missing curve', 0, ...
                                reshape([line_list.aupr_v],size(line_list))', ...
                                reshape([line_list.aulc_v],size(line_list))', ...
                                imput_list);    
end

