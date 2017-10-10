function [data] = caBMI_feedback(pl,s,ROI,max_frame)
% Test Feedback

% sample = ROI{1}+ROI{2}>ROI{3}+ROI{4}

clear Im1
% get dims
X = pl.PixelsPerLine();
Y = pl.LinesPerFrame();
Im1(:,:,1) =  pl.GetImage_2(1,X,Y);
counter = 2;

while counter <  max_frame;
Im = pl.GetImage_2(1,X,Y);
if Im1(X,Y,counter-1) ~= Im(X,Y); % if this is true, there is a new frame

% cursor
if counter> 100; % buffer time
  [out_state(counter), cursor(counter)] = WAL3_cursor(Im1,Im,ROI);

    if out_state ==1;
          outputSingleScan(s,[1]);
            pause(0.01);
          outputSingleScan(s,[0]);
            disp('HIT')
    end
  end

    Im1(:,:,counter) = Im;   % log the frame to RAM
  counter = counter+1;

%  pause(0.01) % should be a bit less than the frame rate
end
end
