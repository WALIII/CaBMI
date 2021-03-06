function DATA = CaBMI_batchPlot3;

% plot data that has already been extracted and saved... ( Lily's data);

% optimized for PCA...


% get all mat files
mov_listing=dir(fullfile(pwd,'*.mat'));
mov_listing={mov_listing(:).name};
filenames=mov_listing;
counter = 1;
for i = 1:size(mov_listing,2)
    
    % LOADING  ROI_hits
    
    
    % Loading ROI_data
     load(filenames{i},'roi_ave1');
    
    %load(filenames{i},'roi_ave1','roi_ave2','roi_ave3','roi_ave4');
    load(filenames{i},'roi_hits');
    load(filenames{i},'D_ROIhits','ROIhits_d','ROIhits_s','ROIhits_z');
    
    try
        % Get data for batch plotting
        
        %     [out] = CaBMI_SequenceEmerge(ROIhits);
        
        % PCA plotting
        [out, hits] = CaBMI_PCA_rotational(ROIhits_z,roi_ave1,roi_hits);
        
        [out2] = CaBMI_PCA_consistancy(hits);
        [out3] = CaBMI_Improvement(D_ROIhits,ROIhits_d,ROIhits_z,roi_hits);
        [out4] = CaBMI_incorperateROI(ROIhits_s);
        [~,~,~, percent_modulated,~] = CaBMI_topCells(ROIhits_z,[150:210],0.8);
        [out5]= CaBMI_PCA_zscore(ROIhits_z,95)
        
        close all
        counter = counter+1;
    catch
    end
    
    out_date = CaBMI_MatchDate(mov_listing{i});
    out_fname = CaBMI_MatchFname(mov_listing{i});
    DATA.PCA{out_date}{out_fname} = out;
    DATA.PCA_consist{out_date}{out_fname} = out2;
    DATA.IND{out_date}{out_fname} = out3;
    DATA.P_mod_cor{out_date}{out_fname} = percent_modulated;
    DATA.P_mod{out_date}{out_fname} = out4;
    DATA.PCA_norm{out_date}{out_fname} = out5;
    
    
    clear ROIhits_z roi_ave1 roi_hits
end

