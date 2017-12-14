function CaBMI_LiveAlign(ROI,pl,arduino)
%% CaBMI_LiveAlign.m

  % Pull data and align it, then save it all together.
  % Put a text flag that data needs to be processed today.

  % d12.10.2017
  % WAL3


% Vars
check = 1;
L= 1;
fdbk = 1;

trials = 5;
P1 = 10; % Pause in the begining
P2 = 10; % pause in the end
P3 = 60; % INterval between trials
max_time = 30; % BMI time

%% Start Aquisition (trigger start with TTL) ( also trigger video monitor)

% Trigger to start

%% Do BMI periodically;
Tz = tic;
while L<trials; % do 50 trials of 30 seconds.



if toc(Tz) > P3;

% Start:
  while fdbk
      fprintf(arduino,'%c',char(98)); % START trigger
  fdbk = 0;
  end

  pause(P1);

  % run BMI
  disp(['Running BMI Script ',num2str(L), ' of 50']);
  % TTL Start Aquisition
  % TTL
  pause(P2)


fdbk = 1;
  while fdbk
      fprintf(arduino,'%c',char(98)); % START trigger
  end

Tz = tic;
check = check+1;
L = L+1;

end

if check >5
  % Periodic alignment check- move ROI masks if need be...
    disp('Running Alignment Check..');

    disp('Adjusting ROIs..');
    disp('ROIs are OK..');
  check = 1;

end


end





%% Save Data Temporarily


disp('save(...)');

%% Consolidate time series data in 2P Temp folder

disp('movedata(...)');
