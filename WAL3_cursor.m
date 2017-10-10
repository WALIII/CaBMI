function   [out_state, cursor] = WAL3_cursor(Im1,Im,ROI,vargin)
% WAL3_cursor.m

% WAL3's cursor for the BMI experiments

% d10.10.2017
% WAL3

% Variables
thresh = 10;
cells = 4; % number of cells for BMI ( hard-wired for 4 currently)


if nargin < 4
v = 1;
end

% switch between BMI types
switch v
  case 1
% standard BMI
  for i = 1:cells
baseline(i) = mean(mean(squeeze(mean(Im1(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2),:),1)),1));
ROI_val(i) = mean(squeeze(mean(Im(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2)),1)),1);
  end

% create the cursor as the difference btw the 2 groups of ROIs
cursor = (ROI_val(1)+ROI_val(2)) - (ROI_val(3)+ROI_val(4))

% Output the state
if cursor>thresh
  out_state = 1;
else
  out_state = 0;
end


case 2 % this is the test case ~does the current frame brighter than the last
  if((max(max(Im,[],1),[],1)-max(max(Im1(:,:,counter-1),[],1),[],1))>1000);

end
