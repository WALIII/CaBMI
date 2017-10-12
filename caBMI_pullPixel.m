
function [Im1] = caBMI_pullPixel(pl,s,max_frame)
% pull_pixel.m

% Pull basic time series from the 2P.
% Use this to select ROIs, or play wtih data

% d10.12.2017
% WAL3


clear Im1
% get dims
X = pl.PixelsPerLine();
Y = pl.LinesPerFrame();
Im1(:,:,1) =  pl.GetImage_2(1,X,Y);
counter = 2;

while counter <  max_frame;
Im = pl.GetImage_2(1,X,Y);
if Im1(X,Y,counter-1) ~= Im(X,Y); % if this is true, there is a new frame

  if((max(max(Im,[],1),[],1)-max(max(Im1(:,:,counter-1),[],1),[],1))>1000);
      outputSingleScan(s,[1]);
      pause(0.01);
      outputSingleScan(s,[0]);
      disp('HIT')
  end

    Im1(:,:,counter) = Im;   % log the frame to RAM
  counter = counter+1;

%  pause(0.01) % should be a bit less than the frame rate
end
end
