function [DATA] = CaBMI_GetOverlapingCells
% CaBMI_GetOverlapingCells.m

% Upload data in overlapIDX and sort into the right format

% d071620
% WAL3


% Load in .npy data locally
mov_listing=dir(fullfile(pwd,'*.npy'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;


% sort into the right format..
for ii=1:length(mov_listing)
    
    out_date = CaBMI_MatchDate(mov_listing{ii}); % match the date
    out_fname = CaBMI_MatchFname(mov_listing{ii}); % match the animal
    
    data = readNPY(filenames{ii}); % npy data
    
    DATA.IDX{out_date}{out_fname} = data;
    clear data;
    
end