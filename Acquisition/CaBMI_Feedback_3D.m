function [data] = CaBMI_Feedback_3D(pl,arduino,ROI,max_time)
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
     data.toc(counter) = toc(tStart); % how often are we waiting per frame. For timeing rconstruction
% 
    [Cursor_A,Cursor_B, data, STD] = c3D_Cursor(Im,ROI,data,counter-1); % cursor
    
    
    


% % WATER DELIVERY

 data.hit(counter) =0;
if condition == 1;
if STD(:,1)>1.5 && STD(:,2)<-1.5;
    Cursor_A = 999;
    disp('HIT')
    condition = 2;
    data.hit(counter) =1;
end
elseif condition == 2
  disp(' Waiting to drop below threshold...')
  data.hit(counter) =-1;
  if STD(:,1)<1 && STD(:,2)>-1;
    disp ( 'Resetting Cursor')
    condition = 1;
  end
end


% SEND DATA
          a =  char(sprintfc('%03d',Cursor_A)); % TONE
          b = char(sprintfc('%03d',Cursor_B)); % BEAT
    
    answer = [a,b];
    disp(['raw = ', char(answer), '    ', 'STD1 = ', char(num2str(STD(:,1),3)), '  STD2 = ', char(num2str(STD(:,2),3)) ]);
    fprintf(arduino,'%s',answer); % send answer variable content to arduino
pause(0.03);

counter = counter+1;
end
    
