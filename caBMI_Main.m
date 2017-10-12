
% caBMI_Main.m

% Walkthorugh of the basic functions of the BMI setup.
% grab pixel values  under user selected Regions of interest
% and perform numerical operations on them.


%% PreFlight
% Connect to the PrairieLink
pl = actxserver('PrairieLink.Application');
pl.Connect();
pl.SendScriptCommands('-lbs true 5')

% conncet to NiDaq
s = daq.createSession('ni');
s.Rate = 8000; % up the sampling rate
addDigitalChannel(s,'Dev5','port0/line1','OutputOnly')


%% GET ROI DATA

% Collect Baseline Data
max_frame = 100;
[Im1] = pull_pixel(pl,s,max_frame)

% Selec ROIs & Save reference image
Ref_Im = uint16(mean(Im1,3));
imwrite(uint16(mean(Im1,3)),'Ref_Im.tif');
[ROI] = caBMI_annotate_image('Ref_Im.tif');

% make a figure qith the ROIs
caBMI_refPlot(ROI,Im1)


%% BMI EXPERIMENT

% stim test


% Run experiment
max_time = 30; %seconds
[data] = caBMI_feedback(pl,s,ROI,max_time)


%% Analize Data
