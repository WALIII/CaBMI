%% CaBMI_SI_acquireVoltageData

% Aquires Licking data

% d06/23/2020
% WAL3


s = daq.createSession('ni');
addAnalogInputChannel(s,'Dev6', 0, 'Voltage');
addAnalogInputChannel(s,'Dev6', 1, 'Voltage');

s.Rate = 500;
% set time
if exist('time2run_sec')>0;
    s.DurationInSeconds = time2run_sec+10;
else
    disp('no defined time set, default to 10s');
    s.DurationInSeconds = 10;
end
s

s.NotifyWhenDataAvailableExceeds = s.Rate * s.DurationInSeconds;

if exist('time2run_sec')>0;
   fname = [PATH,'/',filename,'LickData.mat'];
else
    disp('no defined licking data filename');
    fname = 'LickData.mat';
end

h2 = s.addlistener('DataAvailable',@(src,event)collectData(src,event,fname));
s.startBackground();

%
% function collectData(src,event)
%      time = event.TimeStamps;
%      data = event.Data;
%      plot(time,data)
%      save log.mat data time
%      disp('Background Acquisition complete');
% end
