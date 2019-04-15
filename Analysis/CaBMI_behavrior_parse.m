
function CaBMI_behavrior_parse(mov_data,varargin);


% % get the tifs:
% if exist('mov_data2','var')
% mov_listing=dir(fullfile(pwd,'*.tif'));
% mov_listing={mov_listing(:).name};
% 
% 
% mov_data = loadtiff((fullfile(pwd,mov_listing{2})));
%  
% for i = 3:7;
%     b = loadtiff((fullfile(pwd,mov_listing{i})));
%  mov_data = cat(3,mov_data,b);
% end
% 
% end

% load in video data
video = VideoReader('2018-05-09 16 41 43.mov');
k = 1;
while hasFrame(video)
vt = readFrame(video);
% resize
v(:,:,k) = imresize(squeeze(vt(:,:,2)),0.025);
k = k+1;
end


v = double(v);
v2  = squeeze(mean(v,2));
v3 = var(v2);
vsm = smooth(v3,10)';
figure(); plot(abs(zscore((v3-vsm))));





% do PCA on the images

%mov_data2 = single(imresize(mov_data(:,:,:),0.5));
mov_data2 = mov_data-mean(mov_data,3);
[rows, columns, frames] = size(mov_data2);

% Get an N by 3 array of all the RGB values.  Each pixel is one row.
% Column 1 is the red values, column 2 is the green values, and column 3 is the blue values.
listOfRGBValues = double(reshape(mov_data2, rows * columns, frames));

% Now get the principal components.
[coeff, score] = pca(listOfRGBValues);

% Take the coefficients and transform the RGB list into a PCA list.
transformedImagePixelList = listOfRGBValues * coeff;



% transformedImagePixelList is also an N by 3 matrix of values.
% Column 1 is the values of principal component #1, column 2 is the PC2, and column 3 is PC3.
% Extract each column and reshape back into a rectangular image the same size as the original image.
for i = 1:6;
A = (reshape(transformedImagePixelList(:,i), rows, columns));
pcaImage(:,:,i) = A;
end

pcaImage = mat2gray((pcaImage-min(pcaImage,[],3)));


for i = 1:3
figure(); 
AxesH = axes;
imshow(pcaImage(:,:,i+1:3+i));
InSet = get(AxesH, 'TightInset');
set(AxesH, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)])
axis off
end





