% caBMI_sendTTL

devices = daq.getDevices


devices(2)


s = daq.createSession('ni')


%%% For sound, later...
% addAnalogOutputChannel(s,'cDAQ1Mod2',0,'Voltage');
% addAnalogOutputChannel(s,'cDAQ1Mod2',1,'Voltage');


% Add a digital channel
addDigitalChannel(s,'Dev5','port0/line0','OutputOnly')
addDigitalChannel(s,'Dev5','port0/line1','OutputOnly')

s.Rate = 8000


for step = 1:1
outputSingleScan(s,[1]);
pause(0.01)
outputSingleScan(s,[0]);
pause(0.01)
end
