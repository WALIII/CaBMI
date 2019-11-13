
% caBMI_Main_SI.m

% Walkthorugh of the basic functions of the BMI setup.
% grab pixel values  under user selected Regions of interest
% and perform numerical operations on them.


%% PreFlight
% Connect to the ScanImage
% pl = actxserver('PrairieLink.Application');
% pl.Connect();
% pl.SendScriptCommands('-lbs true 5')

% conncet to Arduino Through Serial
arduino=serial('COM13','BaudRate',9600); % create serial communication object on port COM4
fopen(arduino); % initiate arduino communication

whitebg;
%% GET ROI DATA

% Collect Baseline Data
max_frame = 100;
[Im1] = caBMI_pullPixel_SI(pl,max_frame);

% Selec ROIs & Save reference image
Ref_Im = uint16(mean(Im1,3));
imwrite(uint16(mean(Im1,3)),'Ref_Im.tif');
[ROI] = caBMI_annotate_image('Ref_Im.tif');

% make a figure qith the ROIs
caBMI_refPlot(ROI,Im1);


%% BMI EXPERIMENT

% stim test


% Run experiment
max_time = 30; %minutes
[data] = caBMI_feedback(pl,arduino,ROI,max_time);


%% Analize Data
