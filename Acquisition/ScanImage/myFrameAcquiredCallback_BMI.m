function myFrameAcquiredCallback_BMI(src,evt,varargin)
% myFrameAcquiredCallback_BMI.m

% workhorse function for SI based BMI


tic
hSI = src.hSI; % get the handle to the ScanImage model

% MODES
% LATENCY_CALIBRATION = 0;

% Load in data from Workspace:
Tstart = evalin('base','Tstart');
BMI_Data = evalin('base','BMI_Data');
arduino = evalin('base','arduino');
ROI = BMI_Data.ROI; % ROI syntax
data = BMI_Data.data;
frame_idx = BMI_Data.frame_idx
dsample_fact = 1;


% scanimage stores image data in a data structure called 'stripeData'
% this example illustrates how to extract an acquired frame from this structure
lastStripe = hSI.hDisplay.stripeDataBuffer{hSI.hDisplay.stripeDataBufferPointer}; % get the pointer to the last acquired stripeData
channels = lastStripe.roiData{1}.channels; % get the channel numbers stored in stripeData

for idx = 1:length(channels)
    frame{idx} = lastStripe.roiData{1}.imageData{idx}{1}; % extract all channels
end

if BMI_Data.BMIready ==1; % if BMI is ready to go:

Im = frame{2}; % Get data from the 'Green' Channel...

% standard BMI, Index into E1-E4;
Im = imresize(single(round(Im)),1/dsample_fact); % convert from 16bit
BMI_Data.ROI_val(1,frame_idx) = mean(mean(Im(round(ROI.coordinates{1}(:,2)/dsample_fact),round(ROI.coordinates{1}(:,1)/dsample_fact)),1));
BMI_Data.ROI_val(2,frame_idx) = mean(mean(Im(round(ROI.coordinates{2}(:,2)/dsample_fact),round(ROI.coordinates{2}(:,1)/dsample_fact)),1));
BMI_Data.ROI_val(3,frame_idx) = mean(mean(Im(round(ROI.coordinates{3}(:,2)/dsample_fact),round(ROI.coordinates{3}(:,1)/dsample_fact)),1));
BMI_Data.ROI_val(4,frame_idx) = mean(mean(Im(round(ROI.coordinates{4}(:,2)/dsample_fact),round(ROI.coordinates{4}(:,1)/dsample_fact)),1));

for i = 1:4
    baseline(i,:) = prctile(BMI_Data.ROI_val(i,2:end),5); % if addaptive, change 99 to 'end'
end

for i = 1:4; % TO DO: why does the index start ar 2??
    ROI_dff(i,:) = (BMI_Data.ROI_val(i,2:end)-baseline(i,:))./baseline(i,:)*100;
    % normalize
    ROI_norm(i,:) = (ROI_dff(i,:) - mean(ROI_dff(i,:)))/std(ROI_dff(i,:));
end

% Calculate Cursor
BMI_Data.cursor(:,frame_idx) = ROI_norm(1,frame_idx)+ROI_norm(2,frame_idx) - (ROI_norm(3,frame_idx)+ROI_norm(4,frame_idx));

% Smooth cursor
if frame_idx>3;
rn = 3; % running average...
CURSOR = round(mean(BMI_Data.cursor(:,frame_idx-rn:frame_idx)));
else % dont smooth cursor if not enough frames...
  CURSOR = round(mean(BMI_Data.cursor(:,frame_idx-rn:frame_idx)));
end

BMI_Data.cursor_smoothed(:,frame_idx); = CURSOR;

BMI_Data.CURSOR = CURSOR;
CURSOR

% Send serial command
%disp(['FRAME ', num2str(counter),' Acquired'])

else
end

BMI_Data.time(frame_idx) = toc(Tstart);
BMI_Data.cursor(frame_idx) = mean(frame{1}(1,:));
BMI_Data.frame_idx = frame_idx+1; % advance the frame index...

%% Output data back to workspace
assignin('base','BMI_Data',BMI_Data);
toc


end
