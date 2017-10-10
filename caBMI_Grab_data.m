function caBMI_Grab_data()
% grab pixel values and do perform basic operations on them


% Connect to the PrairieLink
pl = actxserver('PrairieLink.Application');
pl.Connect();

% conncet to NiDaq
s = daq.createSession('ni');
addDigitalChannel(s,'Dev5','port0/line1','OutputOnly')



%%%============[ Collect Baseline Data  ]================%%%

[Im1] = pull_pixel(pl,s,max_frame)

%%--- Get ROIs-----%

% Save reference image
Ref_Im = uint16(mean(Im1,3));
imwrite(uint16(mean(Im1,3)),'Ref_Im.tif');
[ROI] = caBMI_annotate_image('Ref_Im.tif');

% make a figure qith the ROIs
caBMI_refPlot(ROI,Im1)


% Run experiment
[data] = caBMI_feedback(pl,s,ROI,max_frame)



% figure();
% imagesc(std(Im1,[],3)); colormap(bone);
% colorbar
%
%
%
%
% % to do: function that computes running baseline and
% [baseline] caBMI_GetBase(rois)





%% This will be for the actual BMI
% kk = pl.ReadRawDataStream(1);

% for i = 1:100000
% tic;

% H(i) = toc;
% end




% Read the raw data stream
% ReadRawDataStream()
