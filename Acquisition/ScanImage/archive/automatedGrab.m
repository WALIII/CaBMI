function automatedGrab()
    % example for using the ScanImage API to set up a grab
    hSI = evalin('base','hSI');             % get hSI from the base workspace
    assert(strcmpi(hSI.acqState,'idle'));   % make sure scanimage is in an idle state
 
   % hSI.hMotors.motorPosition = [0 0 0];    % move stage to origin Note: depending on motor this value is a 1x3 OR 1x4 matrix
    hSI.hScan2D.logFilePath = 'C:\Users\User\Documents\MATLAB';        % set the folder for logging Tiff files
    hSI.hScan2D.logFileStem = 'myfile';     % set the base file name for the Tiff file
    hSI.hScan2D.logFileCounter = 1;         % set the current Tiff file number
    hSI.hChannels.loggingEnable = true;     % enable logging
    hSI.hRoiManager.scanZoomFactor = 2;     % define the zoom factor
    hSI.hStackManager.framesPerSlice = 100;     % set number of frames to capture in one Grab
 
    hSI.startGrab();                        % start the grab
    
end