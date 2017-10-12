function   [out_state, data] = WAL3_cursor(Im1,Im,ROI,frame_idx,vargin)
% WAL3_cursor.m

% WAL3's cursor for the BMI experiments

% d10.10.2017
% WAL3

% Variables
thresh = 10;
cells = 4; % number of cells for BMI ( hard-wired for 4 currently)


if nargin < 5
v = 1;
end

% switch between BMI types
switch v
  case 1
% standard BMI
dsample_fact = 1;
Im = imresize(single(round(Im)),1/dsample_fact); % convert from 16bit
Im_1= Im1(:,:,frame_idx);
%baseline(i) = mean(mean(squeeze(mean(Im1(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2),:),1)),1));
ROI_val(1) = mean(mean(Im(round(ROI.coordinates{1}(:,1)/dsample_fact),round(ROI.coordinates{1}(:,2)/dsample_fact)),1));
ROI_val(2) = mean(mean(Im(round(ROI.coordinates{2}(:,1)/dsample_fact),round(ROI.coordinates{2}(:,2)/dsample_fact)),1));
ROI_val(3) = mean(mean(Im_1(round(ROI.coordinates{3}(:,1)/dsample_fact),round(ROI.coordinates{3}(:,2)/dsample_fact)),1));
ROI_val(4) = mean(mean(Im_1(round(ROI.coordinates{4}(:,1)/dsample_fact),round(ROI.coordinates{4}(:,2)/dsample_fact)),1));


%create the cursor as the difference btw the 2 groups of ROIs
data.cursor = (ROI_val(1)+ROI_val(2)) - (ROI_val(3)+ROI_val(4));
data.ROI_val = ROI_val;

% Output the state
if data.cursor>thresh
  out_state = 1;
else
  out_state = 0;
end


case 2 % this is the test case ~does the current frame brighter than the last
    if((max(max(Im,[],1),[],1)-max(max(Im1(:,:,frame_idx),[],1),[],1))>1000);
        out_state = 1;
        cursor = 0;
    else

out_state = 0;
data.cursor = 0;
end
end
