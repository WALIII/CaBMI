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
BMI_Data.time_idx(frame_idx) = toc(Tstart);
BMI_Data.time_idx2(frame_idx)= hSI.hDisplay.lastFrameTimestamp;

dsample_fact = 1;


% scanimage stores image data in a data structure called 'stripeData'
lastStripe = hSI.hDisplay.stripeDataBuffer{hSI.hDisplay.stripeDataBufferPointer}; % get the pointer to the last acquired stripeData
channels = lastStripe.roiData{1}.channels; % get the channel numbers stored in stripeData

for idx = 1:length(channels)
    frame{idx} = lastStripe.roiData{1}.imageData{idx}{1}; % extract all channels
end

% Meat of BMI function:
if BMI_Data.BMIready ==1; % if BMI is ready to go:
    
    arduino =  evalin('base','arduino');
    
    Im = single(frame{1}); % Get data from the 'Green' Channel...
    % standard BMI, Index into E1-E4;
    %Im = imresize(single(round(Im)),1/dsample_fact); % convert from 16bit
    BMI_Data.ROI_val(1,frame_idx) = mean(mean(Im(round(BMI_Data.ROI.coordinates{1}(:,2)/dsample_fact),round(BMI_Data.ROI.coordinates{1}(:,1)/dsample_fact)),1));
    BMI_Data.ROI_val(2,frame_idx) = mean(mean(Im(round(BMI_Data.ROI.coordinates{2}(:,2)/dsample_fact),round(BMI_Data.ROI.coordinates{2}(:,1)/dsample_fact)),1));
    BMI_Data.ROI_val(3,frame_idx) = mean(mean(Im(round(BMI_Data.ROI.coordinates{3}(:,2)/dsample_fact),round(BMI_Data.ROI.coordinates{3}(:,1)/dsample_fact)),1));
    BMI_Data.ROI_val(4,frame_idx) = mean(mean(Im(round(BMI_Data.ROI.coordinates{4}(:,2)/dsample_fact),round(BMI_Data.ROI.coordinates{4}(:,1)/dsample_fact)),1));
    %BMI_Data.ROI_val(1,frame_idx)
    if frame_idx >10;
        
        
        for i = 1:4; % TO DO: why does the index start ar 2??
            baseline(i,:) = prctile(BMI_Data.ROI_val(i,2:end),5); % if addaptive, change 99 to 'end'
            
            ROI_dff(i,:) = (BMI_Data.ROI_val(i,1:end)-baseline(i,:))./baseline(i,:)*100;
            % normalize
            ROI_norm(i,:) = (ROI_dff(i,:) - mean(ROI_dff(i,:)))/std(ROI_dff(i,:));
        end
        
        % Calculate Cursor
        BMI_Data.cursor(:,frame_idx) = ROI_norm(1,frame_idx)+ROI_norm(2,frame_idx) - (ROI_norm(3,frame_idx)+ROI_norm(4,frame_idx));
        
        % Smooth cursor
        if frame_idx>BMI_Data.cursor_smooth;
            rn = BMI_Data.cursor_smooth; % running average...
            CURSOR = (mean(BMI_Data.cursor(:,frame_idx-rn:frame_idx)));
        else % dont smooth cursor if not enough frames...
            CURSOR = ((BMI_Data.cursor(:,frame_idx)));
        end
   
        BMI_Data.cursor_smoothed(:,frame_idx) = CURSOR; %  log the current cursor
        BMI_Data.ROI_norm(:,frame_idx) = ROI_norm(:,frame_idx); % log the normalized data
        BMI_Data.CURSOR = CURSOR; % log the current cursor

        % ============================= [ TONE ]  ============================= %
        % Write cursor state to Speaker
    fdbk = 1;
        while fdbk
            fprintf(arduino,'%c',char((CURSOR+5)*10)); % send answer variable content to arduino
             fdbk = 0;
         end
        
        % ============================= [ Water Delivery]  ============================= %
        
        BMI_Data.hit(frame_idx) = 0; % default is 0
        if BMI_Data.condition == 1; % reward eligibility
            if CURSOR> BMI_Data.Hit_Thresh;
                fdbk = 1;
                while fdbk
                    disp('HIT!');
                    BMI_Data.condition = 2;
                    % TO DO: probablistic catch
                    
                    BMI_Data.hit(frame_idx) = 1; % frame with reward
                    fprintf(arduino,'%c',char(171)); % send answer variable content to arduino
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
        % time all of this...
        if ~mod(frame_idx,10)
        disp(['Cursor =', num2str(CURSOR+5),'   Elapsed frametime = ', num2str(toc)]);
        end  
    else
    end
    
elseif BMI_Data.BMIready == 2; % TO DO: Random reward ( with set probability);

    % random seed
    
    BMI_Data.hit(frame_idx) = 0;
    
end

%BMI_Data.MeanFrame(frame_idx) = mean(frame{1}(1,:)); % removed for
%speed...
BMI_Data.frame_idx = frame_idx+1; % advance the frame index...

%% Output data back to workspace
assignin('base','BMI_Data',BMI_Data);


end