function CaBMI_DLC_Tiff2AVI
% WAL3
% 10/01/2020

% NOTE run in 'mat' folder


% create AVI folder
mkdir('DLC/videos')

% Get all Tiffs
mov_listing= [ dir(fullfile(pwd,'*.tif'));  dir(fullfile(pwd,'*.tiff'))];
mov_listing={mov_listing(:).name};

filenames=mov_listing;


disp('Parsing Video files');

% Video Writer
v = VideoWriter('DLC/videos/FullVideo.avi');
v_2 = VideoWriter('DLC/videos/Label.avi');
% open video writer
open(v); open(v_2);
for i=1:length(mov_listing)
    [path,file,ext]=fileparts(filenames{i});
    clear Yf
    disp(['Progress = ',num2str(i),'/',num2str(length(mov_listing))]);
    Yf = read_file(filenames{i});    % Load in video data ( SPATIAL DOWNSAMPLE )
    
    for ii = 1:size(Yf,3)
        writeVideo(v,Yf(:,:,ii))
        if i ==1
            writeVideo(v_2,Yf(:,:,ii))
        elseif i ==2;
            close(v_2) % save ' To Label' Video
        end
    end
    
end
close(v);
