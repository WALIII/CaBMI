
function CaBMI_PCAmov(varargin);

% get the pca from an input video ( cellular, behavior or both



% get the tifs:
% if exist('mov_data2','var')
mov_listing=dir(fullfile(pwd,'*.tif'));
mov_listing={mov_listing(:).name};


mov_data = loadtiff((fullfile(pwd,mov_listing{1})));
 
% for i = 3:7;
%     b = loadtiff((fullfile(pwd,mov_listing{i})));
%  mov_data = cat(3,mov_data,b);
% end




% do PCA on the images

mov_data2 = single(imresize(mov_data(:,:,:),1));
mov_data2 = mov_data2-mean(mov_data2,3);
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

resz = 5;

for i = 1:3
figure(); 
AxesH = axes;
imshow(imresize(pcaImage(:,:,i+1:3+i),resz));
InSet = get(AxesH, 'TightInset');
set(AxesH, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)])
axis off
end


figure(); 
hold on;
for i = 1:3
subplot(1,3,i);

imagesc(imresize(pcaImage(:,:,i+1:3+i)*3,resz),[0,0.1]);
%InSet = get(AxesH, 'TightInset');
%set(AxesH, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)])
end







