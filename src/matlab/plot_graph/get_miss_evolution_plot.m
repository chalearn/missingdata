function [ h_miss_evol ] = get_miss_evolution_plot(dataset_folder)
%GET_MISS_EVOLUTION_PLOT Summary of this function goes here
%   Detailed explanation goes here
    s_list = [];
    files = dir(dataset_folder)
    for i=1:size(files,1)
        if (~files(i).isdir)
            if (strfind(files(i).name, dataset_type))
                load(files(i).name);
                s_aux = struct ('aupr', aupr, 'aulc', aulc, 'miss_p', miss_perc);
                s_list = [s_list s_aux];
            end
        end
    end
    fn = fieldnames(s_list);
    cell_aux = struct2cell(s_list);
    sz = size(cell_aux);
    mat_aux = sortrows(reshape(cell_aux,sz(1),[])',3)';
    cell_aux = reshape(mat_aux, sz);
    s_list = cell2struct(cell_aux, fn, 1);
    h_miss_evol = plot_ev_curve('Evolution missing curve', 0, s_list.aupr, s_list.aulc, s_list.miss_p);    
end

