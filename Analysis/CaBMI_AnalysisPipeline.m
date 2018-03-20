% CaBMI_AnalysisPipeline.m

% WAL3
% d3/18/18


%% PREFLIGHT
 %   1. Process ROI data
  [ROI,roi_ave] = CaBMI_Process('type',2);
 %   2. Check Data integrity ( plot ROI masks over reference image, check SNR of extracted data)

 %   1. Load in .matlab data, plot E1 and E2, plus the cursor...
  [B1 C1 D1 ] = CaIm_test(ROI,TData);
 %   1. Extract .CSV file
  [data] = CaBMI_csvExtract
 %   1. Extract 'Hits' from .CSV file
  [ds_hits, roi_hits] = CaBMI_csvAlign(data(:,2),data(:,3));
 %   1. Load in Y ( temporally downsampled movie) from ds_data



%% BASIC ANALYSIS
 % Get video matrix around the hits
  [VidHits, I]= CaBMI_getvid(Y,ds_hits);

 % Get ROI traces in a matrix, bounded by the hits
  [ROIhits, ROIhits_d]= CaBMI_getROI(roi_ave,roi_hits);

 % Make Schnitz plot
  [indX,B,C] = CaBMI_schnitz(data)

 % Make clim matched image overlays
    for i = 1:1000:9000;
      A(:,:,counter) = std(single(Y(:,:,i:+1000)),[],3);
      counter = counter+1;
    end
  X(:,:,:,i) = XMASS_song(A4,A(:,:,i),A4);
