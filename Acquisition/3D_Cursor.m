function   [CURSOR_A,CURSOR_B, data] = c3D_Cursor(Im,ROI,data,frame_idx,vargin)
% WAL3_cursor.m

% WAL3's cursor for the BMI experiments

% d12.09.2017
% WAL3

% To do- need to know the history ( 100 samples) to estimate df/f
% Then make a theshold

% make a test case that plays a video, frame by frame. and outputs fictive
% tones



% Variables
thresh = 10; % dff/f thrsh
cells = 8; % number of cells for BMI ( hard-wired for 8 currently)


if nargin < 5
v = 2; % this will choses which BMI to run
end



%%% Basic Test Flight-
% standard BMI
dsample_fact = 1;
Im = imresize(single(round(Im)),1/dsample_fact); % convert from 16bit
%baseline(i) = mean(mean(squeeze(mean(Im1(ROI.coordinates{i}(:,1),ROI.coordinates{i}(:,2),:),1)),1));
for i = 1: cells
data.ROI_val(i,frame_idx) = mean(mean(Im(round(ROI.coordinates{i}(:,2)/dsample_fact),round(ROI.coordinates{i}(:,1)/dsample_fact)),1));
end


% Get Df/f values
if frame_idx>10;
    for i = 1:8
        baseline(i,:) = prctile(data.ROI_val(i,2:end),5); % if addaptive, change 99 to 'end'
    end

    for i = 1:8;
        ROI_dff(i,:) = (data.ROI_val(i,2:end)-baseline(i,:))./baseline(i,:)*100;
        % normalize
        ROI_norm(i,:) = (ROI_dff(i,:) - mean(ROI_dff(i,:)))/std(ROI_dff(i,:));
    end


%create the cursor as the difference btw the 2 groups of ROIs
frame_idx = frame_idx-1;

% switch between BMI types
switch v

%% Normalized BMI
case 2
    mult_fact = 2;
    scale_fact = 50;

    % Tone Frequency
data.cursorA(:,frame_idx) = ROI_norm(1,frame_idx)+ROI_norm(2,frame_idx) - (ROI_norm(3,frame_idx)+ROI_norm(4,frame_idx));
    % Beat Frequency
data.cursorB(:,frame_idx) = ROI_norm(5,frame_idx)+ROI_norm(6,frame_idx) - (ROI_norm(7,frame_idx)+ROI_norm(8,frame_idx));


% OPTIONAL: Smooth cursor

rn = 3; % running average...
CURSOR_A = round((5+(mean(data.cursorA(:,frame_idx-rn:frame_idx)))*mult_fact)*scale_fact); % Tone
CURSOR_B = round((5+(mean(data.cursorB(:,frame_idx-rn:frame_idx)))*mult_fact)*scale_fact); % Beat


CURSOR_A(CURSOR_A<0) = 0; %Tone
CURSOR_A(CURSOR_A<0) = 0; % Beat

data.cursor_actual_A(:,frame_idx) = CURSOR_A;
data.cursor_actual_B(:,frame_idx) = CURSOR_B;



%% Song BMI
case 3
    for i = 1:4
        ID(i) = ROI_dff(i,end);
            end
     [M,I] = max(ID);

     if M>1;
     CURSOR = I;
     data.cursor(:,frame_idx) = CURSOR;
     else
         CURSOR =0;
         data.cursor(:,frame_idx) = CURSOR;
    end




%% Sequential BMI
case 4
if data.cursor(:,frame_idx-1)/2 == 0;
    cursor =2;
    S_level = 1;
else
S_level = data.cursor(:,frame_idx-1)/2;
end

Ht = 2;


cursor = S_level*2;

if S_level == 1;

if ROI_norm(S_level,frame_idx) > Ht && ROI_norm(S_level+1,frame_idx) < Ht;
S_level = S_level+1;
disp('UPGRADE')
end

if ROI_norm(S_level+1,frame_idx) > Ht && ROI_norm(S_level,frame_idx) < Ht;
   S_level = S_level-1;
   disp('DOWNGRADE')
end

elseif S_level > 1 && S_level < 4

  if ROI_norm(S_level,frame_idx) > Ht && ROI_norm(S_level+1,frame_idx) < Ht && ROI_norm(S_level-1,frame_idx) < Ht;
  S_level = S_level+1;
  disp('UPGRADE')
  end
  if ROI_norm(S_level+1,frame_idx) > Ht && ROI_norm(S_level,frame_idx) < Ht;
     S_level = S_level-1;
     disp('DOWNGRADE')
  end
%   if ROI_norm(S_level-1,frame_idx) > Ht && ROI_norm(S_level,frame_idx) < Ht;
%      S_level = S_level-1;
%      disp('DOWNGRADE')
%   end


elseif S_level == 4;

  if ROI_norm(S_level,frame_idx) > Ht && ROI_norm(S_level-1,frame_idx) < Ht;
  S_level = S_level+1;
  disp('UPGRADE')
  end
  if ROI_norm(S_level-1,frame_idx) > Ht && ROI_norm(S_level,frame_idx) < Ht;
     S_level = S_level-1;
     disp('DOWNGRADE')
  end


elseif S_level == 5;
  S_level =1;
  disp('RESET')
end

cursor = S_level*2;
 %
 % % Step one
 % if S_level == 1;
 %
 %   if ROI_norm(2,frame_idx) > Ht && ROI_norm(1,frame_idx) < Ht && ROI_norm(3,frame_idx) < Ht;
 %             S_level = 2;
 %   elseif ROI_norm(1,frame_idx) > Ht && ROI_norm(2,frame_idx) < Ht;
 %              S_level = 0;
 %              disp('** DOWNGRADE***');
 %   else
 %       disp('cont');
 %             cursor = 2;
 %   end
 %  end
 %
 % % Step two
 %  if S_level == 2;
 %       cursor = 4;
 %
 %    if ROI_norm(3,frame_idx) > Ht && ROI_norm(2,frame_idx) < H2 && ROI_norm(4,frame_idx) < Ht;
 %               S_level = 3;
 %     elseif ROI_norm(2,frame_idx) > Ht && ROI_norm(3,frame_idx) < Ht;
 %                S_level = 1;
 %     end
 %   end
 %
 %   % Step three
 %    if S_level == 3;
 %         cursor = 6;
 %      if ROI_norm(3,frame_idx) > Ht && ROI_norm(2,frame_idx) < Ht && ROI_norm(4,frame_idx) < Ht;
 %          S_level = 4;
 %       elseif ROI_norm(3,frame_idx) > Ht && ROI_norm(4,frame_idx) < Ht;
 %          S_level = 2;
 %       end
 %     end
 %
 %     % Step four
 %      if S_level == 4;
 %           cursor = 8;
 %
 %        if ROI_norm(4,frame_idx) > Ht && ROI_norm(3,frame_idx) < Ht;
 %           S_level = 0;
 %           cursor = 10;
 %         elseif ROI_norm(3,frame_idx) > Ht && ROI_norm(4,frame_idx) < Ht;
 %                S_level = 3;
 %        end
 %      end

       data.cursor_actual(:,frame_idx) = cursor;
       CURSOR = cursor;
       data.cursor(:,frame_idx) = cursor;

end

data.ROI_val = data.ROI_val;
data.ROI_dff = ROI_dff;


else
data.cursor_actual_A = zeros(1,10);
data.cursor_actual_A = zeros(1,10);
data.cursor = zeros(1,10);
data.ROI_val = data.ROI_val;
data.ROI_dff = zeros(8,10); % cant computer df/f
    CURSOR = 0;

end
