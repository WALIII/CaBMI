function CaBMI_1P_ROIselect();
% CaBMI_1P_ROIselect

% Select ROIs from an arbitrary video, spit it out for Swift to read in!

% d082918
% WAL3


% Select movie to load;

disp('Select a .mov file');

[fileName,pathName] = uigetfile('*.mov')
% dname = fullfile(pathName,fileName)
% filelist = dir([fileparts(dname) filesep '*.mov']);

ReadObj = VideoReader(fileName);
CurFrame = 0;
GetFrame = 1:200;
counter = 1;
disp('loading in the first 200 frames...')
while hasFrame(ReadObj)
    CurImage = readFrame(ReadObj);
    CurFrame = CurFrame+1;
    if ismember(CurFrame, GetFrame)
        I(:,:,:,counter) = CurImage;
        counter = counter+1;
    end
end



% Downsample the video:
I = imresize(I,0.25);
I = FS_Format(I,1);
I = double(I);


% Filter any artifacts
for i = 1:3; % for 2 ittereations,
Im = squeeze(mean(mean(I(:,1:10,:),2),1));
TF = isoutlier(Im);
I(:,:,find(TF ==1)) = [];
end


% take the STD, Df/f and mean images:
I_std = std(I,[],3);
I_mean = mean(I,3);
I_min = min(I,[],3);
I_df = mean(I-I_min,3);

% Load into matrix...
I2(:,:,1) = I_std;
I2(:,:,2) = I_mean;
I2(:,:,3) = I_df;

% Ask the user to select one:
figure();
colormap(bone);
subplot(131);
imagesc(I_std);
subplot(132);
imagesc(I_mean);
subplot(133);
imagesc(I_df);

prompt = 'Which Image is best? ( enter: 1, 2, or 3)';
x = input(prompt);

I3 = I2(:,:,x);
I3 = imresize(I3,4);
I3  = uint8(round(mat2gray(I3)*255)); % scale to unit8

imwrite(I3,'ROI_image.png');
% Select an ROI

  ROI = caBMI_annotate_image('ROI_image.png');

  % Wait until keypress to move forward
  disp('press S when complete.. Do not forget to SAVE!');

pause();

  ROI = caBMI_annotate_image('ROI_image.png');

% Take the ROI output into the proper coordinate system
G = ROI.coordinates
[ydim xdim] = size(I3);

for i = 1: size(G,2); % for each ROI
cells(i,1) = mean(G{i}(:,1))/ydim; % xnorm
cells(i,2) = mean(G{i}(:,2))/xdim; % ynorm
cells(i,3) = (max(G{i}(:,1)-min(G{i}(1,:))))/ydim;
end

% Save as a CSV with the date-time as the title (for backup)
csvwrite(['ROI_SwiftFile ',datestr(datetime('now')),'.csv'],cells);
