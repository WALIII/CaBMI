function un_extracted_list = CaBMI_Behavior_Batch
% Batch function for behavioral analysis of BMI. List all days that still
% need to be extracted..

% WAL3
% d10/17/2020

% Get all subfolders:
HomeDir = cd;

%% LEVEL 1: Days
counter = 1;
% Get all folders in directory
files = dir(pwd);
files(ismember( {files.name}, {'.', '..','Processed'})) = [];  %remove . and .. and Processed

% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subFolders = files(dirFlags);
% Print folder names to command window.
for k = 1 : length(subFolders)
    fprintf('Sub folder #%d = %s\n', k, subFolders(k).name);
end


for i = 1:length(subFolders); % go through all days
    % index into folders,
    
    cd([subFolders(i).folder,'/',subFolders(i).name]); % index into day
    
    % check if mat folder exists ( data has been extracted)
    if exist('mat')>1
        disp('.mov files already extracted...');
        % check if all files were extracted:
        a = dir('*.mov');
        n = numel(a);
        b = dir('mat');
        n2 = numel(b)-2;
        if n == n2 % check if the same number of files are here
            disp('all files extracted');
        else
            disp('extraction error');
            un_extracted_list(counter) = [subFolders(i).folder,'/',subFolders(i).name];
            counter  = counter+1;
        end
        clear a n b n2
        
    else
        un_extracted_list(counter) = [subFolders(i).folder,'/',subFolders(i).name];
        counter  = counter+1;
    end
    
    %% Level 2: index into mat, and go through sub folders
    cd('mat');
    files2 = dir(pwd);
    files2(ismember( {files2.name}, {'.', '..','Processed'})) = [];  %remove . and .. and Processed
    
    % Get a logical vector that tells which is a directory.
    dirFlags2 = [files2.isdir];
    % Extract only those that are directories.
    subFolders2 = files2(dirFlags2);
    % Print folder names to command window.
    for k = 1 : length(subFolders2)
        fprintf('Sub folder #%d = %s\n', k, subFolders2(k).name);
    end
    
    
    for i = 1:length(subFolders2); % go through all animals for this day
        % index into folders,
        cd([subFolders(i).folder,'/',subFolders(i).name]); % index into day
        
        % check if data has been processed folder exists ( data has been extracted)
        if exist('processed')>1
            disp('.mov files already extracted...');
        else
            CaBMI_Behavior_ProcessVideos
        end
        
        % check about DLC folder
        if exist('processed/DLC')>1
            disp('DLC folder exists...');
        else
            CaBMI_DLC_Tiff2AVI;
        end
        
        cd('../'); % go back one folder
    end
    
    cd(HomeDir)
end

un_extracted_list