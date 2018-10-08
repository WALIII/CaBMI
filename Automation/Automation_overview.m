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
if exist('Processed','file') >=0;;
 mkdir('Processed');
end
%

csv_ext = 1; % extract .csv file? 1 = yes.
mov_ext = 1; % extract downsampled video? 1 = yes


% Run through everything

% Get a list of all files and folders in this folder.

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



% Run through all folder...
for i = 1:length(subFolders);
disp(['entering folder', char(subFolders(i).name)])
cd(subFolders(i).name)


%% Load in the DIR DATA
Dir_data=dir(fullfile(pwd,'*.mat'));
Dir_data={Dir_data(:).name};
D = load(Dir_data{1});
clear Dir_data;


%% Find, and enter, main folder:
Sfiles = dir(pwd);
Sfiles(ismember( {Sfiles.name}, {'.', '..'})) = [];  %remove . and ..
% Get a logical vector that tells which is a directory.
SdirFlags = [Sfiles.isdir];
% Extract only those that are directories.
SsubFolders = Sfiles(SdirFlags);
% Print folder names to command window.

counter = 1;
counter2 = 1;
for k1 = 1:length(SsubFolders)
    A = strfind(SsubFolders(k1).name, 'main');
    B = strfind(SsubFolders(k1).name, 'map');
    if ~isempty(A)
        S2S(counter) = SsubFolders(k1);
        counter = counter+1;
    end
    if ~isempty(B)
        S2Sm(counter2) = SsubFolders(k1);
        counter2 = counter2+1;
    end
end

% ** TO DO: Sometimes there are two 'main' folders... Check to see if this is the case.

 for ii = 1:length(S2S)
cd([S2S(ii).folder,'\',S2S(ii).name])
disp(['Entering  ',char(S2S(ii).name)]);


% ** TO DO: Check to see if 'mptifs'. if not, convert the tifs
if  exist('Processed','file') ==0; % if no tiff extraction...

CaBMI_mptif; % add a delete term to the raw tifs....
disp('extracting tifs...')

disp('removing .tifs')
delete('*.tif')
% Delete Tifs...

end

mkdir([START_DIR_ROOT,'\','Processed','\',subFolders(i).name]);
% Extracting CSV
if csv_ext ==1;
disp('Saving CSV extraction...');
try
[csv_data] = CaBMI_csvExtract;
save([START_DIR_ROOT,'\','Processed','\',subFolders(i).name,'\','csv_data.mat'],'csv_data','-v7.3');
catch
    disp('NO CSV file, skipping...')
end
end




  if exist('Processed/roi','file') >= 1 %
        disp( ' Folder already extracted!');

  else
        disp(' mptiffs extracted, getting ROIs...')

        try
            cd('Processed')
            % if so, run them

            disp('processing ( ROI extraction)...')
            pause(0.01);
             [ROI,roi_ave] = CaBMI_Process('type',2);
           cd('Mtiff_folder2')
            % extract
            [roi_ave_directed] = CaBMI_plot_roi(D.ROI,'save_dir','Direct_neuron_roi','filename','Direct_roi');% var ROI should be the last processed...
            roi_ave.directed = roi_ave_directed;
               save('Direct_neuron_roi\Direct_roi.mat','D','-append');
            clear roi_ave_directed;
           
        catch
              disp(' Folder does not exist');
        end
  end
% Extract video...
if mov_ext ==1;
    disp('Loading downsampled video...')
load([[S2S(ii).folder,'\',S2S(ii).name],'\Processed\ds_data'],'Y')
save([START_DIR_ROOT,'\','Processed','\',subFolders(i).name,'\','Y.mat'],'Y','-v7.3');
end
% copy data over
disp('copying data...');
copyfile([S2S(ii).folder,'\',S2S(ii).name,'\','Processed\','roi\','ave_roi.mat'],[START_DIR_ROOT,'\','Processed','\',subFolders(i).name]);
copyfile([S2S(ii).folder,'\',S2S(ii).name,'\','Processed\Mtiff_folder2\','Direct_neuron_roi\','Direct_roi.mat'],[START_DIR_ROOT,'\','Processed','\',subFolders(i).name]);


 end

%% Go back, and extract ROIs on the 'MAP' files.
disp('returning to extract the MAP data...')
for iii = 1:length(S2Sm)
cd([S2Sm(iii).folder,'\',S2Sm(iii).name])
disp(['Entering  ',char(S2Sm(iii).name)]);

% ** Check to see if 'mptifs'. if not, convert the tifs
if  exist('Processed','file') ==0; % if no tiff extraction...

CaBMI_mptif; % add a delete term to the raw tifs....
disp('extracting tifs...')

disp('removing .tifs')
delete('*.tif')
% TO DO: Delete Tifs...

end
% Extract ROIs based on the main data
if exist('Processed\Mtiff_folder2\roi','file') >= 1 %
      disp( ' Folder already extracted!');

else
      disp(' mptiffs extracted, getting ROIs...')

      try
          cd('Processed\Mtiff_folder2')
          % if so, run them
          
          disp('Loading ROI... processing ROI extraction...')
          pause(0.01);
          % get relevant ROI data:
          load([START_DIR_ROOT,'\','Processed','\',subFolders(i).name,'\ave_roi.mat'],'ROI')


          [roi_ave_m] = CaBMI_plot_roi(ROI,'filename','Indirect_roi'); % var ROI should be the last processed...
          [roi_ave_directed] = CaBMI_plot_roi(D.ROI,'save_dir','Direct_neuron_roi','filename','Direct_roi'); % var ROI should be the last processed...
          roi_ave_m.directed = roi_ave_directed;
          save('Direct_neuron_roi\Direct_roi.mat','D','-append'); % append TData and ROI data
          clear roi_ave_directed;
      catch
            disp(' Folder does not exist');
      end
end

% copy data over
disp('copying data...');
mkdir([START_DIR_ROOT,'\','Processed','\',subFolders(i).name]);
copyfile([S2Sm(iii).folder,'\',S2Sm(iii).name,'\','Processed\Mtiff_folder2\','roi\','Indirect_roi.mat'],[START_DIR_ROOT,'\','Processed','\',subFolders(i).name]);
copyfile([S2Sm(iii).folder,'\',S2Sm(iii).name,'\','Processed\Mtiff_folder2\','Direct_neuron_roi\','Direct_roi.mat'],[START_DIR_ROOT,'\','Processed','\',subFolders(i).name]);





% TO DO: Send warnings via text
end






clear Sfiles SdirFlags S2S counter

cd(START_DIR_ROOT);
disp('-------------------------------------------');
disp('-------------------------------------------');

end

% ** TO DO: make .txt file, and email the results to myself...

% ** TO DO: cut processed data into a new folder, or save it to the RAID under,
%     the date of the data
