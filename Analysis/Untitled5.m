

for i = 1: 180;
figure(1);
    subplot(1,2,1);
    y = 200:460;
    x = 400:1600;
 imagesc(VideoData(y,x,i)-VideoData(y,x,i+1),[0 256]); 
 
     subplot(1,2,2);
    y = 600:900;
    x =  400:1600;
 imagesc(VideoData(y,x,i)-VideoData(y,x,i+1),[0 256]); 
 colormap(jet);
 figure(2)
     subplot(1,2,1);
    y = 200:460;
    x = 400:1600;
 imagesc(VideoData(y,x,i),[0 256]); 
 
     subplot(1,2,2);
    y = 600:900;
    x =  400:1600;
 imagesc(VideoData(y,x,i),[0 256]); 
  colormap(bone);
 pause(0.01); end

 