function DATA = CaBMI_DataCue;

% Data to load:

% get all mat files
mov_listing=dir(fullfile(pwd,'*.mat'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;
counter = 1;
for i = 1:size(mov_listing,2)
    
    % LOADING  ROI_hits
    
    
ROI_DATA = load(filenames{i},'ROIa','ROIb','ROIhits_s','ROIhits_z');


try
    % Get data for batch plotting
%     
%     [out] = CaBMI_SequenceEmerge(ROIhits);
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

out_date = CaBMI_MatchDate(mov_listing{i});
out_fname = CaBMI_MatchFname(mov_listing{i});
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

