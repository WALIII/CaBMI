function CaBMI_Widefield_optimize

% produce pattern w/ DMD then see if it sharpens image


% List webcams
webcamlist


% pick one
% cam = webcam;


% image dimensions:
x = 608/4;
y = 684/4;
seg = 1:200:x;
% close;



% start loop:
 % produce initial speckle pattern:   
A = logical(randi([0 1], x,y));
mkdir('bitmaps');

for i = 1: 50; 

% img = snapshot(cam);
% Measure image sharpness ( to do: determine sharpness via tesselation) 

% plot 
figure(1); 
% imshow(img)
figure(2); 
AxesH = axes;
imagesc(A);
InSet = get(AxesH, 'TightInset');
set(AxesH, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)])
colormap(gray);

 imwrite(A,['bitmaps/',num2str(i),'.bmp']);
% Calculate if things are better or worse than before- add noise:
counter = 1;
for ii = 1: size(seg,2)-1;
for  iii = 1: size(seg,2)-1;
    idx1 = seg(ii):seg(ii+1);
    idx2 = seg(iii):seg(iii+1);
FM(ii,iii,i) = fmeasure(A(idx1,idx2),'TENV');
counter = counter+1;
end
end
A = randi([0 1], x,y);
end


% % figure();
% % plot(FM);
% 
% % Get resoultion..
% cam.AvailableResolutions
% 
% img = snapshot(cam);
