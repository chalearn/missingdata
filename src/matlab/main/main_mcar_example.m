% Set dataset name.
dataset_name = 'Gisette';
% Set missingness mechanisms and methods.
missing_type = {'mcar'};
missing_meth = {'flipcoin'};
% Set missingness percentages.
missing_perc = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90];
% Set solution mechanisms and methods.
solution_type = {'imp'};
solution_meth = {'med','svd'};
% Set feature selection method to use in the analysis process.
fs_method = 's2n';

% Generate the missing dataset
error_md = create_missing_dataset( dataset_name, missing_type, ...
                                   missing_meth, missing_perc, false );
if (~error_md)
    % Apply a solution over missing datasets.
    error_rd = restore_dataset( dataset_name, solution_type, solution_meth );
    if (~error_rd)
        % Obtain plots and results obtained from the analysis.
        error_ad = analyze_dataset( dataset_name, fs_method );
        if (~error_ad)
            msgbox('Operation Completed','Success');
        else
            msgbox('Error in analysis process', 'Error','error');
        end
    else
        msgbox('Error creating imputed dataset', 'Error','error');
    end
else
    msgbox('Error creating missingness dataset', 'Error','error');
end