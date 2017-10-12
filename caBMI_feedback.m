function [data] = caBMI_feedback(pl,s,ROI,max_time)
% Test Feedback

% sample = ROI{1}+ROI{2}>ROI{3}+ROI{4}

clear Im1
% get dims
X = pl.PixelsPerLine();
Y = pl.LinesPerFrame();
Im1(:,:,1) =  pl.GetImage_2(1,X,Y);
counter = 2;
tic
while toc <  max_time;
Im = pl.GetImage_2(1,X,Y);

%if Im1(X,Y,counter-1) ~= Im(X,Y); % if this is true, there is a new frame
data.toc(counter) = toc

% cursor
if counter> 1; % buffer time
%tic
  [data.out_state(counter), ROI_data] = WAL3_cursor(Im1,Im,ROI,counter-1);
%toc

    if data.out_state(counter) ==1;
          outputSingleScan(s,[1]);
            pause(0.01);
          outputSingleScan(s,[0]);
            disp('HIT')
    end
end
  % Save data for export
data.cursor(counter) = ROI_data.cursor;
data.ROI_val(:,counter) = ROI_data.ROI_val;

    Im1(:,:,counter) = Im;   % log the frame to RAM
  counter = counter+1;
 pause(0.01) % should be a bit less than the frame rate
%end
end

