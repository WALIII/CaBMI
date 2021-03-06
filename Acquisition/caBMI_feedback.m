function [data] = caBMI_feedback(pl,arduino,ROI,max_time)
% caBMI_feedback.m

% This function will perform the feedback  stim, using a cursor function
% d10.12.17
% WAL3

% User Input
wait_time = 0.01;% This is how long (in s) to calculate baseline before starting BMI
BufferT = 0.1;
cb = 1; %cursor counter;
condition = 1;
% Plot figure
hf = figure();
grid on; grid minor;
%whitebg;

X = pl.PixelsPerLine(); % get x dim of the image
Y = pl.LinesPerFrame(); % get y dim of the image
Im1(:,:,1) =  pl.GetImage_2(2,X,Y); % Build the image
counter = 2;
pauseTime = tic;
% Start Pulling data
tStart = tic;
cursorTic = tic;
while toc(tStart) <  max_time  % this querrys the buffer every ~10ms.


Im = pl.GetImage_2(2,X,Y);

% TO DO caclulate baseline..

%if toc(tFrame)> wait_time; % buffer time for baseline calculation
data.toc(counter) = toc(tStart); % how often are we waiting per frame. For timeing rconstruction

% Cursor function

[Cursor, data] = WAL3_cursor_song(Im,ROI,data,counter-1); % cursor


% buffer the outputted cursor


% Auditory Cursor:
if toc(cursorTic) > BufferT; % smooth cursor
 cursorTic = tic;

fdbk = 1;



% Save data to RAM for export

% data.Im1(:,:,counter) = Im;   % log the frame to RAM


% caBMI_LivePlot(data,counter,hf);

 %%%%%%%

 Cursor = (Cursor);
% WATER DELIVERY

 data.hit(counter) =0;
if condition == 1;
if Cursor>9;
    Cursor = 99;
    disp('HIT')
    condition = 2;
    data.hit(counter) =1;
end
elseif condition == 2
  disp(' Waiting to drop below threshold...')
  if Cursor<9
    disp ( 'Resetting Cursor')
        data.hit(counter) =-1;
    condition = 1;
  end
end





% Write cursor state to Speaker
while fdbk
    fprintf(arduino,'%c',char(Cursor)); % send answer variable content to arduino
fdbk = 0;
end



disp(Cursor); %display mean cursor value

% Clear cursor Buffer
clear CursBuff







% advance counter
  counter = counter+1;
 pause(0.001) % should be a bit less than the frame rate- to stabilize aquisition.

end
    end
end
