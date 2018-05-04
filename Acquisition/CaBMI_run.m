function TData = CaBMI_run(ROI,pl,arduino)
%% CaBMI_BMIrun.m

  % Pull data and align it, then save it all together.
  % Put a text flag that data needs to be processed today.

  % d12.10.2017
  % WAL3


% Vars
max_time = 60*30; % BMI time ( 30 min, total )



disp( '----------------------------------------------------');
disp( ['total time is ', num2str(max_time/60), ' minutes']);
disp([ 'total frames is ', num2str(max_time*30)]);
%% Do BMI periodically;
disp( '----------------------------------------------------');



%% Start Aquisition (trigger start with TTL) ( also trigger video monitor)

% Trigger to start
fprintf(arduino,'%c',char(98)); % START trigger
fprintf(arduino,'%c',char(998)); % START trigger

P3 = 30;

pause(P3); % aquire baseline...


  disp('Starting...');
  % Start:
  disp('triggering...');




  % run BMI
  % disp(['Running BMI Script ',num2str(L), ' of 30']);
  [data] = caBMI_feedback(pl,arduino,ROI,max_time)
  % TTL Start Aquisition
  % TTL

  TData = data;
  clear data;


fprintf(arduino,'%c',char(998)); % START trigger
fprintf(arduino,'%c',char(98)); % STOP trigger

%
%     if check >5
%       % Periodic alignment check- move ROI masks if need be...
%       disp('Running Alignment Check..');
%
%       disp('Adjusting ROIs..');
%       disp('ROIs are OK..');
%       check = 1;
%
% end







%% Save Data Temporarily


disp('save(...)');

%% Consolidate time series data in 2P Temp folder

disp('movedata(...)');
