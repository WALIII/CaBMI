function [ds_hits, roi_hits] = CaBMI_csvAlign(Input0,Input1)
% CaBMI_csvAlign


  % Align .csv file timestamps to:
  %     1. ds_data
  %     2. ROI time series
  %     3. Raw Cursor data

  % vargin
  % Input0: vector containing auditory feedback timestamps
  % Input1: Vector containing 'hits'


  % WAL3
  % d3/17/18


% Vars
fs = 9400;% voltage sampling frequency
fr = 29; % frame rate
ds = 5; % ds_data temporal downsampling rate;


  % Extract tone times ( last tone is the end of the recording)
  A = diff(Input0);
  [pks1, locs1] = findpeaks(double(A),'MinPeakDistance',10,'MinPeakHeight',std(A)*2);
      % Plot TONE result:
           figure(); hold on; plot(A); plot(locs1,pks1,'*');
q = max(locs1); % end of recording
fr = 1/((q/fs)/(10910*ds));

  % Make a time vector ( units of seconds)
    % time_vec = 1:length


  % Extract Hit times
  B = diff(Input1);
  [pks2, locs2] = findpeaks(double(B),'MinPeakDistance',10,'MinPeakHeight',std(B)*5);
      % Plot HIT result:
           figure(); hold on; plot(B); plot(locs2,pks2,'*');
  % downsample to nearest time vector for ds_data and ROI data
roi_hits = round((locs2/fs)*fr);
ds_hits = round(roi_hits/ds);
