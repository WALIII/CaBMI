function out = BMI_acqnvs(vals,varargin)

% To initialize the recording:
flush =0;

%Variables to define before running the code / (grab in scanimage)
E1 = [2 4];
E2 = [1 3];  % E2 being the one that has to INCREASE!!!  to get reward
T1 = -0.75; % value obtained by the baseline to get 30% of correct trials.
%563
%% this is only to initialize
persistent expHistory
if flush
    vars = whos;
    vars = vars([vars.persistent]);
    varName = {vars.name};
    clear(varName{:});
    out = []; 
    clear a;
    clear expHistory;
    disp('flushiiiing')
    expHistory = [];
    return
end

%%
%%**********************************************************
%****************  PARAMETERS  ****************************
%**********************************************************
% parameters for the function that do not change (and we may need in each
% iteration. 
units = length(E1)+length(E2); 
ens_thresh=0.95; % essentially top fraction (%) of what each cell can contribute to the BMI
motionThresh =10;  %value to define maximum movement to flag a motion-relaxation time
relaxationTime = 4;  % there can't be another hit in this many sec
motionRelaxationFrames = 5;  %number of frames that there will not be due to signficant motion
durationTrial = 30; % maximum time that mice have for a trial
movingAverage = 1; % Moving average of frames to calculate BMI in sec
timeout = 5; %seconds of timeout if no hit in duration trial (sec)
expectedLengthExperiment = evalin('base','hSI.hFastZ.numVolumes'); % frames that will last the online experiment (less than actual exp)
baseLength = 2*60; %  to establish BL 
freqMax = 18000;
freqMin = 2000;

% values of parameters in frames
frameRate = evalin('base','hSI.hRoiManager.scanFrameRate/hSI.hFastZ.numFramesPerVolume');

movingAverageFrames = round(movingAverage * frameRate); 
baseFrames = round(baseLength * frameRate);
relaxationFrames = round(relaxationTime * frameRate);
timeoutFrames = round(timeout * frameRate);
    
% Define persistent variables that will remain in each iteration of this
% function
persistent a rewardHistory trialHistory i tim nZ motionFlag motionCounter trialFlag backtobaselineFlag lastVol baseval counter misscount
global cursor frequency


%%
%*********************************************************************
%******************  INITIALIZE  ***********************************
%*********************************************************************
if ~isa(a, 'arduino')
    a = arduino('COM15', 'Uno');
    disp('starting arduino')
end

if isempty(expHistory) %if this is the first time it runs this program (after flush)
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %global parameters hSI;
    out =0;       %required output to ScanImage
    expHistory = single(nan(units, movingAverageFrames));  %define a windows buffer
    cursor = single(nan(1,expectedLengthExperiment));  %define a very long vector for cursor
    frequency = single(nan(1,expectedLengthExperiment));
    assignin('base','cursor', cursor);
    assignin('base','frequency', frequency);
    assignin('base','miss', []);
    assignin('base','hits', []);
    assignin('base','trialEnd', []);
    assignin('base','trialStart', []);
    baseval = single(ones(units,1).*vals);
    i = 1 ;
    nZ=evalin('base','hSI.hFastZ.numFramesPerVolume');
    rewardHistory=0; 
    trialHistory = 0;
    motionFlag = 0;
    motionCounter = 0;
    lastVol = 0;  %careful with this it may create problems
    tim = tic;
    trialFlag = 1;
    counter = 40;
    backtobaselineFlag = 0;
    misscount = 0;
    
    % Write 'Exp_Flag' to the Phenosys computer so we know this is the
    % start of a BMI experiment.
    a.writeDigitalPin("D6", 1); pause(0.010);a.writeDigitalPin("D6",0) 
end


%%
%************************************************************************
%*************************** RUN ********************************
%************************************************************************
thisFrame = evalin('base','hSI.hScan2D.hAcq.hFpga.AcqStatusAcquiredFrames');
thisVol = floor(thisFrame/nZ);
%if we've completed a new volume, update history 
% store nans on frames that we've skipped so we know we skipped
% them
if thisVol > lastVol
    %update frame
    steps = thisVol - lastVol;
    lastVol = thisVol;
    i = i + steps;
    assignin('base','duration', i);
    % variable to hold nans in unseen frames
    placeholder = nan(numel(vals),steps-1);
    mVals = [placeholder vals];

    % update buffer of activity history
    if steps < movingAverageFrames
        expHistory(:, 1: end-steps) = expHistory(:, steps+1:end);
        expHistory(:,end-steps+1:end) = mVals;    
    else
        expHistory = mVals(:, end-movingAverageFrames+1:end);
    end

    %handle misscount
    if misscount > 9
        T1 = T1 - T1/20;
        disp (['New T1: ', num2str(T1)])
        misscount = 0;
    end
    
    %handle motion
    % because we don't want to stim or reward if there is motion
    mot = evalin('base', 'hSI.hMotionManager.motionCorrectionVector');
    if ~isempty(mot)
        motion = sqrt(mot(1)^2 + mot(2)^2 + mot(3)^2); 
    else
        motion = 0;
    end

    if motion>motionThresh
        motionFlag = 1;
        motionCounter = 0;
    end

    if motionFlag == 1     % flag if there was motion "motionRelaxationFrames" ago, do not allow reward
       motionCounter = motionCounter + 1;        
       if motionCounter>=motionRelaxationFrames
           motionFlag = 0;
       end 
    end
    
    if counter == 0
        % Is it a new trial?
        if trialFlag && ~backtobaselineFlag
            evalin('base','trialStart(end+1) = duration;')
            trialHistory = trialHistory + 1;
            trialFlag = 0;
            %start running the timer again
            tim = tic;
            disp('New Trial!')
        end
        % calculate baseline activity and actual activity for the DFF

        signal = single(nanmean(expHistory, 2));
        if i >= baseFrames
            baseval = (baseval*(baseFrames - 1) + signal)./baseFrames;
        else
            baseval = (baseval*(single(i) - 1) + signal)./single(i);
        end
        % calculation of DFF
        if isnan(baseval)
            baseval(:) = 1;
        end
        dff = (signal - baseval) ./ baseval;
        dff(dff<T1*ens_thresh) = T1*ens_thresh; % limit the contribution of each neuron to a portion of the target
        % it is very unprobable (almost imposible) that one cell of E2 does
        % it on its own, buuut just in case:
        dff(dff>-T1*ens_thresh) = -T1*ens_thresh;

        cursor(i) = nansum([nansum(dff(E1)),-nansum(dff(E2))]);

        % calculate frequency
        freqmed = (freqMax - freqMin)/2;
        freq = double(round(freqmed + 2000 - cursor(i)/T1*freqmed));
        if isnan(freq) || freq <0
            freq = 0;
        elseif freq > freqMax  % this shouldnt happen because it would be a hit
            freq = freqMax;
        end
        frequency(i) = freq;
        
        if backtobaselineFlag 
            if cursor(i) >= 1/2*T1
                backtobaselineFlag = 0;
            end
            tim = tic;  % to avoid false timeouts while it goes back to baseline
        else
            if cursor(i) <= T1 && ~motionFlag      %if it hit the target
                % remove tone
                a.playTone("D11", freq, 1);
                % give water reward
                a.writeDigitalPin("D10", 1); pause(0.25);a.writeDigitalPin("D10",0)
                % update rewardHistory
                rewardHistory = rewardHistory + 1;
                disp(['Trial: ', num2str(trialHistory), 'Rewards: ', num2str(rewardHistory)]);
                % update trials and hits vector
                evalin('base','trialEnd(end+1) = duration;')
                evalin('base','hits(end+1) = duration;');
                trialFlag = 1;
                misscount = 0;
                counter = relaxationFrames;
                backtobaselineFlag = 1;

            else
                % update the tone to the new cursor
                a.playTone("D11", freq, 1);
                if toc(tim) > durationTrial
                    a.playTone("D11", 0, timeout);
                    disp('Timeout')
                    evalin('base','trialEnd(end+1) = duration;')
                    evalin('base','miss(end+1) = duration;')
                    trialFlag = 1;
                    misscount = misscount + 1;
                    counter = timeoutFrames;
                end
                if cursor(i) >= T1 && motionFlag 
                    disp('mot too high for reward');
                end
            end
        end
    else        
        counter = counter - 1;
    end
end  

%% Outputs
curval = cursor(i);
freqval = frequency(i);
assignin('base','curval', curval);
assignin('base','freqval', freqval);
evalin('base','cursor(duration)=curval;')
evalin('base','frequency(duration)=freqval;')
out = 0;


end



