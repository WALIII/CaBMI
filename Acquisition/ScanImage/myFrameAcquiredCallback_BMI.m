function myFrameAcquiredCallback_BMI(src,evt,varargin)
tic
hSI = src.hSI; % get the handle to the ScanImage model

% Load in data from Workspace:
counter = evalin('base','counter'); % TO DO add this 'frame number' to BMI_Data
Tstart = evalin('base','Tstart');
BMI_Data = evalin('base','BMI_Data');
arduino = evalin('base','arduino');

% scanimage stores image data in a data structure called 'stripeData'
% this example illustrates how to extract an acquired frame from this structure
lastStripe = hSI.hDisplay.stripeDataBuffer{hSI.hDisplay.stripeDataBufferPointer}; % get the pointer to the last acquired stripeData
channels = lastStripe.roiData{1}.channels; % get the channel numbers stored in stripeData

for idx = 1:length(channels)
    frame{idx} = lastStripe.roiData{1}.imageData{idx}{1}; % extract all channels
end

if BMI_Data.BMIready ==1; % if BMI is ready to go:
% Index into E1-E4;


% Add to values to raw data

% Zscore data

% Add values to normalized data

% Calculate Cursor


% Send serial command
%disp(['FRAME ', num2str(counter),' Acquired'])

else
  
end

BMI_Data.time(counter) = toc(Tstart);
BMI_Data.cursor(counter) = mean(frame{1}(1,:));
counter = counter+1;


%% Output data back to workspace
assignin('base','BMI_Data',BMI_Data);
assignin('base','counter',counter);
toc


end
