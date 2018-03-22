function Automation_overview

% Automation Overview

% 1. Sort data onto processing computer
% 2. Make a scheduler ( assign folders to process)
% 3. CaBMI pipeline ( with text/email warnings)


% See what we have in each folder
%    Date->animals->main
%                  map


% Initialize:
START_DIR_ROOT = cd; % or a scheduled folder...

% Run through everything

% Get a list of all files and folders in this folder.

files = dir(pwd);
files(ismember( {files.name}, {'.', '..'})) = [];  %remove . and ..

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir]
% Extract only those that are directories.
subFolders = files(dirFlags)
% Print folder names to command window.
for k = 1 : length(subFolders)
	fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
end



% Run through all folder...
for i = 1:length(subFolders)
disp('entering folder')
cd(subFolders(k).name)

%% Find, and enter, main folder:

Sfiles = dir(pwd);
Sfiles(ismember( {Sfiles.name}, {'.', '..'})) = [];  %remove . and ..
% Get a logical vector that tells which is a directory.
SdirFlags = [Sfiles.isdir]
% Extract only those that are directories.
SsubFolders = Sfiles(SdirFlags)
% Print folder names to command window.

counter = 1;
for k1 = 1:length(SsubFolders)
    A = strfind(SsubFolders(k1).name, 'main');
    if ~isempty(A)
        S2S(counter) = SsubFolders(k1);
        counter = counter+1;
    end
end

% ** TO DO: Sometimes there are two 'main' folders... Check to see if this is the case.


cd(S2S(1).name)
fprintf('Sub folder is',S2S(1).name);

clear Sfiles SdirFlags S2S counter


% ** TO DO: Check to see if 'mptifs'. if not, convert the tifs
if  exist('processed','file') ==0;
CaBMI_mptif; % add a delete term to the raw tifs....
end

cd('processed')


% if so, run them
%[ROI,roi_ave] = CaBMI_Process('type',2);
disp('processing...')

% TO DO: Go back, and extract ROIs on the 'MAP' files.
% TO DO: Send warnings via text


cd(START_DIR_ROOT);
end

% ** TO DO: make .txt file, and email the results to myself...

% ** TO DO: cut processed data into a new folder, or save it to the RAID under,
%     the date of the data
