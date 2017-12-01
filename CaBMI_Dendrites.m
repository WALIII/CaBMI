function [I, M, ROI] = CaBMI_Dendrites(I);
% For Dendrite imaging, rough, manual ROI selection. 

% WAL3 

% d11.29.2017


% Dependencies:

%   NoRMCorre, which can be found here:
%       https://github.com/flatironinstitute/NoRMCorre
%
%   CrossCorrImage, which can be found here:
%       http://labrigger.com/blog/2013/06/13/local-cross-corr-images/



%% Get Tifs.
if nargin < 1
disp('pick the first .tif');

[fileName,pathName] = uigetfile('*.tif')
dname = fullfile(pathName,fileName)
filelist = dir([fileparts(dname) filesep '*.tif']);
fileNames = {filelist.name}';
num_frames = (numel(filelist));


for i = 1:num_frames;
I(:,:,i) = imread(fullfile(pathName, fileNames{i}));
end

end


%% Display smoothed movie:
disp('smoothing data...');
tic
try
mov_data =  convn(I(:,:,1:200), single(reshape([1 1 1] / 4, 1, 1, [])), 'same');% smooth movie:
catch
  mov_data =  convn(I(:,:,:), single(reshape([1 1 1] / 4, 1, 1, [])), 'same');% smooth movie:
end
toc

figure();
for i = 1:size(mov_data,3);
imagesc(mov_data(:,:,i));
pause(0.01);
end


%% Motion Correction
prompt = 'Would you like to motion correct? (y/n) ';
str = input(prompt,'s');

if isempty(str)
    str = 'N';
end

if str == 'y'
C = size(I,3);
prompt = ['there are ', num2str(C), 'total frames. How many do you want?'];
ToT = input(prompt);
Y = single(I(:,:,1:ToT));% convert to single precision 
T = size(Y,ndims(Y));

% Motion Correction Params:
options_nonrigid = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'grid_size',[32,32],'mot_uf',4,'bin_width',200,'max_shift',15,'max_dev',3,'us_fac',50,'init_batch',200);

% perform motion correction
tic; [M2,shifts2,template2,options_nonrigid] = normcorre_batch(Y,options_nonrigid); toc

% compute metrics
M.nnY = quantile(Y(:),0.005);
M.mmY = quantile(Y(:),0.995);


[M.cM2,M.mM2,M.vM2] = motion_metrics(M2,10);
<<<<<<< HEAD
%T = length(M.cY);
=======

>>>>>>> origin/master

clear I;
I = M2;


mov_data =  convn(I(:,:,1:ToT), single(reshape([1 1 1] / 5, 1, 1, [])), 'same'); % Smooth data:


figure();% Display movie: 
for i = 1:size(mov_data,3)
imagesc(mov_data(:,:,i));
pause(0.01);
end

end

[M.cY,M.mY,M.vY] = motion_metrics(I,10);




%% Take local cross-corr
disp('Performing Local Cross-correlation...')
[ccimage]=CrossCorrImage(mov_data(:,:,10:end));


%% Get Freehand ROIs
[ROI] = CaBMI_ROI_freehand(ccimage);

    

