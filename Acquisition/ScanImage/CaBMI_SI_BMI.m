function CaBMI_SI_BMI
% Main BMI Scripts for Scanimage

% WAL3 d02/28/2020

% ask to generate new folder ( animal nams)
PATH_ADDN = datestr(now,'yyyymmdd_HHMM'); % Make sure this is unique!
PATH = ['C:\Users\User\Documents\MATLAB\',PATH_ADDN] ;

% conncet to Arduino Through Serial
arduino=serial('COM13','BaudRate',9600); % create serial communication object on port COM4
fopen(arduino); % initiate arduino communication


% Initialize workspace variables
BMI_Data.time = [];
BMI_Data.Frame = zeros(515,512);
BMI_Data.frame_idx = 1;
Tstart = tic; % timing vector

%% BASELINE
filename = 'Baseline_BEFORE'
BMI_Data.BMIready = 0;
time2run = 1; % minutes
TotalFrames = 30*60*time2run;
automatedGrab_BMI(TotalFrames,PATH,filename);
% save data
save([filename,'/matdata.m'],BMI_Data)

% save Baseline
BMI_Data_Baseline = BMI_Data;

%clear workspace
clear BMI_Data Tstart

%% Pick Cells ( or load from previous run)
[I, M, ROI, ccimage] = CaBMI_Dendrites;
BMI_Data.ROI = ROI;
BMI_Data.ccimage = ccimage;


%% RUN BMI
% RE-Initialize workspace variables
BMI_Data.time = [];
BMI_Data.Frame = zeros(515,512);
BMI_Data.frame_idx = 1;
Tstart = tic; % timing vector
% Run BMIA...
filename = 'BMI'
BMI_Data.BMIready = 1;
time2run = 1; % minutes
TotalFrames = 30*60*time2run;
automatedGrab_BMI(TotalFrames,PATH);
% save data
save([filename,'/matdata.m'],BMI_Data)


%% POST EXPERIMENT BASELINE
filename = 'Baseline_AFTER'
BMI_Data.BMIready = 0;
time2run = 1; % minutes
TotalFrames = 30*60*time2run;
automatedGrab_BMI(TotalFrames,PATH,filename);
% save data
save([filename,'/matdata.m'],BMI_Data)
