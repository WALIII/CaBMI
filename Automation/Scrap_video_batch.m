
% run through all animals and make vids

files = dir(pwd);
DIR = pwd

files(ismember( {files.name}, {'.', '..','DATA'})) = [];  %remove . and .. and Processed


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
        cd(subFolders(i).name);

    close all 
    clear A B C roi_hits ds_hits VId_hits I RGB1 RGB2
    
    load('csv_data.mat'); load('ave_roi.mat');  load('Y.mat');
%   1. Extract 'Hits' from .CSV file
[ds_hits, roi_hits] = CaBMI_csvAlign(csv_data(:,2),csv_data(:,3),roi_ave); %   1. Load in Y ( temporally downsampled movie) from ds_data
%% BASIC ANALYSIS
load('Direct_roi.mat')
% Get video matrix around the hits
% Get ROI traces in a matrix, bounded by the hits
%[ROIhits,ROIhits_d,ROIhits_s, ROIhits_z]= CaBMI_getROI(roi_ave,roi_hits);
stp = round(size(roi_hits,1)/3);
[VidHits, I]= CaBMI_getvid(Y,ds_hits);
A = mean(VidHits(:,:,:,1:10),4);
B = mean(VidHits(:,:,:,stp:stp*2),4);
C = mean(VidHits(:,:,:,stp*2:(stp*3 -1)),4);
[RGB1 RGB2] = CaBMI_XMASS(A,B,C,'Direct',ROIS);

    cd(DIR);
end

    