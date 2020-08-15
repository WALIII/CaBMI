function CaBMI_SIProcessing_Dispatch
% For Standard BMI II, which uses a different format, needs a different
% extraction pipeline...

% WAL3
% d08152020


HDir = cd;

files = dir(pwd);
files(ismember( {files.name}, {'.', '..','Processed'})) = [];  %remove . and .. and Processed

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
daySubFolders = files(dirFlags);
% Print folder names to command window.

day = 1;
for k = 1 : length(daySubFolders) % for all days
    
    cd(daySubFolders(k).name);
    files2 = dir(pwd);
files2(ismember( {files2.name}, {'.', '..','Processed'})) = [];  %remove . and .. and Processed

% Get a logical vector that tells which is a directory.
dirFlags2 = [files2.isdir];
% Extract only those that are directories.
subFolders = files2(dirFlags2);
% Print folder names to command window.

for i =  1:length(subFolders)
    cd(subFolders(i).name);
    fprintf('Sub folder #%d = %s\n', i, subFolders(i).name);
    
    CaBMI_Process('type',2);
    
    % collect and save data
end
cd(HDir);
end
