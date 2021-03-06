function [mov_data, M, ROI, ccimage] = CaBMI_Dendrites(I);
% For Dendrite imaging, rough, manual ROI selection.

% WAL3

% d11.29.2017

% To read in stacks, use
% >> I = loadtiff('Data_8.tif');
%

% Dependencies:

%   NoRMCorre, which can be found here:
%       https://github.com/flatironinstitute/NoRMCorre
%
%   CrossCorrImage, which can be found here:
%       http://labrigger.com/blog/2013/06/13/local-cross-corr-images/
%
%   ScanImageTiffReader, which can be found on ScanImage's GitLab

colormap(gray);
SI_format = 0; % scanImage format ( default flag is zero, will change if SI format is detected)



%% Get Tifs.
if nargin < 1
    disp('pick the first .tif');
    
    [fileName,pathName] = uigetfile('*.tif')
    dname = fullfile(pathName,fileName)
    filelist = dir([fileparts(dname) filesep '*.tif']);
    fileNames = {filelist.name}';
    num_frames = (numel(filelist));
    
    if num_frames>30;
        for i = 1:2000%num_frames;
            I(:,:,i) = imread(fullfile(pathName, fileNames{i}));
        end
    else
        try
            I = loadtiff(fileName);
        catch
            disp('scanimage format...')
            reader=ScanImageTiffReader(dname);
            I=reader.data();
            SI_format =1;
        end
    end
    
    
end
disp('smoothing data...');

LastFrame = size(I,3);
ds_temp = 10;
frameIdx = 100:ds_temp:LastFrame;
counter = 1;
% mov = (convn(mov, single(reshape([1 1 1] / 3, 1, 1, [])), 'same'));

for i = 1:size(frameIdx,2)-1
  mov_data(:,:,counter) = mean(single(I(:,:,frameIdx(i):frameIdx(i+1))),3);
counter= counter+1;
end
clear I

%

%% Display smoothed movie:

% tic
% try
%    mov_data =  convn(I2(:,:,1:4:2000), single(reshape([1 1 1] / 30, 1, 1, [])), 'same');% smooth movie:
%   % mov_data = medfilt3(I(:,:,1:1:1000),[1 1 15]);
% catch
%     mov_data =  convn(I2(:,:,:), single(reshape([1 1 1] / 30, 1, 1, [])), 'same');% smooth movie:
%    %    mov_data = medfilt3(I(:,:,:),[1 1 15]);
% 
% end
% toc

figure();
for i = 1:size(mov_data,3);
    imagesc(mov_data(:,:,i));
    pause(0.01);
end


% 
% %% Motion Correction
% prompt = 'Would you like to motion correct? (y/n) ';
% str = input(prompt,'s');
% 
% if isempty(str)
%     str = 'N';
%     M = 'N/A';
% end
% 
% if str == 'y'
%     C = size(I,3);
%     prompt = ['there are ', num2str(C), 'total frames. How many do you want?'];
%     ToT = input(prompt);
%     Y = single(I(:,:,1:ToT));% convert to single precision
%     T = size(Y,ndims(Y));
%     
%     % Motion Correction Params:
%     options_nonrigid = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'grid_size',[32,32],'mot_uf',4,'bin_width',200,'max_shift',15,'max_dev',3,'us_fac',50,'init_batch',200);
%     
%     % perform motion correction
%     tic; [M2,shifts2,template2,options_nonrigid] = normcorre_batch(Y,options_nonrigid); toc
%     
%     % compute metrics
%     M.nnY = quantile(Y(:),0.005);
%     M.mmY = quantile(Y(:),0.995);
%     
%     
%     [M.cM2,M.mM2,M.vM2] = motion_metrics(M2,10);
%     %T = length(M.cY);
%     
%     clear I;
%     I = M2;
%     
%     
%     mov_data =  convn(I(:,:,1:ToT), single(reshape([1 1 1] / 5, 1, 1, [])), 'same'); % Smooth data:
%     
%     
%     figure();% Display movie:
%     for i = 1:size(mov_data,3)
%         imagesc(mov_data(:,:,i));
%         pause(0.01);
%     end
%     
%     
%     [M.cY,M.mY,M.vY] = motion_metrics(I,10);
%     
% else
%     M = 'N/A';
% end




%% Take local cross-corr
disp('Performing Local Cross-correlation...')
if size(mov_data,3)>1000;
    disp('loading in first 1000 frames...');
    [ccimage]=CrossCorrImage(mov_data(:,:,10:1000));
else
    [ccimage]=CrossCorrImage(mov_data(:,:,10:end));
end


%% Get Freehand ROIs
[ROI] = CaBMI_ROI_freehand(ccimage,8);



% Save Data with a unique filename
filename = ['ROI_Backup-', datestr(datetime)]
disp('Saving Data...')
%save(filename,ROI);
M = 0;
