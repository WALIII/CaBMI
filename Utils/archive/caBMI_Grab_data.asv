function caBMI_Grab_data()

% grab pixel values and do perform basic operations on them


pl = actxserver('PrairieLink.Application');

pl.connect();

Im1 = pl.GetImage(1);
% GetImage_2(channel,pixelsPerLine,LinesPerFrame);

figure(); 
imagesc(Im1); colormap(bone);
colorbar


% the four cells
roi_1
roi_2
roi_3
roi_4

% to do: function that computes running baseline and 
[baseline]_ caBMI_GetBase(rois)

group_1 = roi_1+roi_2;

baseline(percentile(group_1,


% for i = 1:100000
% tic;
% kk = pl.ReadRawDataStream(1);
% H(i) = toc;
% end

figure();
histogram(H);


% Read the raw data stream 
% ReadRawDataStream()