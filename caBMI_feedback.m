function [data] = caBMI_feedback(pl,arduino,ROI,max_time)
% caBMI_feedback.m

% This function will perform the feedback  stim, using a cursor function
% d10.12.17
% WAL3

% User Input
wait_time = 0.01;% This is how long (in s) to calculate baseline before starting BMI
BufferT = 0.1;
cb = 1; %cursor counter;
% Plot figure
hf = figure();
grid on; grid minor;
%whitebg;


X = pl.PixelsPerLine(); % get x dim of the image
Y = pl.LinesPerFrame(); % get y dim of the image
Im1(:,:,1) =  pl.GetImage_2(1,X,Y); % Build the image
counter = 2;

% Start Pulling data
tStart = tic;
cursorTic = tic;
while toc(tStart) <  max_time % this querrys the buffer every ~10ms.
Im = pl.GetImage_2(1,X,Y);

% TO DO caclulate baseline..

%if toc(tFrame)> wait_time; % buffer time for baseline calculation
data.toc(counter) = toc(tStart); % how often are we waiting per frame. For timeing rconstruction

% Cursor function
tic
[data.out_state(counter), ROI_data] = WAL3_cursor(Im1,Im,ROI,counter-1); % cursor
toc;


CursBuff(cb) = ROI_data.cursor;
cb = cb+1;
% Auditory Cursor:
if toc(cursorTic) > BufferT; % smooth cursor
 cursorTic = tic;

fdbk = 1;

%take mean of cursor in buffer
MM = char(abs(round(3-mean(CursBuff)))); % take out abs

while fdbk
    fprintf(arduino,'%c',MM); % send answer variable content to arduino
fdbk = 0;
end


MMx = abs(round(3-mean(CursBuff)));

%disp(MMx); %display mean cursor value

% Clear cursor Buffer
clear CursBuff
cb = 1;

% Feedback:
    if data.out_state(counter) ==1;
            disp('HIT')
    end

% Save data to RAM for export
data.cursor(counter) = ROI_data.cursor;
data.ROI_val(:,counter) = ROI_data.ROI_val;
data.Im1(:,:,counter) = Im;   % log the frame to RAM

caBMI_LivePlot(MMx,data,counter,hf)


% advance counter
  counter = counter+1;
 pause(0.01) % should be a bit less than the frame rate- to stabilize aquisition.

end
end
