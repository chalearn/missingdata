function [rootdir datadir graphsdir srcdir resultsdir] = load_path()
% load_path Returns the path where the application is installed.

% Find the fragment in the path string
if datenum(version('-date')) >= datenum('May 6 2004')
 d = dbstack('-completenames');
 filedir = fileparts(d(1).file);
 rootdir = filedir(1:(strfind(filedir,'missingdata')+11));
else
 d = dbstack; 
 filedir = fileparts(d(1).name);
 rootdir = filedir(1:(strfind(filedir,'missingdata')+11));
end   

if 0
    % Might be a relative path: convert to absolute
    olddir = pawd; cd(rootdir);
    rootdir = pawd;
    cd(olddir);
end

% Subdirs of the src folder
subdirslist = {
    'data';
    'graphs';
    ['src' filesep 'matlab'];
    'results';
};

%% Load subdirectories.
dirs = subdirs(rootdir, subdirslist);
for i=1:size(dirs,2)
    addpath(genpath(dirs{i}));
end

%% Save the path direction.
if (~isempty(strfind(dirs{1},subdirslist{1})))
    datadir = dirs{1};
end
if (~isempty(strfind(dirs{2},subdirslist{1})))
    graphsdir = dirs{2};
end
if (~isempty(strfind(dirs{3},subdirslist{1})))
    srcdir = dirs{3};
end
if (~isempty(strfind(dirs{4},subdirslist{1})))
    resultsdir = dirs{4};
end


function [dirs rootdir] = subdirs(rootdir, subdir_list)
t=1;
for i=1:length(subdir_list)    
	s = cellstr(subdir_list{i});
    if(isdir(fullfile(rootdir, s{:})))
        dirs{t}=subdir_list{i};
        t=t+1;
    end
end
for i = 1:length(dirs)
	s = cellstr(dirs{i});
	dirs{i} = fullfile(rootdir, s{:});
end

