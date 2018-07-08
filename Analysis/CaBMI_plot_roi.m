function roi_ave= CaBMI_plot_roi(ROIS,varargin)
%CaBMI_plot_roi selects an arbitrary number of roi's for plotting
%
%



colors=eval(['winter(' num2str(length(ROIS.coordinates)) ')']);
sono_colormap='hot';
baseline=3;
ave_fs=30;
save_dir='roi';
template=[];
fs=48000;
per=8;
max_row=5;
min_f=0;
max_f=9e3;
lims=1;
dff_scale=20;
t_scale=.5;
resize=1;
detrend_traces=0;
crop_correct=0;
ring = 0; % subtract ring around ROI ( local backgrounds)
mov_case = 0; % for many single tiffs....



nparams=length(varargin);

if mod(nparams,2)>0
	error('Parameters must be specified as parameter/value pairs');
end

for i=1:2:nparams
	switch lower(varargin{i})
		case 'colors'
			colors=varargin{i+1};
		case 'sono_colormap'
			sono_colormap=varargin{i+1};
		case 'baseline'
			baseline=varargin{i+1};
		case 'ave_fs'
			ave_fs=varargin{i+1};
		case 'save_dir'
			save_dir=varargin{i+1};
		case 'template'
			template=varargin{i+1};
		case 'fs'
			fs=varargin{i+1};
		case 'per'
			per=vargin{i+1};
		case 'max_row'
			max_row=varargin{i+1};
		case 'dff_scale'
			dff_scale=varargin{i+1};
		case 't_scale'
			t_scale=varargin{i+1};
		case 'resize'
			resize=varargin{i+1};
		case 'detrend_traces'
			detrend_traces=varargin{i+1};
		case 'crop_correct'
			crop_correct=varargin{i+1};
		case 'ring'
			ring = varargin{i+1};
		case 'type'
			format = varargin{i+1}; % if tiff, mov, mat, etc
	end
end


% Warnings
if ring ==1;
    disp(' WARNING: subtracting perimiter of ROI...');
end

if resize~=1
	disp(['Adjusting ROIs for resizing by factor ' num2str(resize)]);

	for i=1:length(ROIS.coordinates)
		ROIS.coordinates{i}=round(ROIS.coordinates{i}.*resize);
	end
end


mkdir(save_dir);


% first convert ROIS to row and column indices, then average ROI and plot
% the time course

% TODO check to see what is in the directery- or ask. what format to use, if more than one....

mov_listing=dir(fullfile(pwd,'*.tif'));
mov_listing={mov_listing(:).name};



num_frames = (numel(mov_listing));

if num_frames>300;
    disp('Detected many individual tifs, concatonating...');
for i = 1:num_frames%num_frames;
I(:,:,i) = imread(fullfile(pathName, fileNames{i}));
end
mov_listing =1;
mov_case = 1;
end



to_del=[];
 for i=1:length(mov_listing)
	if strcmp(mov_listing{i},'dff_data.mat')
		to_del=i;
 	end
 end

% mov_listing(to_del)=[];

roi_n=length(ROIS.coordinates);
disp('Generating single trial figures...');
clear mov_data

for i=1:length(mov_listing)

clear tmp; clear mov_data; clear frames; clear mic_data; clear ave_time; clear offset2; clear vid_times; clear mov_data_aligned;

if mov_case == 0;

	warning('off','all')
		disp(['Processing file ' num2str(i) ' of ' num2str(length(mov_listing))]);

        %load(fullfile(pwd,mov_listing{i}),'video');
        mov_data = loadtiff((fullfile(pwd,mov_listing{i})));
	warning('on','all')
else
    mov_data = I;
    clear I;
end




	%[mov_data, n] = FS_Format(mov_data2,1);
	clear mov_data2;
    clear video;
	% resize if we want

	if resize~=1

		disp(['Resizing movie data by factor of ' num2str(resize)]);

		frameone=imresize(mov_data(:,:,1),resize);
		[new_rows,new_columns]=size(frameone);

		new_mov=zeros(new_rows,new_columns,frames);

		for j=1:frames
			new_mov(:,:,j)=imresize(mov_data(:,:,j),resize);
		end

		%im_resize=im_resize.*resize;
		mov_data=new_mov;
		clear new_mov;

	end

	[path,file,ext]=fileparts(mov_listing{i});
	save_file=[ file '_roi' ];

	% highpass for mic trace



	[rows,columns,frames]=size(mov_data);
	roi_t=zeros(roi_n,frames);


frame_idx = 0:size(mov_data,3)-1;
	timevec=(frame_idx./30); %movie_fs

	disp('Computing ROI averages...');

	[nblanks formatstring]=fb_progressbar(100);
	fprintf(1,['Progress:  ' blanks(nblanks)]);

	% unfortunately we need to for loop by frames, otherwise
	% we'll eat up too much RAM for large movies

	for j=1:roi_n
		fprintf(1,formatstring,round((j/roi_n)*100));

		for k=1:frames
			tmp=mov_data(ROIS.coordinates{j}(:,2),ROIS.coordinates{j}(:,1),k);

				if ring == 1;

						[yCoordinates, xCoordinates] = GetRing(ROIS.coordinates{j},rows,columns);
						annul=mov_data(yCoordinates,xCoordinates,k);
						roi_t(j,k)=mean(tmp(:))-mean(annul(:));
else
			roi_t(j,k)=mean(tmp(:));

		end
	end
    end
	fprintf(1,'\n');

	dff=zeros(size(roi_t));


	% interpolate ROIs to a common timeframe

	for j=1:roi_n
clear tmp; clear dff; clear yy2; clear yy;
		tmp=roi_t(j,:);



		if baseline==0
			norm_fact=mean(tmp,3);
		elseif baseline==1
			norm_fact=median(tmp,3);
		elseif baseline==2
			norm_fact=trimmean(tmp,trim_per,'round',3);
		else
			norm_fact=prctile(tmp,per);
		end

		dff(j,:)=((tmp-norm_fact)./norm_fact).*100;


		%yy=interp1(timevec,dff(j,:),ave_time,'spline');
		%yy2=interp1(timevec,tmp,ave_time,'spline');

		temp.interp_dff(j,:)=dff(j,:);
		temp.interp_raw(j,:)=tmp;

    end

        if i ==1;
        roi_ave = temp;
				roi_ave.indexing(1,:) = 1:size(mov_data,3); %frame index
				roi_ave.indexing(2,:) = ones(size(mov_data,3),1); % which file
				roi_ave.indexing(3,:) = 1:size(mov_data,3); % local frame index
    else
        roi_ave.interp_dff = [roi_ave.interp_dff, temp.interp_dff];
        roi_ave.interp_raw = [roi_ave.interp_raw, temp.interp_raw];
				temp2(1,:) = [roi_ave.indexing(1,:),(1:size(mov_data,3))+max(roi_ave.indexing(1,:))]; %frame index
				temp2(2,:) = [roi_ave.indexing(2,:),ones(1,size(mov_data,3))*i]; % which file
				temp2(3,:) = [roi_ave.indexing(3,:),1:size(mov_data,3)]; % local frame index
    roi_ave.indexing = temp2;
    end
    clear temp; clear temp2;



	roi_ave.raw{i}=roi_t; % store for average
	roi_ave.filename{i}=mov_listing{i};


    end


%roi_ave.t=ave_time;
%save(fullfile(save_dir,['ave_roi.mat']),'roi_ave');
disp('Generating average ROI figure...');
