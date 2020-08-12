
function [All_hits] = CaBMI_SI_LoadMetadata

% index into folder

% look for metadata file

% load in name and hits

% save day next...

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
   S = dir(fullfile(pwd,'*.mat'));
    N = {S.name}; 
    N1 = contains(N,'BMI');
    N = {S(N1).name};
    N2 = contains(N,'matdata');
    N3 = N{N2};
    [out_fname, str1] = CaBMI_MatchFname(N3);
    load(N3,'BMI_Data');
    All_hits{out_fname-7}{day}.hits = BMI_Data.num_hits;
    clear BMI_Data N1 N2
    cd('../');
end
cd(HDir);
day = day+1;

end

    
    
    
    




