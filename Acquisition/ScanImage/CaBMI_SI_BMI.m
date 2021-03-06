%function CaBMI_SI_BMI
% Main BMI Scripts for Scanimage

% WAL3 d02/28/2020

% !! BEFORE STARTING: add 'BMI_callback' under to: Settings=> User Funcitons. Event Name: 'frameAquired' in the SI GUI

% TO DO: ask to generate new folder ( animal nams)
prompt = 'Mouse ID:';
MouseID = input(prompt,'s')
PATH_ADDN = datestr(now,'yyyymmdd_HHMM'); % Make sure this is unique!
PATH = ['F:\Liberti_data\BMI_DATA\',PATH_ADDN,'_',MouseID] ;
mkdir(PATH);


% conncet to Arduino Through Serial
if exist('arduino')~=1 % dont re-open channel w/ arduino
arduino=serial('COM19','BaudRate',9600); % create serial communication object on port COM4
fopen(arduino); % initiate arduino communication
end

% Initialize workspace variables
clear BMI_Data
BMI_Data = [];
BMI_Data.MouseID = MouseID
BMI_Data.condition = 1;
BMI_Data.Frame = zeros(515,512);
BMI_Data.frame_idx = 1;
BMI_Data.Hit_Thresh = 3.0; % threshold for getting a 'hit' in SD
BMI_Data.Reset_Thresh = 1; % reset threshold ( in SD)
BMI_Data.hit = 0; % index of hits
BMI_Data.reward = 0; % index of rewards
BMI_Data.num_hits = 0; % number of hits
BMI_Data.Tstart = tic; % timing vector
BMI_Data.time_idx = []; % timing index for each frame
BMI_Data.cursor_smooth = 3;
%Reward Jitter
BMI_Data.reward_jitter = 2;%15; %(n-1 max frame jitter added between success and reward)
BMI_Data.catch_trail_probability = 0; %percent catch trials
BMI_Data.temp_frame_jitter = 0; % temp holder of frame jitter 
%Cursor Delay
BMI_Data.cursor_offset = 0; % add n frames of delay between cursor and Direct neurons
BMI_Data.BMIready = 0;
BMI_Data.Magnification = 1.8;

%% BASELINE
filename = ['Baseline_BEFORE_',BMI_Data.MouseID];
BMI_Data.BMIready = 0;
% calulate frames to run...
time2run = 10; % minutes
time2run_sec = time2run*60;% seconds
time2run_frames = time2run_sec *30; % fps
TotalFrames = round(time2run_frames);

% get analog behavioral data
CaBMI_SI_acquireVoltageData

% grab imaging data
automatedGrab_BMI(TotalFrames,PATH,filename);
pause(time2run_sec+15);
disp('data finished collection!');

% save data
save([PATH,'/',filename,'_matdata.mat'],'BMI_Data')


%clear workspace


%% Pick Cells ( or load from previous run)
[I, M, ROI, ccimage] = CaBMI_Dendrites;



%% RUN BMI
clear I; % clear baseline data from ram
BMI_Data.ROI = ROI;
BMI_Data.ccimage = ccimage;
% RE-Initialize workspace variables
BMI_Data.num_hits = 0; % number of hits
BMI_Data.time = [];
BMI_Data.Frame = zeros(515,512);
BMI_Data.frame_idx = 1;
BMI_Data.Tstart = tic; % timing vector
% Run BMIA...
filename = ['BMI_',BMI_Data.MouseID];
BMI_Data.BMIready = 1;
% calulate frames to run...
time2run = 30; % minutes
time2run_sec = time2run*60;% seconds
time2run_frames = time2run_sec *30; % fps
TotalFrames = round(time2run_frames);
% Get Behavioral Data
CaBMI_SI_acquireVoltageData
%Run experiment 
automatedGrab_BMI(TotalFrames,PATH,filename);
pause(time2run_sec+1);
for i = 1:5;
fprintf(arduino,'%c',char(17))
pause(0.1);
end
pause(10); %saving buffer 
% save data
save([PATH,'/',filename,'_matdata.mat'],'BMI_Data')
disp('data finished collection!');





%% POST EXPERIMENT BASELINE
% RE-Initialize workspace variables
save([PATH,'/',filename,'_matdata.mat'],'BMI_Data')

BMI_Data.time = [];
BMI_Data.Frame = zeros(515,512);
BMI_Data.frame_idx = 1;
BMI_Data.Tstart = tic; % timing vector
filename = ['Baseline_AFTER_',BMI_Data.MouseID];
BMI_Data.BMIready = 0;
% calulate frames to run...
time2run = 10; % minutes
time2run_sec = time2run*60;% seconds
time2run_frames = time2run_sec *30; % fps
TotalFrames = round(time2run_frames);
% Get Behavioral Data
CaBMI_SI_acquireVoltageData
%get data
automatedGrab_BMI(TotalFrames,PATH,filename);
pause(time2run_sec+5);
disp('data finished collection!');




% save data
save([PATH,'/',filename,'matdata.mat'],'BMI_Data')

% close arduino
fclose(arduino)
