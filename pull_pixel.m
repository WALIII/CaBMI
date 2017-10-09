
% Initialize
clear Im1
% get dims
X = pl.PixelsPerLine();
Y = pl.LinesPerFrame();
Im1(:,:,1) =  pl.GetImage_2(1,X,Y);
frame = 2;



while frame <  2000;
  Im = pl.GetImage_2(1,X,Y);


  if Im1(X,Y,frame-1) == Im(X,Y); % most of the time this will be true

      if((max(max(Im,[],1),[],1)-max(max(Im1(:,:,frame-1),[],1),[],1))>1000);
          outputSingleScan(s,[1]);
          disp('HIT')
          pause(0.01);
          outputSingleScan(s,[0]);
      end

  else
      Im1(:,:,frame) = Im;
      frame = frame+1;
      % if mean(Im1,1)
      pause(0.01) % should be a bit less than the frame rate
  end
end
