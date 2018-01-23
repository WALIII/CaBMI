function   [CURSOR, data] = WAL3_cursor_song(Im,ROI,data,frame_idx,vargin)
% WAL3_cursor.m

% WAL3's cursor for the BMI experiments

% d12.09.2017
% WAL3

% To do- need to know the history ( 100 samples) to estimate df/f
% Then make a theshold

% make a test case that plays a video, frame by frame. and outputs fictive
% tones



% Variables
thresh = 10; % dff/f thrsh
cells = 4; % number of cells for BMI ( hard-wired for 4 currently)


if nargin < 5
v = 1; % this will choses which BMI to run
end



%%% Basic Test Flight- 
% standard BMI
dsample_fact = 1;
Im = imresize(single(round(Im)),1/dsample_fact); % convert from 16bit
%baseline(i) = mean(mean(squeeze(mean(Im1(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2),:),1)),1));
data.ROI_val(1,frame_idx) = mean(mean(Im(round(ROI.coordinates{1}(:,2)/dsample_fact),round(ROI.coordinates{1}(:,1)/dsample_fact)),1));
data.ROI_val(2,frame_idx) = mean(mean(Im(round(ROI.coordinates{2}(:,2)/dsample_fact),round(ROI.coordinates{2}(:,1)/dsample_fact)),1));
data.ROI_val(3,frame_idx) = mean(mean(Im(round(ROI.coordinates{3}(:,2)/dsample_fact),round(ROI.coordinates{3}(:,1)/dsample_fact)),1));
data.ROI_val(4,frame_idx) = mean(mean(Im(round(ROI.coordinates{4}(:,2)/dsample_fact),round(ROI.coordinates{4}(:,1)/dsample_fact)),1));


% Get Df/f values
if frame_idx>10;
    for i = 1:4
        baseline(i,:) = prctile(data.ROI_val(i,2:end),5); % if addaptive, change 99 to 'end'
    end
        
    for i = 1:4;
        ROI_dff(i,:) = (data.ROI_val(i,2:end)-baseline(i,:))./baseline(i,:)*100;
    end
    

%create the cursor as the difference btw the 2 groups of ROIs
frame_idx = frame_idx-1;

% switch between BMI types
switch v

%% Normal BMI
case  1
data.cursor(:,frame_idx) = ROI_dff(1,frame_idx)+ROI_dff(2,frame_idx) - (ROI_dff(3,frame_idx)+ROI_dff(4,frame_idx));
% OPTIONAL: Smooth cursor
rn = 3; % running average...
CURSOR = round(5+(mean(data.cursor(:,frame_idx-rn:frame_idx)))/30);
data.cursor_actual(:,frame_idx) = CURSOR;

%% Song BMI
case 2
    
    for i = 1:4
        ID(i) = ROI_dff(i,end);
            end
    
     [M,I] = max(ID);
     
     if M>1;
     CURSOR = I;
     data.cursor(:,frame_idx) = CURSOR;
     else 
         CURSOR =0;
         data.cursor(:,frame_idx) = CURSOR;
    end

     
    

end

data.ROI_val = data.ROI_val;
data.ROI_dff = ROI_dff;



else
data.cursor = zeros(1,10);
data.ROI_val = data.ROI_val;
data.ROI_dff = zeros(4,10); % cant computer df/f
    CURSOR = 0;

end



