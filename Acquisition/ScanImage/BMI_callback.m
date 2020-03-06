function BMI_callback(src,evt,varargin)
% myFrameAcquiredCallback_BMI.m
tic
% workhorse function for SI based BMI

% Initialize..
hSI = src.hSI; % get the handle to the ScanImage model

% Load in data from Workspace:
BMI_Data = evalin('base','BMI_Data');
Tstart = BMI_Data.Tstart;
frame_idx = BMI_Data.frame_idx;
dsample_fact = 1;


% scanimage stores image data in a data structure called 'stripeData'
lastStripe = hSI.hDisplay.stripeDataBuffer{hSI.hDisplay.stripeDataBufferPointer}; % get the pointer to the last acquired stripeData
channels = lastStripe.roiData{1}.channels; % get the channel numbers stored in stripeData

for idx = 1:length(channels)
    frame{idx} = lastStripe.roiData{1}.imageData{idx}{1}; % extract all channels
end

% Meat of BMI function:
if BMI_Data.BMIready ==1; % if BMI is ready to go:
    %ROI = BMI_Data.ROI % ROI syntax
    %BMI_Data.BMIready
    arduino =  evalin('base','arduino');

    Im = frame{1}; % Get data from the 'Green' Channel...

    % standard BMI, Index into E1-E4;

    Im = imresize(single(round(Im)),1/dsample_fact); % convert from 16bit
    BMI_Data.ROI_val(1,frame_idx) = mean(mean(Im(round(BMI_Data.ROI.coordinates{1}(:,2)/dsample_fact),round(BMI_Data.ROI.coordinates{1}(:,1)/dsample_fact)),1));
    BMI_Data.ROI_val(2,frame_idx) = mean(mean(Im(round(BMI_Data.ROI.coordinates{2}(:,2)/dsample_fact),round(BMI_Data.ROI.coordinates{2}(:,1)/dsample_fact)),1));
    BMI_Data.ROI_val(3,frame_idx) = mean(mean(Im(round(BMI_Data.ROI.coordinates{3}(:,2)/dsample_fact),round(BMI_Data.ROI.coordinates{3}(:,1)/dsample_fact)),1));
    BMI_Data.ROI_val(4,frame_idx) = mean(mean(Im(round(BMI_Data.ROI.coordinates{4}(:,2)/dsample_fact),round(BMI_Data.ROI.coordinates{4}(:,1)/dsample_fact)),1));
    %BMI_Data.ROI_val(1,frame_idx)
    if frame_idx >10;

        for i = 1:4
            baseline(i,:) = prctile(BMI_Data.ROI_val(i,2:end),5); % if addaptive, change 99 to 'end'
        end

        for i = 1:4; % TO DO: why does the index start ar 2??
            ROI_dff(i,:) = (BMI_Data.ROI_val(i,1:end)-baseline(i,:))./baseline(i,:)*100;
            % normalize
            ROI_norm(i,:) = (ROI_dff(i,:) - mean(ROI_dff(i,:)))/std(ROI_dff(i,:));
        end

        % Calculate Cursor
        BMI_Data.cursor(:,frame_idx) = ROI_norm(1,frame_idx)+ROI_norm(2,frame_idx) - (ROI_norm(3,frame_idx)+ROI_norm(4,frame_idx));

        % Smooth cursor
        if frame_idx>3;
            rn = 3; % running average...
            CURSOR = (mean(BMI_Data.cursor(:,frame_idx-rn:frame_idx)));
        else % dont smooth cursor if not enough frames...
            CURSOR = ((BMI_Data.cursor(:,frame_idx)));
        end

        BMI_Data.cursor_smoothed(:,frame_idx) = CURSOR; %  log the current cursor
        BMI_Data.ROI_norm(:,frame_idx) = ROI_norm; % log the normalized data
        BMI_Data.CURSOR = CURSOR; % log the current cursor
        CURSOR

        % Send serial command

% ============================= [ Water Delivery]  ============================= %

        BMI_Data.hit(frame_idx) = 0; % default is 0
        if BMI_Data.condition == 1; % reward eligibility
            if CURSOR> BMI_Data.Hit_Thresh;
                fdbk = 1;
                while fdbk
                    disp('HIT!');
                    BMI_Data.condition = 2;
                    BMI_Data.hit(frame_idx) = 1; % frame with reward
                    fprintf(arduino,'%c',char(99)); % send answer variable content to arduino
                    fdbk = 0;
                    BMI_Data.num_hits = BMI_Data.num_hits+1;
                end
            end
        elseif BMI_Data.condition == 2
            disp(' Waiting to drop below threshold...')
            BMI_Data.hit(frame_idx) = -1;
            if CURSOR<BMI_Data.Reset_Thresh;
                disp ( 'Resetting Cursor')
                BMI_Data.condition = 1;
                BMI_Data.hit(frame_idx) = 0;
            end
        end

    else
    end

else
end

BMI_Data.time_idx(frame_idx) = toc(Tstart);
BMI_Data.MeanFrame(frame_idx) = mean(frame{1}(1,:));
BMI_Data.frame_idx = frame_idx+1; % advance the frame index...

%% Output data back to workspace
assignin('base','BMI_Data',BMI_Data);

toc

end
