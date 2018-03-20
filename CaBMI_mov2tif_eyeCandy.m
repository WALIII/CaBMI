function CaBMI_mov2tif_eyeCandy

  % load in .mov from 1P ram, convert to seperate tif stacks
  %TO DO replace tiff loader with this..  to save memory...





% Params

max_size = 3000;
downsamp = 0.33;
b =10;

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
            vK = convn(vK, single(reshape([1 1 1] / b, 1, 1, [])), 'same');
     if i ==1;
                 
          % Tke the filtered mean
          disp('filtering the mean');
            X = mean(vK(:,:,100),3);
            X = imgaussfilt(X,40);
     else
     end
     
            for ii = 1:size(vK,3); vK(:,:,ii) = (((vK(:,:,ii)+10)-X)*9); end;
% Play the result

     
     
   FS_tiff(vK,'fname',filename);
   i = i+1;
   k = 1;
   clear vK;
   disp(['saving...   ', filename]);
 end
end
end





