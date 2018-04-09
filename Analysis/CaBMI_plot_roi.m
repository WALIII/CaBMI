function roi_ave= CaBMI_plot_roi(ROIS,varargin)
%CaBMI_plot_roi selects an arbitrary number of roi's for plotting
%
%


% Run in MPtiff folder.



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
ring = 1;

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

if resize~=1
	disp(['Adjusting ROIs for resizing by factor ' num2str(resize)]);

	for i=1:length(ROIS.coordinates)
		ROIS.coordinates{i}=round(ROIS.coordinates{i}.*resize);
	end
end


mkdir(save_dir);

% ROIS is a cell array of image indices returned by fb_select_roi
%

% first convert ROIS to row and column indices, then average ROI and plot
% the time course

% TODO check to see what is in the directery- or ask. what format to use, if more than one....

% mov_listing=dir(fullfile(pwd,'*.tif'));
mov_listing=dir(fullfile(pwd,'*.tif'));
mov_listing={mov_listing(:).name};


to_del=[];
 for i=1:length(mov_listing)
	if strcmp(mov_listing{i},'dff_data.mat')
		to_del=i;
 	end
 end

% mov_listing(to_del)=[];

roi_n=length(ROIS.coordinates);

% mov_data = loadtiff(fullfile(pwd,mov_listing{1}));


% [rows,columns,frames]=size(mov_data);
%
% ave_time=0:1/ave_fs:(size(mov_data,3)-1)/30;
%
% % need to interpolate the average onto a new time bases
%
% roi_ave.raw={};
% roi_ave.interp_dff=zeros(roi_n,length(ave_time),length(mov_listing));
% roi_ave.interp_raw=zeros(roi_n,length(ave_time),length(mov_listing));
disp('Generating single trial figures...');
clear mov_data

for i=1:length(mov_listing)

clear tmp; clear mov_data; clear frames; clear mic_data; clear ave_time; clear offset2; clear vid_times; clear mov_data_aligned;

	% disp(['Processing file ' num2str(i) ' of ' num2str(length(mov_listing))]);
	% mov_data = loadtiff(fullfile(pwd,mov_listing{i}));
	% %load(fullfile(pwd,mov_listing{i}),'video')%,'mic_data','fs','vid_times');

	warning('off','all')
		disp(['Processing file ' num2str(i) ' of ' num2str(length(mov_listing))]);
        
		
        %load(fullfile(pwd,mov_listing{i}),'video');
        mov_data = loadtiff((fullfile(pwd,mov_listing{i})));
	warning('on','all')


	
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
%
% 	if length(frame_idx)~=frames
% 		warning('Trial %i file %s may be corrupted, frame indices %g not equal to n movie frames %g',...
% 			i,mov_listing{i},length(frame_idx),frames);
% 		frame_idx=frame_idx(1:frames);
% 	end
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


%save individual files
%save(fullfile(save_dir,[save_file '.mat']),'roi_t','frame_idx','fs','timevec');

	roi_ave.raw{i}=roi_t; % store for average
	roi_ave.filename{i}=mov_listing{i};

    end
end

%roi_ave.t=ave_time;
save(fullfile(save_dir,['ave_roi.mat']),'roi_ave');
disp('Generating average ROI figure...');

% plot the averages with confidence intervals

%timevec=ave_time;

% if template is passed use the template mic trace, otherwise use the last song

%roi_mu=mean(roi_ave.interp_dff,3);
%roi_sem=std(roi_ave.interp_dff,[],3)./sqrt(size(roi_ave.interp_dff,3));

%if ~isempty(template)
%	[song_image,f,t]=fb_pretty_sonogram(double(template),fs,'low',1.5,'zeropad',1024,'N',2048,'overlap',2040);
%end

%fb_multi_fig_save(save_fig,save_dir,'ave_roi','eps,png,fig','res',100);

%%%%%%%%%%%%% CELL MASK MATCHED TO ROI
% plot cell masks color-matched to their ROIs
