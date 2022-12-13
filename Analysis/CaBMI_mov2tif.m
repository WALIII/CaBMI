function CaBMI_mov2tif(varargin);

  % load in .mov from 1P ram, convert to seperate tif stacks
  %TO TO replace tiff loader with this..  to save memory...


% INCOMPLETE



% Default Params
Total_max_size = 400;
max_size = 400;
downsamp = 1;
deinterlace =0;
max_proj = 0;




% find all movs
% if nargin<1 | isempty(DIR), DIR=pwd; end
DIR = pwd;
% user input

% Loop
mkdir('processed');

nparams=length(varargin);

if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end


% User input
for i=1:2:nparams
	switch lower(varargin{i})
		case 'downsamp' % downsample video
			downsamp=varargin{i+1};
		case 'deinterlace' % de-interlace 60fps video
			deinterlace =varargin{i+1};
		case 'max_proj' % to make a max projectio
			max_proj=varargin{i+1};
           mkdir('processed/MAX');
    end
end




mov_listing=dir(fullfile(DIR,'*.mov'));
mov_listing={mov_listing(:).name};


filenames=mov_listing;



for ii=1:length(mov_listing)

    [path,file,ext]=fileparts(filenames{ii});
    FILE = fullfile(DIR,mov_listing{ii})

% make a folder, put these inside...

v1 = VideoReader(FILE);

if v1.NumberOfFrames < Total_max_size
    max_size = v1.NumberOfFrames;
end
v1 = VideoReader(FILE);

k = 1;
i = 1;
while hasFrame(v1)
 v = readFrame(v1);
 vK(:,:,:,k) = imresize(squeeze(v(:,:,:)),downsamp); % keep only the green channel
 k = k+1;
 if k>max_size
     filename = ['processed/',file,'_',num2str(i.','%03d')];
     if deinterlace ==1;
         vK =  CaBMI_deInterlace(vK);
     end
   FS_tiff(vK,'fname',filename);
   if max_proj ==1;
       if size(size(vK),2)>3;
           % upsample by a factor of 3
           vK = double(vK);
           vK = imresize(vK,2);
           
    max_vK = mean(vK,4)*256;
         filename = ['processed/MAX/',file,'_',num2str(i.','%03d')];
    imwrite(uint16(squeeze(max_vK)),[filename,'_MAX.tif']);
       end
     
   end
   i = i+1;
   k = 1;
   clear vK;
   disp(['saving...   ', filename]);
 end
end
   clear vK;


end
