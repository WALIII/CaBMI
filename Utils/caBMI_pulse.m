function caBMI_pulse(s)
% caBMI_pulse.m

% Send TTL pulse to trigger aquisition for latency tests

% d10.12.2017
% WAL3


%% PreFlight
% start session:
%  devices = daq.getDevices
%  s = daq.createSession('ni')
%  s.Rate = 8000
%  addDigitalChannel(s,'Dev5','port0/line0','OutputOnly')

%% Send TTL
tic

for step = 1:50
tic
outputSingleScan(s,[1]);
pause(0.033)
toc
%outputSingleScan(s,[0]);
%pause(0.1)
outputSingleScan(s,[0]);
pause(1.5)

end
