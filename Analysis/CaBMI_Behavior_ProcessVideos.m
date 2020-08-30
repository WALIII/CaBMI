function CaBMI_Behavior_ProcessVideos(varargin)
% CaBMI_Behavior_ProcessVideos

% % concatonate behavioral tiffs in directory, denoise, and get video timestamps

% run in extracted folder with videos and .mat files

% WAL3
% d08/10/2020

% Core function: ImBat_denoise
metadata.processed_FN = 'processed'
% Default params
video = 1;
audio = 1;
DS = 0.25;
TS = 1;

mkdir('processed');
% User pram:
nparams=length(varargin);
for i=1:2:nparams
    switch lower(varargin{i})
        case 'video'
            video=varargin{i+1};
        case 'audio'
            audio=varargin{i+1};
        case 'downsample'
            DS=varargin{i+1};
            %files = convn(files, single(reshape([1 1 1] / b, 1, 1, [])), 'same');
        case 'fname'
            filename=varargin{i+1};
        case 'metadata'
            metadata = varargin{i+1};
            DS = metadata.spatial_downsample;
            TS = metadata.temporal_downsample;
    end
end




% Load in all Tiffs, and concatonate them
if video ==1;
    
    mov_listing= [ dir(fullfile(pwd,'*.tif'));  dir(fullfile(pwd,'*.tiff'))];
    mov_listing={mov_listing(:).name};
    
    filenames=mov_listing;
    
    
    disp('Parsing Video files');
    
    %[nblanks formatstring]=fb_progressbar(100);
    %fprintf(1,['Progress:  ' blanks(nblanks)]);
    
    % Load in video data ( SPATIAL DOWNSAMPLE )
    for i=1:length(mov_listing)
        [path,file,ext]=fileparts(filenames{i});
        if i ==1;
            Yf = read_file(filenames{i});
            Yf = single(Yf);
            Yf = imresize(Yf,DS);
            [d1,d2,T] = size(Yf);
        else
            Yf_temp = read_file(filenames{i});
            Yf_temp = single(Yf_temp);
            Yf_temp = imresize(Yf_temp,DS);
            Yf = cat(3,Yf,Yf_temp);
            clear Yf_temp
        end
    end
    
    % remove global and local artifacts
    disp('remove artifacts');
    %Yf =  ImBat_denoise(Yf,'metadata',metadata);
    
    % temporal Downsample:
    %[Yf] = ImBat_TemporalDownSample(Yf,TS);
    
    % Save un-aligned videos:
    save([metadata.processed_FN,'/uncorrected_Data.mat'],'Yf','-v7.3');
    % Save and remove video from ram
   % CNMFe_align(Yf,metadata);
    
    %FS_tiff(Yf,'fname','processed/RAW_Video.tif');
    clear Yf;
end

if audio == 1;
    
    % Get the audio data:
    % Load in all Tiffs, and concatonate them
    mov_listing=dir(fullfile(pwd,'*.mat'));
    filenames={mov_listing(:).name};
    
    disp('Parsing Audio files');
    
    [nblanks formatstring]=fb_progressbar(100);
    fprintf(1,['Progress:  ' blanks(nblanks)]);
    
    for i=1:length(mov_listing)
        
        [path,file,ext]=fileparts(filenames{i});
        if i ==1;
            D = load(filenames{i}, 'audio', 'video');
        else
            D_temp = load(filenames{i}, 'audio', 'video');
            
            % Analog Stuff
            D.audio.nrFrames = D.audio.nrFrames+D_temp.audio.nrFrames;
            D.audio.data = cat(1,D.audio.data,D_temp.audio.data);
            D.audio.TotalDurration = D.audio.TotalDurration+D_temp.audio.TotalDurration;
            D.audio.times = cat(1,D.audio.times,D_temp.audio.times);
            % video stuff
            D.video.times = cat(1,D.video.times,D_temp.video.times);
            D.video.nrFramesTotal = D.video.nrFramesTotal+D_temp.video.nrFramesTotal;
            
            clear D_temp
        end
    end
    
    clear audio
    clear video
    audio = D.audio;
    video = D.video;
    
    save([metadata.processed_FN,'/AV_data'],'audio','video','-v7.3');
end
