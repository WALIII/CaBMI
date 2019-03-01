

%% Get connected to LightCrafter:
if exist('L') ==0;  
    %test light crafter
    disp(' connecting to LightCrafter');
  
%test light crafter
L=LightCrafter()
%L.connect()
tcpObject = tcpip('192.168.1.100',21845);
tcpObject.BytesAvailableFcn = @instrcallback
tcpObject.BytesAvailableFcnCount = 7;
tcpObject.BytesAvailableFcnMode = 'byte';
fopen(tcpObject)
% L.setBMPImage( imData2, tcpObject )
disp('displaying test image...');
L.setStaticColor( 'FF', 'FF', 'FF', tcpObject )
%L.setPattern('0A', tcpObject)

else
    disp(' Already connected..');
end

    SendDataToLightCrafter(L, tcpObject)

function SendDataToLightCrafter(L, tcpObject)



disp('making circles');
for i = 1: 50;
imageSizeX = 700;
imageSizeY = 600;
[columnsInImage rowsInImage] = meshgrid(1:imageSizeX, 1:imageSizeY);
%Next create the circle in the image.
for iii = 1:1; % number of cells to stim...
radius = 1;
centerX = randi(imageSizeX-radius);
centerY = randi(imageSizeY-radius);

circlePixels_t(:,:,iii) = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 <= radius.^2;
end
circlePixels = max(circlePixels_t,[],3);


imwrite(circlePixels, 'temp.bmp' );
imFile1 = fopen( 'temp.bmp' );
CircIM(:,:,i)  = fread( imFile1, inf, 'uchar' );
fclose( imFile1 );

end



figure();
counter = 1;
for i = 1:3;
    tic
for ii = (1: 10) + counter
    L.setBMPImage(squeeze(CircIM(:,:,ii)), tcpObject )
        pause(0.01)
end
counter = counter+10;

    L.setStaticColor( '00', '00', '00', tcpObject )
pause(3)

 end

% L.setStaticColor( 'FF', 'FF', 'FF', tcpObject )

% 
end



% 
% 
% %% Generate Images
% s = 200;
% 
% % Make a grating
% im1 = zeros(s,s);
% cols = 0:s-1;
% im1(:,find(mod(cols,4)<2))=1;
% 
% % im1 = (randi(2,300)-1)*255;
% sz = round(700/s);
% im1 = imresize(im1,sz,'nearest');
% imwrite( im1, 'im1.bmp' );
% imFile1 = fopen( 'im1.bmp' );
% imData1 = fread( imFile1, inf, 'uchar' );
% fclose( imFile1 );
% 
% % rotate by 45 degrees:
% im2 = imrotate(im1,45,'nearest','crop');
% % im1 = (randi(2,300)-1)*255;
% imwrite( im2, 'im2.bmp' );
% imFile2 = fopen( 'im2.bmp' );
% imData2 = fread( imFile2, inf, 'uchar' );
% fclose( imFile2 );
% 
% im3 = imrotate(im1,90,'nearest','crop');
% % im1 = (randi(2,300)-1)*255;
% imwrite( im3, 'im3.bmp' );
% imFile3 = fopen( 'im3.bmp' );
% imData3 = fread( imFile2, inf, 'uchar' );
% fclose( imFile3 );
% 
% 



% 
% %% Loop and display for Live SIM:
% for ii = 1:3;
% % write the image
% figure(); hold off; imagesc(im1);
% L.setBMPImage( imData1, tcpObject );
% for i = 1:10;
%     img1(:,:,i) = snapshot(cam);
% end
% IM{1} = mean(img1,3);
% 
% % take image
% 
% % Display Images
% imagesc(im1);
% L.setBMPImage( imData2, tcpObject );
% pause(0.1);
% % take image
% for i = 1:10;
%     img1(:,:,i) = snapshot(cam);
% end
% IM{2} = mean(img1,3);
% 
% imagesc(im1);
% L.setBMPImage( imData3, tcpObject );
% pause(0.1);
% % take image
% for i = 1:10;
%     img1(:,:,i) = snapshot(cam);
% end
% IM{3} = mean(img1,3);
% 
% 
%% Run structured Illumination
% 
% 
% figure();
% counter = 1;
% for i = 1:20;
%     if counter == 1;
% %     imagesc(imData1)
%     L.setBMPImage( int8(imData1), tcpObject )
%     counter = counter+1;
%     pause(0.01)
%     elseif counter == 2;
% %     imagesc(imData2)   
%     L.setBMPImage( int8(imData2), tcpObject )
%    counter = counter+1;
%      pause(0.01)
%     elseif counter == 3;
% %     imagesc(im3)
%     L.setBMPImage( int8(imData3), tcpObject )
%      pause(0.01)
%     counter = 1;
%     end
% end