% caBMI_sendTTL

devices = daq.getDevices


devices(2)


s = daq.createSession('ni')


%%% For sound, later...
% addAnalogOutputChannel(s,'cDAQ1Mod2',0,'Voltage');
% addAnalogOutputChannel(s,'cDAQ1Mod2',1,'Voltage');


% Add a digital channel
addDigitalChannel(s,'Dev2','port0/line0:3','OutputOnly')


s.Rate = 8000


for step = 1:50
outputSingleScan(s,[1 0 0 0]);
pause(0.01)
outputSingleScan(s,[0 0 0 0]);
pause(0.01)
end
