function caBMI_pulse(s)


% start session: 
%  devices = daq.getDevices
%  s = daq.createSession('ni')
%  s.Rate = 8000
%  addDigitalChannel(s,'Dev5','port0/line0','OutputOnly')
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