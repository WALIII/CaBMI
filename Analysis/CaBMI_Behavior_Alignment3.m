function [timepoints, aligned_timeVector] = CaBMI_Behavior_Alignment3(framepoints,video,audio);
% Identify BMI and rest sessions, and export time-point data

% WAL3
% d10/17/2020


% load in AV_data ( or csv...)
        timepoints.Imaging_on = video.times(framepoints.Imaging_on);
        timepoints.Imaging_off = video.times(framepoints.Imaging_off);
        timepoints.Imaging_difference = timepoints.Imaging_off-timepoints.Imaging_on;
        
        % Get Baseline/BMI index:
        baseline_index = find(timepoints.Imaging_difference/60 >9 & timepoints.Imaging_difference/60 <11);
        BMI_index = find(timepoints.Imaging_difference/60 >29 & timepoints.Imaging_difference/60 <31);
        
        figure();
        hold on;
            plot(timepoints.Imaging_difference/60,'b*');
            plot(baseline_index,timepoints.Imaging_difference(baseline_index)/60,'r*'); % baseline
            plot(BMI_index,timepoints.Imaging_difference(BMI_index)/60,'g*'); % BMI index
            legend('extra','baseline','BMI');
            xlabel(' Identified Imaging session');
            ylabel( 'time (m)');
            title('Time of recorded sessions per animal');
            
        % TimeVector for Calcium Imaging Alignment
        for i = 1: size(BMI_index,1)
            aligned_timeVector.BMI{i}.frames = framepoints.Imaging_on(BMI_index(i)):framepoints.Imaging_off(BMI_index(i));
            aligned_timeVector.BMI{i}.aligned_timepoints = video.times(aligned_timeVector.BMI{i}.frames)'-video.times(aligned_timeVector.BMI{i}.frames(1))';
        end
        
        for i = 1:size(baseline_index,1)
            aligned_timeVector.baseline{i}.frames = framepoints.Imaging_on(baseline_index(i)):framepoints.Imaging_off(baseline_index(i));
            aligned_timeVector.baseline{i}.aligned_timepoints = video.times(aligned_timeVector.baseline{i}.frames)'-video.times(aligned_timeVector.baseline{i}.frames(1))';
        end