function CaBMI_mov2tif_eyeCandy

  % load in .mov from 1P ram, convert to seperate tif stacks
  %TO DO replace tiff loader with this..  to save memory...





% Params

max_size = 1500;
downsamp = .5;
b =3;

% find all movs
if nargin<1 | isempty(DIR), DIR=pwd; end

mov_listing=dir(fullfile(DIR,'*.mov'));
mov_listing={mov_listing(:).name};


filenames=mov_listing;

% Loop


for i=1:length(mov_listing)

    [path,file,ext]=fileparts(filenames{i});
    FILE = fullfile(DIR,mov_listing{i})

% make a folder, put these inside...

v1 = VideoReader(FILE);

if v1.NumberOfFrames < max_size
    max_size = v1.NumberOfFrames-1;
end
v1 = VideoReader(FILE);

k = 1;
i = 1;
while hasFrame(v1)
 v = readFrame(v1);
 vK(:,:,k) = imresize(squeeze(v(:,:,2)),downsamp); % keep only the green channel
 k = k+1;
 if k>max_size
     filename = ['Data_',num2str(i.','%03d'),'.tif'];
     disp('Smoothing data...');
     % Smooth data by 'b'
     
     % align data...
     Y = vK;
T = size(Y,ndims(Y));

% Motion Correction Params:
options_nonrigid = NoRMCorreSetParms('d1',size(Y,1),'d2',size(Y,2),'grid_size',[32,32],'mot_uf',4,'bin_width',200,'max_shift',15,'max_dev',3,'us_fac',50,'init_batch',200);

% perform motion correction
tic; [vK,shifts2,template2,options_nonrigid] = normcorre_batch(Y,options_nonrigid); toc

     
     
            %vK = convn(vK, single(reshape([1 1 1] / b, 1, 1, [])), 'same');
            X = uint8(round(single(medfilt3(vK,[25 25 1]))));
            
%      if i ==1;
%                  
%           % Tke the filtered mean
%           disp('filtering the mean');
%             X = mean(vK(:,:,500),3);
%             X = imgaussfilt(X,50*downsamp)-5; %121
%      else
%      end
     
            for ii = 1:size(vK,3); 
                vK(:,:,ii) = (vK(:,:,ii)+10)-X(:,:,ii);
                vK(:,:,ii) = vK(:,:,ii)*10;
            end;
            
            
            vK = vK-prctile(vK,1,3);
            vK = convn(vK, single(reshape([1 1 1] / b, 1, 1, [])), 'same');
% Play the result
            vK = uint8(255 * mat2gray(vK));
     
     
   FS_tiff(vK,'fname',filename);
   i = i+1;
   k = 1;
   clear vK;
   disp(['saving...   ', filename]);
 end
end
end





