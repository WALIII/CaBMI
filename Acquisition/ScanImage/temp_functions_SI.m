% Temp functions

%% 1. temp_ROI creator
hSI.hIntegrationRoiManager.roiGroup.rois(1).scanfields(1).centerXY = [1,1];      % define the center of the scanfield in scan angle coordinates
hSI.hIntegrationRoiManager.roiGroup.rois(1).scanfields(1).sizeXY = [1,1];        % define the size of the scanfield in scan angle coordinates
hSI.hIntegrationRoiManager.roiGroup.rois(1).scanfields(1).mask = rand(10,10);    % define a (random) weighted mask for an integration scanfield
