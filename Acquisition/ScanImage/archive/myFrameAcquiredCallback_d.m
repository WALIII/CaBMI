function myFrameAcquiredCallback_d(src,evt,varargin)
    hSI = src.hSI; % get the handle to the ScanImage model
 
    % scanimage stores image data in a data structure called 'stripeData'
    % this example illustrates how to extract an acquired frame from this structure
    lastStripe = hSI.hDisplay.stripeDataBuffer{hSI.hDisplay.stripeDataBufferPointer}; % get the pointer to the last acquired stripeData
    channels = lastStripe.roiData{1}.channels; % get the channel numbers stored in stripeData
     
    for idx = 1:length(channels)
        frame{idx} = lastStripe.roiData{1}.imageData{idx}{1}; % extract all channels
    end
    disp('FRAME AQd')
 
    % the last frame for all channels stored in the cell array 'frame'
    % now we can go on to process the data...
end