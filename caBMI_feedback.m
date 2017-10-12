function [data] = caBMI_feedback(pl,s,ROI,max_time)
% caBMI_feedback.m

% This function will perform the feedback  stim, using a cursor function
% d10.12.17
% WAL3

% User Input
wait_time = 0;% This is how long (in s) to calculate baseline before starting BMI


X = pl.PixelsPerLine(); % get x dim of the image
Y = pl.LinesPerFrame(); % get y dim of the image
Im1(:,:,1) =  pl.GetImage_2(1,X,Y); % Build the image
counter = 2;

% Start Pulling data
tic
while toc <  max_time; % this querrys the buffer every ~10ms.
Im = pl.GetImage_2(1,X,Y);

% TO DO caclulate baseline..

if toc< wait_time; % buffer time for baseline calculation
data.toc(counter) = toc; % how often are we waiting per frame. For timeing rconstruction

% Cursor function
[data.out_state(counter), ROI_data] = WAL3_cursor(Im1,Im,ROI,counter-1); % cursor

% Feedback:
    if data.out_state(counter) ==1;
          outputSingleScan(s,[1]);
            pause(0.01); % ~10ms stim
          outputSingleScan(s,[0]);
            disp('HIT')
    end

% Save data to RAM for export
data.cursor(counter) = ROI_data.cursor;
data.ROI_val(:,counter) = ROI_data.ROI_val;
data.Im1(:,:,counter) = Im;   % log the frame to RAM

% advance counter
  counter = counter+1;
 pause(0.01) % should be a bit less than the frame rate- to stabilize aquisition.

end
end
