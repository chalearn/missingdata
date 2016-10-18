function [ h_miss_evol ] = get_miss_evolution_plot( dataset_folder, dataset_type,  )
%GET_MISS_EVOLUTION_PLOT Summary of this function goes here
%   Detailed explanation goes here

    files = dir(dataset_folder)
    for i=1:size(files,1)
        if (~files(i).isdir)
            if (strfind(files(i).name, dataset_type))
                load(files(i).name);
                # get number of missing data
            end
        end
    end
end

