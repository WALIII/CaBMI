function DATA = CaBMI_DataCue;
% CaBMI_DataCue.m

% Load in all relevant data, and aggregate summary data for figure
% generation

% d07/22/2020
% WAL3

% NOTE->  Run in: /Volumes/DATA_01/LIBERTI_DATA/Processed/StandardBMI_01/For_Lily/Model Data
%% Load all Data:
% get all mat files
mov_listing=dir(fullfile(pwd,'*.mat'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;
counter = 1;

addpath('/Volumes/DATA_01/LIBERTI_DATA/Processed/StandardBMI_01/For_Lily/overlapIDX')
addpath('/Volumes/DATA_01/LIBERTI_DATA/Processed/StandardBMI_01/For_Lily/Model Data/DayPredUnpacked')

for i = 1:size(mov_listing,2)

% get animal name/date from filename
[out_date, str1] = CaBMI_MatchDate(mov_listing{i});
[out_fname, str2] = CaBMI_MatchFname(mov_listing{i});

% Load ROI data:
ROI_DATA = load(filenames{i},'ROIa','ROIb','ROIhits');%,'ROIhits_s','ROIhits_z');
disp('loaded ROI data');

% Load Model Data:
FILE = ['/Volumes/DATA_01/LIBERTI_DATA/Processed/StandardBMI_01/For_Lily/Model Data/DayPredUnpacked/IDNpredDN_delay_',str1,'_',str2,'.hf5'];
Traces = h5read(FILE ,'/perf'); % changed from /perf
Weights = h5read(FILE ,'/wts'); % changed from /wts
disp('loaded Model data');

% Load Excluded Neuron Index:
npy2read = ['/Volumes/DATA_01/LIBERTI_DATA/Processed/StandardBMI_01/For_Lily/overlapIDX/',str1,'_',str2,'_overlap_IDX.npy'];
OverlapData = readNPY(npy2read); % npy data
OverlapData = OverlapData+1; % to correct the index..
disp('loaded exclusion data');


%% Run Data analysis 
try
    % Get data for batch plotting
%     
    [out] = CaBMI_SequenceEmerge(ROIhits);
%     
%     % PCA plotting
%     [PCA_data]= CaBMI_PCA(roi_ave1,roi_hits);
%     [outputB NumCellsTS] = CaBMI_FineSequenceEmerge(ROIhits);
%     
% 
     
   close all 
counter = counter+1;
catch
%     disp('SKIPPING TRIAL WARNING');
end

     DATA.DAT{out_date}{out_fname} = ROI_DATA;
   clear ROIhits roi_ave1 roi_hits 
end

% 
% counter = 1;
% for i = 1: 5; % animal
%     for ii = 1:7; % date
%         try
%             dat1(ii,i) = DATA.S{ii}{i}.mid_late- DATA.S{ii}{i}.early_mid;
%             earl(counter) =  DATA.S{ii}{i}.early_early;
%             lat(counter) = DATA.S{ii}{i}.late_late;
%             counter = counter+1;
%         catch
%             dat1(ii,i) = 0.2;
%         end
%     end
% end

