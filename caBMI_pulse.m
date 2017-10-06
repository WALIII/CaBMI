function caBMI_pulse(s)


% start session: 
% devices = daq.getDevices
% s = daq.createSession('ni')
% addDigitalChannel(s,'Dev5','port0/line0','OutputOnly')


for step = 1:50
outputSingleScan(s,[1]);
pause(0.01)
%outputSingleScan(s,[0]);
%pause(0.1)
outputSingleScan(s,[0]);
pause(1.0)
end