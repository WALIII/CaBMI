%create simple image
im1 = zeros( 684, 608, 3 );
im1 (300:380, 300:380, :) = 255;
imwrite( im1, 'im1.bmp' );
imFile1 = fopen( 'im1.bmp' );
imData1 = fread( imFile1, inf, 'uchar' );
fclose( imFile1 );

im2 = zeros( 684, 608, 1 );
im2 (300:380, 300:380, :) = 255;
imwrite( im2, 'im2.bmp' );
imFile2 = fopen( 'im2.bmp' );
imData2 = fread( imFile2, inf, 'uchar' );
fclose( imFile2 );

im3 = zeros( 684, 608, 3 );
im3 (300:380, 300:380, :) = 1;
imwrite( im3, 'im3.bmp' );
imFile3 = fopen( 'im3.bmp' );
imData3 = fread( imFile3, inf, 'uchar' );
fclose( imFile3 );

%load file
% imFile = fopen( 'im.bmp' );
% imData = fread( imFile, inf, 'uchar' );
% fclose( imFile );

%test light crafter

L=LightCrafter()
%L.connect()
tcpObject = tcpip('192.168.1.100',21845);
tcpObject.BytesAvailableFcn = @instrcallback
tcpObject.BytesAvailableFcnCount = 7;
tcpObject.BytesAvailableFcnMode = 'byte';
fopen(tcpObject)
L.setBMPImage( imData2, tcpObject )
L.setStaticColor( 'FF', 'FF', 'FF', tcpObject )
%L.setPattern('0A', tcpObject)



%Create a custom Image:

im1 = (randi(2,300)-1)*255;
im1 = imresize(im1,3,'nearest');
imwrite( im1, 'im1.bmp' );
imFile1 = fopen( 'im1.bmp' );
imData1 = fread( imFile1, inf, 'uchar' );
fclose( imFile1 );




% Make a grating
im1 = zeros(50,50);
cols = 0:50-1;
im1(:,find(mod(cols,4)<2))=1;

% im1 = (randi(2,300)-1)*255;
im1 = imresize(im1,10,'nearest');
imwrite( im1, 'im1.bmp' );
imFile1 = fopen( 'im1.bmp' );
imData1 = fread( imFile1, inf, 'uchar' );
fclose( imFile1 );


% write the image
L.setBMPImage( imData1, tcpObject );







% imFile_n = fopen( '1.bmp' );
% imData_n = fread( imFile3, inf, 'uchar' );
% fclose( imFile_n );
% L.setBMPImage( imData_n, tcpObject );
% %data = fread(tcpObject,tcpObject.BytesAvailable);

