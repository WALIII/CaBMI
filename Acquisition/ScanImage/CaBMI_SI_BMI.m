function CaBMI_SI_BMI
% Main BMI Scripts for Scanimage


% ask to generate new folder ( animal nams)

PATH = 'C:\Users\User\Documents\MATLAB'; % Make sure this is unique!

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

% save Baseline
BMI_Data_Baseline = BMI_Data;

%clear workspace
clear BMI_Data Tstart

%% Pick Cells ( or load from previous run)
[I, M, ROI, ccimage] = CaBMI_Dendrites;


%% RUN BMI
filename = 'BMI'
BMI_Data.BMIready = 1;
time2run = 1; % minutes
TotalFrames = 30*60*time2run;
automatedGrab_BMI(TotalFrames,PATH);

%% POST EXPERIMENT BASELINE
filename = 'Baseline_AFTER'
BMI_Data.BMIready = 0;
time2run = 11; % minutes
TotalFrames = 30*60*time2run;
automatedGrab_BMI(TotalFrames,PATH,filename);

% save data
