function caBMI_Grab_data()
% grab pixel values and do perform basic operations on them


pl = actxserver('PrairieLink.Application');
pl.connect();



% Collect Baseline Data:

for i = 1:100;
Im1(:,:,i) = pl.GetImage(1);
end


figure();
imagesc(std(Im1,[],3)); colormap(bone);
colorbar


% the four cells
ROIs = caBMI_SelectROIs(image,4)


% to do: function that computes running baseline and
[baseline] caBMI_GetBase(rois)


kk = pl.ReadRawDataStream(1);

% for i = 1:100000
% tic;

% H(i) = toc;
% end




% Read the raw data stream
% ReadRawDataStream()
